# 第一阶段：构建
FROM maven:3.8.6-openjdk-11-slim AS builder

WORKDIR /app

# 复制 pom.xml（context 已经是 backend/warehouse_manager）
COPY pom.xml .

# 下载依赖
RUN mvn dependency:go-offline -B

# 复制源码
COPY src ./src

# 打包
RUN mvn clean package -DskipTests -B


# 第二阶段：运行
FROM eclipse-temurin:11-jre-alpine

WORKDIR /app

# 复制 jar 包
COPY --from=builder /app/target/*.jar app.jar

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 暴露端口
EXPOSE 9999

# 启动命令
ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-jar", "app.jar"]
