# ========================================
# Builder Stage: 依存関係のインストール
# ========================================
FROM python:3.14-slim AS builder

WORKDIR /app

# uvのインストールと設定
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# 依存関係キャッシュを効かせるために先にpyproject.tomlとuv.lockだけコピー
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project

# アプリケーションコードをコピー
COPY . .

# プロジェクトのインストール
RUN uv sync --frozen

# ========================================
# Runtime Stage: 最小限の実行環境
# ========================================
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# distrolessでは65532が非rootユーザーとして推奨されている
USER 65532

# builderから必要なファイルだけコピー
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src /app/src
COPY --from=builder /app/pyproject.toml /app/pyproject.toml

# 環境変数でPythonパスを設定
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH="/app"

# メインコマンド（固定）
ENTRYPOINT ["python", "-m", "uvicorn"]

# 可変部分（例：ポートなど）
CMD ["main:app", "--host", "0.0.0.0", "--port", "8000"]