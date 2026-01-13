---
name: lint
description: Run ruff linter and formatter. Use for code formatting, style checking, or fixing lint errors.
allowed-tools: Bash,Read,Edit
---

# Lint

ruff を使用してコードの静的解析とフォーマットを実行します。

## 基本コマンド

```bash
# Lint チェック
uv run ruff check .

# 自動修正付き Lint
uv run ruff check --fix .

# フォーマット
uv run ruff format .

# フォーマットチェックのみ
uv run ruff format --check .
```

## 手順

1. `uv run ruff check --fix .` で lint エラーを検出・自動修正
2. `uv run ruff format .` でコードをフォーマット
3. 自動修正できないエラーがあれば手動で修正
