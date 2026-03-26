# 第一阶段：编译
FROM node:16-alpine AS builder

WORKDIR /app

# 覆盖前端构建期环境：确保资源请求走 Nginx（/warehouse 前缀），避免依赖宿主的 9999 端口
ARG VITE_WAREHOUSE_CONTEXT_PATH=/warehouse
ENV VITE_WAREHOUSE_CONTEXT_PATH=$VITE_WAREHOUSE_CONTEXT_PATH

# 复制依赖文件
COPY package*.json ./

# 设置镜像源并安装依赖
RUN npm config set registry https://registry.npmmirror.com && \
    npm install

# 复制源码
COPY . .

# 构建
RUN npm run build


# 第二阶段：运行
FROM nginx:alpine

# 复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制 nginx 配置
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
