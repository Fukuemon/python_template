---
name: run
description: Run the CLI application. Use for executing CLI commands, testing functionality, or demonstrating features.
allowed-tools: Bash
---

# Run CLI

CLI アプリケーションを実行します。

## 基本コマンド

```bash
# ヘルプ表示
uv run python -m app --help

# コマンド実行
uv run python -m app hello World

# オプション付き
uv run python -m app hello World --count 3 --formal
```

## 手順

1. `uv run python -m app --help` でコマンド一覧を確認
2. 必要なコマンドを実行
3. 出力を確認して動作を検証
