---
name: server
description: Start FastAPI development server with uvicorn. Use for running the API locally or testing endpoints.
allowed-tools: Bash
---

# Development Server

uvicorn を使用して FastAPI 開発サーバーを起動します。

## 基本コマンド

```bash
# 開発サーバー起動（ホットリロード有効）
uv run uvicorn app.main:app --reload

# ポート指定
uv run uvicorn app.main:app --reload --port 8080

# ホスト指定（外部アクセス許可）
uv run uvicorn app.main:app --reload --host 0.0.0.0
```

## エンドポイント

- API: http://localhost:8000
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 手順

1. `uv run uvicorn app.main:app --reload` でサーバー起動
2. ブラウザで http://localhost:8000/docs を開いて動作確認
