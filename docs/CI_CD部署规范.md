# WMS CI/CD 部署规范

## 1. 概述

本文档规范了WMS仓库管理系统的CI/CD流程，确保代码从提交到部署的标准化、自动化和可追溯。

## 2. 代码管理规范

### 2.1 分支策略

```
main (生产环境)
  ↓
develop (开发环境)
  ↓
feature/* (功能分支)
hotfix/* (热修复分支)
```

### 2.2 提交规范

使用语义化提交信息：

```
<type>(<scope>): <subject>

<type> 类型：
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式调整
- refactor: 重构
- test: 测试相关
- chore: 构建/工具链相关

示例：
feat(user): 添加用户管理功能
fix(login): 修复登录验证码问题
```

## 3. 构建规范

### 3.1 Maven构建配置

```xml
<!-- pom.xml -->
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

### 3.2 Docker镜像构建

**多阶段构建原则：**
1. 第一阶段：使用maven镜像编译打包
2. 第二阶段：使用openjdk:11-jre-slim运行
3. 最终镜像体积 < 200MB

## 4. 测试规范

### 4.1 单元测试

- 测试覆盖率目标：≥ 70%
- 测试文件命名：`*Test.java`
- 测试方法命名：`test_<方法名>_<场景>`

### 4.2 集成测试

- 测试文件命名：`*IT.java`
- 使用测试容器（Testcontainers）

## 5. 部署规范

### 5.1 环境分类

| 环境 | 用途 | 访问地址 |
|------|------|----------|
| DEV | 开发环境 | dev.wms.example.com |
| TEST | 测试环境 | test.wms.example.com |
| UAT | 用户验收环境 | uat.wms.example.com |
| PROD | 生产环境 | wms.example.com |

### 5.2 蓝绿部署流程

```
1. 部署新版本到备用环境（如green）
2. 健康检查备用环境
3. 切换Nginx流量到备用环境
4. 观察运行状态（5-10分钟）
5. 如正常，下线旧环境（如blue）
6. 如异常，快速回滚
```

### 5.3 回滚策略

- 自动回滚：健康检查失败自动触发
- 手动回滚：`./deploy-blue-green.sh <previous_env>`
- 回滚时间目标：< 2分钟

## 6. 镜像仓库规范

### 6.1 镜像命名

```
<registry>/<project>/<service>:<tag>

示例：
localhost:5000/wms/wms-backend:v1.0.0
localhost:5000/wms/wms-backend:20240101-1200
localhost:5000/wms/wms-backend:latest
```

### 6.2 版本标签

- 语义化版本：`v1.0.0`
- 构建号：`build-<number>`
- Git提交：`git-<hash>`
- 日期时间：`YYYYMMDD-HHMM`

## 7. Jenkins Pipeline规范

### 7.1 Pipeline阶段

```
1. Checkout     → 拉取代码
2. Build        → Maven构建
3. Test         → 运行单元测试
4. Docker Build → 构建Docker镜像
5. Push         → 推送镜像
6. Deploy       → 部署到环境
```

### 7.2 质量门禁

| 检查项 | 通过标准 |
|--------|----------|
| 编译 | 无错误 |
| 单元测试 | 通过率 100% |
| 测试覆盖率 | ≥ 70% |
| 镜像安全扫描 | 无高危漏洞 |

## 8. 监控与告警

### 8.1 关键指标

- 构建成功率
- 部署频率
- 平均修复时间（MTTR）
- 平均部署时间

### 8.2 告警规则

- 构建失败：立即告警
- 部署失败：立即告警
- 健康检查失败：5分钟内告警
- 测试覆盖率下降：每日告警

## 9. 安全规范

### 9.1 敏感信息管理

- 不将敏感信息提交到代码库
- 使用环境变量或配置中心
- 密钥定期轮换（90天）

### 9.2 镜像安全

- 使用官方基础镜像
- 定期更新基础镜像
- 扫描镜像漏洞（Trivy）

## 10. 文档维护

- 本文档每季度评审一次
- 重大流程变更及时更新
- 变更记录保存在变更日志中
