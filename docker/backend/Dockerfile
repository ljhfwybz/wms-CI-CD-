# 第一阶段：构建 (使用更快的编译镜像)
FROM maven:3.8.6-openjdk-11-slim AS builder

WORKDIR /app

# 1. 复制 pom.xml
COPY pom.xml .

# 2. 【核心优化】直接在命令行指定阿里云镜像源，避免下载缓慢
RUN mvn dependency:go-offline -B \
    -Dmaven.wagon.http.ssl.insecure=true \
    -Dmaven.wagon.http.ssl.allowall=true \
    -DremoteRepositories=https://maven.aliyun.com/repository/public

# 3. 复制源码并打包
COPY src ./src
RUN mvn clean package -DskipTests -B \
    -DremoteRepositories=https://maven.aliyun.com/repository/public


# 第二阶段：运行 (保持你改好的 eclipse-temurin)
FROM eclipse-temurin:11-jre-alpine

WORKDIR /app

# 复制 jar (使用通配符确保匹配)
COPY --from=builder /app/target/*.jar app.jar

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

EXPOSE 9999

ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-jar", "app.jar"]