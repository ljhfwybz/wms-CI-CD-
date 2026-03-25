# WMS 仓库管理系统 CI/CD 自动化部署平台

## 项目简介

基于现有仓库管理系统（WMS）构建的完整CI/CD自动化部署平台，包含Docker容器化、Jenkins Pipeline、Nginx负载均衡、运维脚本等。

## 技术栈

- **后端**: Spring Boot + MyBatis + MySQL + Redis
- **前端**: Vue 3 + Element Plus + Vite
- **容器化**: Docker + Docker Compose
- **CI/CD**: Jenkins Pipeline
- **反向代理**: Nginx

## 项目结构

```
wms/
├── backend/              # 后端Spring Boot应用
├── frontend/             # 前端Vue应用
├── db_script/            # 数据库脚本
├── docker/               # Docker相关文件
│   ├── backend/          # 后端Dockerfile
│   ├── frontend/         # 前端Dockerfile和Nginx配置
│   ├── nginx/            # Nginx负载均衡配置
│   └── docker-compose.yml # Docker Compose编排文件
├── ops/                  # 运维脚本
│   ├── backup-mysql.sh   # MySQL备份脚本
│   ├── cleanup-logs.sh   # 日志清理脚本
│   ├── health-check.sh   # 健康检查脚本
│   ├── start.sh          # 一键启动脚本
│   ├── stop.sh           # 一键停止脚本
│   └── deploy-blue-green.sh # 蓝绿部署脚本
├── Jenkinsfile           # Jenkins Pipeline配置
├── docs/                 # 文档目录
│   ├── CI_CD部署规范.md
│   └── 运维操作手册.md
└── README.md
```

## 快速开始

### 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- Jenkins 2.300+ (可选，用于CI/CD)

### 一键启动

```bash
cd wms/ops
chmod +x *.sh
./start.sh
```

### 访问应用

- 前端: http://localhost
- 后端API: http://localhost:9999/warehouse

### 默认账号

- 账号: `admin`
- 密码: `123456`

## 详细文档

详见 `docs/` 目录下的：

- [CI/CD部署规范.md](./docs/CI_CD部署规范.md)
- [运维操作手册.md](./docs/运维操作手册.md)

## CI/CD流程

1. **代码提交** → 触发Jenkins Pipeline
2. **Maven构建** → 编译并运行单元测试
3. **Docker打包** → 构建前后端镜像
4. **镜像推送** → 推送到私有镜像仓库
5. **自动部署** → 通过Docker Compose部署到生产环境

## 蓝绿部署

支持零停机发布，使用蓝绿部署策略：

```bash
cd wms/ops
./deploy-blue-green.sh green  # 部署到绿色环境
./deploy-blue-green.sh blue   # 部署到蓝色环境
```

## 运维脚本

| 脚本 | 功能 |
|------|------|
| backup-mysql.sh | MySQL定时备份 |
| cleanup-logs.sh | 日志自动清理 |
| health-check.sh | 容器健康检查 |
| start.sh | 一键启动所有服务 |
| stop.sh | 一键停止所有服务 |
| deploy-blue-green.sh | 蓝绿部署 |

## 许可证

本项目遵循原仓库许可证。
