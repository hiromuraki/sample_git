# ==========================================
# 第一阶段：构建环境 (使用 uv 官方镜像)
# ==========================================
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

# 设置环境变量：不生成 .venv 目录，而是直接安装到系统目录 (Docker里不需要隔离)
# 并且开启字节码编译，加快启动速度
ENV UV_COMPILE_BYTECODE=1 
ENV UV_LINK_MODE=copy

WORKDIR /app

# 1. 先拷贝依赖定义文件 (利用 Docker 缓存层)
COPY pyproject.toml uv.lock ./

# 2. 安装依赖
# --frozen: 严格按照 lock 文件安装，不更新版本
# --no-install-project: 只安装依赖，不安装当前项目本身
# --no-dev: 不安装开发依赖
RUN uv sync --frozen --no-install-project --no-dev

# ==========================================
# 第二阶段：运行环境 (极简 Distroless 或 Slim)
# ==========================================
FROM python:3.12-slim-bookworm

WORKDIR /app

# 关键：从 builder 阶段把安装好的包 (site-packages) 拷过来
# 注意：uv 安装到系统路径通常在 /usr/local/lib/python3.12/site-packages
# 但为了简单通用，我们将 builder 的整个 PATH 拷过来，或者更简单的：
# 既然第一阶段已经安装到系统目录，我们直接用 builder 阶段的环境
# 这里为了演示极致优化，我们复用 slim 镜像，并把 PATH 加进去
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# 拷贝代码
COPY main.py .

# 启动
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
