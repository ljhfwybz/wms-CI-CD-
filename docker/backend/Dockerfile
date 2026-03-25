# 第一阶段：构建 (使用轻量级 Maven)
FROM maven:3.8.6-openjdk-11-slim AS builder

WORKDIR /app

# 1. 【关键修改】确保复制的是你改好的、带阿里云配置的那个 pom.xml
# 假设你的 Dockerfile 在 /docker/backend/ 目录下
# 我们向上两级去抓取 backend/warehouse_manager/ 里的 pom.xml
COPY ../../backend/warehouse_manager/pom.xml .

# 2. 【核心加速】不再依赖复杂的命令行参数，直接让它读 pom.xml 里的仓库配置
# 我们只保留跳过 SSL 检查的参数以防万一
RUN mvn dependency:go-offline -B \
    -Dmaven.wagon.http.ssl.insecure=true \
    -Dmaven.wagon.http.ssl.allowall=true

# 3. 复制源码
# 同样注意路径对齐：源码在子目录的 src 下
COPY ../../backend/warehouse_manager/src ./src

# 4. 执行打包
RUN mvn clean package -DskipTests -B


# 第二阶段：运行 (使用你选定的 JRE 镜像)
FROM eclipse-temurin:11-jre-alpine

WORKDIR /app

# 从构建阶段拷贝生成的 jar 包
COPY --from=builder /app/target/*.jar app.jar

# 设置时区（对仓库管理系统的时间戳很重要）
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 暴露后端端口
EXPOSE 9999

# 启动命令
ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-jar", "app.jar"]