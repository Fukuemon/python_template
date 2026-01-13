---
name: run
description: Run marimo notebook in app mode. Use for viewing notebooks as read-only apps or presentations.
allowed-tools: Bash
---

# Run Notebook

marimo ノートブックをアプリモードで実行します。

## 基本コマンド

```bash
# アプリモードで実行
uv run marimo run src/app/main.py

# 特定ファイルを実行
uv run marimo run notebooks/dashboard.py
```

## 特徴

- **読み取り専用**: セルの編集は不可
- **インタラクティブ**: ウィジェット（スライダー等）は操作可能
- **プレゼン向き**: デモや発表に最適

## アクセス

- アプリ: http://localhost:2718

## 手順

1. `uv run marimo run <file>` でアプリを起動
2. ブラウザでインタラクティブに操作
