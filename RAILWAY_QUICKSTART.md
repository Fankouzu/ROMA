# Railway 快速部署指南

## 文件说明

已为 Railway 部署创建了以下配置文件:

### 核心配置文件

1. **`railway.json`** - Railway 主配置文件 (JSON 格式)
   - 指定使用 Dockerfile 构建
   - 配置启动命令使用 `railway_start.sh`

2. **`railway.toml`** - Railway 配置文件 (TOML 格式,备选)
   - 与 `railway.json` 功能相同,使用 TOML 格式

3. **`railway_start.sh`** - 启动脚本
   - 自动读取 Railway 的 `$PORT` 环境变量
   - 启动 ROMA-DSPy API 服务器

4. **`Procfile`** - Procfile 启动文件 (备选)
   - Railway 可能使用此文件作为备选启动方式

5. **`.railwayignore`** - 忽略文件
   - 排除不需要的文件,减少构建时间和镜像大小

### 部署步骤

1. **连接 GitHub 仓库**
   - 登录 Railway: https://railway.app/
   - 创建新项目 → "Deploy from GitHub repo"
   - 选择你的 ROMA 仓库

2. **添加 PostgreSQL 服务**
   - 在项目中点击 "+ New" → "Database" → "Add PostgreSQL"
   - Railway 会自动提供 `DATABASE_URL` 环境变量

3. **配置环境变量**
   在 Railway 项目设置中添加:

   **必需变量:**
   ```bash
   OPENROUTER_API_KEY=your_key_here  # 或其他 LLM API key
   POSTGRES_ENABLED=true
   ```

   **可选变量:**
   ```bash
   E2B_API_KEY=your_key              # 代码执行
   EXA_API_KEY=your_key             # 网络搜索
   LOG_LEVEL=INFO                    # 日志级别
   ```

4. **部署**
   - Railway 会自动检测 Dockerfile 并开始构建
   - 构建完成后会自动部署
   - Railway 会提供一个公共 URL

5. **验证**
   ```bash
   curl https://your-app.railway.app/health
   ```

### 重要提示

- **端口**: Railway 自动设置 `$PORT` 环境变量,启动脚本会自动使用
- **数据库**: Railway 的 PostgreSQL 插件会自动提供 `DATABASE_URL`
- **存储**: 使用 Railway 的 PostgreSQL 存储元数据,如需大文件存储请配置外部 S3

### 详细文档

查看 `RAILWAY_DEPLOYMENT.md` 获取完整的部署指南和故障排除信息。

