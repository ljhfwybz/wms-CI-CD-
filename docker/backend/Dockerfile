# 第一阶段：构建
FROM maven:3.8.6-openjdk-11-slim AS builder

WORKDIR /app

# 复制依赖文件
COPY pom.xml .

# 下载依赖（加速后续构建）
RUN mvn dependency:go-offline -B

# 复制源码
COPY src ./src

# 打包
RUN mvn clean package -DskipTests -B


# 第二阶段：运行
FROM eclipse-temurin:11-jre

WORKDIR /app

# 复制 jar
COPY --from=builder /app/target/*.jar app.jar

# 设置时区（避免时间问题）
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 暴露端口
EXPOSE 9999

# 启动
ENTRYPOINT ["java", "-jar", "app.jar"]