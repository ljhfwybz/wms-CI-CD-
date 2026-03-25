# 第一阶段：编译环境
FROM node:16-alpine AS builder

WORKDIR /app

# 1. 先复制依赖清单
COPY package*.json ./

# 2. 【核心优化】使用阿里云镜像加速 npm 依赖下载
RUN npm config set registry https://registry.npmmirror.com && \
    npm install

# 3. 复制剩余源码并执行构建
COPY . .
RUN npm run build


# 第二阶段：运行环境 (使用轻量级 Nginx)
FROM nginx:alpine

# 从 builder 阶段拷贝打包好的静态文件到 Nginx 目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 拷贝自定义的 nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]