---
name: migrate
description: Run Alembic database migrations. Use for creating migrations, applying schema changes, or rolling back.
allowed-tools: Bash,Read,Edit,Glob
---

# Database Migration

Alembic を使用してデータベースマイグレーションを管理します。

## 基本コマンド

```bash
# マイグレーション適用
uv run alembic upgrade head

# マイグレーション作成（自動生成）
uv run alembic revision --autogenerate -m "Add users table"

# マイグレーション作成（手動）
uv run alembic revision -m "Add index"

# ロールバック（1つ前）
uv run alembic downgrade -1

# 現在のリビジョン確認
uv run alembic current

# マイグレーション履歴
uv run alembic history
```

## 手順

1. モデル変更後、`uv run alembic revision --autogenerate -m "説明"` で自動生成
2. 生成されたマイグレーションファイルを確認
3. `uv run alembic upgrade head` で適用
