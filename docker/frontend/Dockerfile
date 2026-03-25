# 第一阶段：编译阶段 (使用轻量级 Node)
FROM node:16-alpine AS build-stage

WORKDIR /app

# 1. 【关键：路径对齐】
# 根据你的 find 结果，我们需要向上跳两级，进入前端实际目录抓取配置文件
COPY ../../frontend/warehouse_boot_pc/package*.json ./

# 2. 【核心加速】设置阿里云镜像源并安装依赖
RUN npm config set registry https://registry.npmmirror.com && \
    npm install

# 3. 【关键：路径对齐】复制前端所有源码并构建
COPY ../../frontend/warehouse_boot_pc/ .
RUN npm run build

# 第二阶段：生产阶段 (使用 Nginx 托管)
FROM nginx:stable-alpine

# 从编译阶段拷贝打包好的 dist 文件夹到 Nginx 运行目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]