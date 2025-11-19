# Railway Deployment Guide for ROMA-DSPy

This guide explains how to deploy ROMA-DSPy to Railway.com using GitHub integration.

## Prerequisites

- A Railway account (sign up at https://railway.app/)
- A GitHub account with your ROMA repository
- Required API keys (see Environment Variables section)

## Quick Start

### 1. Connect GitHub Repository

1. Log in to [Railway Dashboard](https://railway.app/)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Authorize Railway to access your GitHub account
5. Select your ROMA repository

### 2. Add PostgreSQL Service

Railway provides managed PostgreSQL. Add it to your project:

1. In your Railway project, click **"+ New"**
2. Select **"Database"** → **"Add PostgreSQL"**
3. Railway will automatically create a PostgreSQL database
4. The connection string will be available as `DATABASE_URL` environment variable

### 3. Configure Environment Variables

In Railway project settings, add the following environment variables:

#### Required Variables

```bash
# LLM Provider (at least one required)
OPENROUTER_API_KEY=your_key_here        # Recommended
# OR
OPENAI_API_KEY=your_key_here
ANTHROPIC_API_KEY=your_key_here
GOOGLE_API_KEY=your_key_here

# Database (Railway automatically provides DATABASE_URL)
# You may need to set:
POSTGRES_ENABLED=true
# Railway will provide DATABASE_URL automatically

# Port (Railway sets this automatically, but ensure your app uses $PORT)
PORT=8000
```

#### Optional Variables

```bash
# Toolkit API Keys
E2B_API_KEY=your_key_here              # Code execution
EXA_API_KEY=your_key_here              # Web search via MCP
SERPER_API_KEY=your_key_here           # Web search toolkit
GITHUB_PERSONAL_ACCESS_TOKEN=your_token # GitHub MCP server
COINGECKO_API_KEY=your_key_here        # CoinGecko Pro API

# MLflow (if using external MLflow instance)
MLFLOW_TRACKING_URI=https://your-mlflow-instance.com
MLFLOW_ENABLE_TRACE_V4=true

# Storage (if using external S3)
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
MLFLOW_S3_ENDPOINT_URL=https://s3.amazonaws.com
MLFLOW_DEFAULT_ARTIFACT_ROOT=s3://your-bucket/mlflow

# Security
ALLOWED_ORIGINS=https://yourdomain.com  # CORS origins (comma-separated)

# Logging
LOG_LEVEL=INFO                          # DEBUG, INFO, WARNING, ERROR
```

### 4. Deploy

Railway will automatically:
1. Detect the `Dockerfile` in your repository
2. Build the Docker image
3. Deploy the application
4. Assign a public URL

### 5. Verify Deployment

Once deployed, Railway will provide a public URL. Test it:

```bash
# Health check
curl https://your-app.railway.app/health

# API documentation
open https://your-app.railway.app/docs
```

## Configuration Files

### railway.json / railway.toml

These files configure Railway deployment settings:
- **Builder**: Uses Dockerfile
- **Start Command**: Runs the ROMA API server
- **Port**: Uses Railway's `$PORT` environment variable
- **Health Check**: Configured to check `/health` endpoint

### .railwayignore

Excludes unnecessary files from deployment to reduce build time and image size.

## Important Notes

### Port Configuration

Railway assigns a dynamic port via the `$PORT` environment variable. The application is configured to use this port automatically.

### Database Connection

Railway's PostgreSQL plugin automatically provides:
- `DATABASE_URL` environment variable
- Connection pooling
- Automatic backups

The application will use this connection string automatically.

### Storage Considerations

Railway provides ephemeral storage. For persistent storage:

1. **Use Railway Volumes** (for small files):
   - Add a volume in Railway dashboard
   - Mount it in your service

2. **Use External S3** (recommended for MLflow artifacts):
   - Configure AWS credentials
   - Set `MLFLOW_S3_ENDPOINT_URL` and `MLFLOW_DEFAULT_ARTIFACT_ROOT`

3. **Use Railway's PostgreSQL** (for metadata):
   - Execution metadata, checkpoints, and traces are stored in PostgreSQL
   - This is automatically configured

### MinIO Alternative

Since Railway doesn't support running MinIO alongside your app, you have two options:

1. **Skip MinIO** (if not using MLflow artifacts):
   - Don't set MLflow artifact storage variables
   - Traces will still be stored in PostgreSQL (V4 traces)

2. **Use External S3**:
   - Set up AWS S3 or compatible service
   - Configure `MLFLOW_S3_ENDPOINT_URL` and related variables

### MLflow Deployment

If you need MLflow tracking:

1. **Option 1**: Deploy MLflow separately (another Railway service or external)
2. **Option 2**: Use MLflow's managed service
3. **Option 3**: Use MLflow V4 traces (stored in PostgreSQL, no artifacts needed)

## Monitoring

Railway provides:
- **Logs**: View real-time logs in Railway dashboard
- **Metrics**: CPU, memory, and network usage
- **Health Checks**: Automatic health monitoring

## Troubleshooting

### Build Fails

- Check Railway build logs
- Verify Dockerfile syntax
- Ensure all dependencies are in `pyproject.toml`

### Application Won't Start

- Check environment variables are set correctly
- Verify `DATABASE_URL` is available (if using PostgreSQL)
- Check logs for connection errors

### Database Connection Issues

- Ensure PostgreSQL service is added to your project
- Verify `DATABASE_URL` is set correctly
- Check that `POSTGRES_ENABLED=true` is set

### Port Issues

- Ensure your application uses `$PORT` environment variable
- Railway assigns ports dynamically

## Scaling

Railway allows you to:
- Scale horizontally (multiple instances)
- Adjust resource limits (CPU, memory)
- Configure auto-scaling based on traffic

Access these settings in Railway dashboard → Your Service → Settings.

## Custom Domain

To use a custom domain:

1. Go to Railway dashboard → Your Service → Settings
2. Click "Generate Domain" or "Add Custom Domain"
3. Configure DNS records as instructed

## Cost Optimization

- Use Railway's free tier for development
- Monitor resource usage
- Consider using external S3 for large artifacts
- Use PostgreSQL for metadata (included in Railway)

## Support

For Railway-specific issues:
- Railway Docs: https://docs.railway.app/
- Railway Discord: https://discord.gg/railway

For ROMA-DSPy issues:
- Check project README.md
- Review deployment logs
- Open an issue on GitHub

