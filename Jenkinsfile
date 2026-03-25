pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        BACKEND_IMAGE = "${DOCKER_REGISTRY}/wms-backend:${BUILD_NUMBER}"
        FRONTEND_IMAGE = "${DOCKER_REGISTRY}/wms-frontend:${BUILD_NUMBER}"
        GIT_URL = 'https://github.com/DeepSpyder/wms.git'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                        sh 'docker-compose down'
                        sh 'docker-compose up -d'
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
