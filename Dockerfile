# 第一阶段：构建环境
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

WORKDIR /app

# 1. 先拷贝依赖定义 (利用 Docker 缓存)
COPY pyproject.toml uv.lock ./

# 2. 安装依赖 (不安装 dev 依赖，--no-install-project 表示只装库不装当前项目代码)
RUN uv sync --frozen --no-dev --no-install-project

# 3. 拷贝源代码
COPY . .

# 4. 再次同步 (这时候才安装项目本身，极快)
RUN uv sync --frozen --no-dev

# 第二阶段：运行环境 (极简 distroless 或 slim)
FROM python:3.12-slim-bookworm

WORKDIR /app

# 从 builder 阶段拷贝虚拟环境
COPY --from=builder /app/.venv /app/.venv

# 将虚拟环境加入 PATH，这样直接敲 python 就是用虚拟环境的
ENV PATH="/app/.venv/bin:$PATH"

COPY src ./src

# 启动命令
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]