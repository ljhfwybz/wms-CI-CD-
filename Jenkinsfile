pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        BACKEND_IMAGE = "${DOCKER_REGISTRY}/wms-backend:${BUILD_NUMBER}"
        FRONTEND_IMAGE = "${DOCKER_REGISTRY}/wms-frontend:${BUILD_NUMBER}"
        GIT_URL = 'https://github.com/DeepSpyder/wms.git'

        // 覆盖 Spring 配置：确保 mvn test 阶段能连到 CI/本机 Docker 的 MySQL/Redis
        SPRING_DATASOURCE_URL = 'jdbc:mysql://localhost:3306/db_warehouse?serverTimezone=UTC&useSSL=false'
        SPRING_DATASOURCE_USERNAME = 'root'
        SPRING_DATASOURCE_PASSWORD = 'ljh'
        SPRING_REDIS_HOST = 'localhost'
        SPRING_REDIS_PORT = '6379'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Start Test Dependencies') {
            steps {
                dir('docker') {
                    // 启动 mysql/redis，供 mvn test 阶段的 Spring Boot 读取
                    sh 'docker-compose up -d mysql redis'

                    // 等待 MySQL 健康
                    sh 'i=0; while [ $i -lt 30 ]; do docker exec wms_mysql mysqladmin ping -hlocalhost -uroot -pljh >/dev/null 2>&1 && break; i=$((i+1)); sleep 2; done'
                    // 等待 Redis 健康
                    sh 'i=0; while [ $i -lt 30 ]; do docker exec wms_redis redis-cli ping >/dev/null 2>&1 && break; i=$((i+1)); sleep 2; done'
                }
            }
        }

        stage('Backend Build & Test') {
            steps {
                dir('backend/warehouse_manager') {
                    sh 'mvn clean test -B'
                }
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                dir('docker') {
                    script {
                        sh 'docker build -f backend/Dockerfile -t ${BACKEND_IMAGE} ../backend/warehouse_manager'
                        sh 'docker build -f frontend/Dockerfile -t ${FRONTEND_IMAGE} ../frontend/warehouse_boot_pc'
                    }
                }
            }
        }

        stage('Push Docker Images') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh 'docker push ${BACKEND_IMAGE}'
                    sh 'docker push ${FRONTEND_IMAGE}'
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                dir('docker') {
                    script {
                        // 确保对外网关就绪（不会强行启动/拉起两个后端）
                        sh 'docker-compose up -d nginx-lb'

                        // 根据当前运行的后端切到另一套（blue/green 交替）
                        sh '''
                          if docker-compose ps | grep "backend-green" | grep -q "Up"; then
                            bash ../ops/deploy-blue-green.sh blue
                          else
                            bash ../ops/deploy-blue-green.sh green
                          fi
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
