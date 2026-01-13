---
name: typecheck
description: Run pyrefly type checker. Use for type checking, finding type errors, or adding type annotations.
allowed-tools: Bash,Read,Edit
---

# Type Check

pyrefly を使用して型チェックを実行します。

## 基本コマンド

```bash
# 型チェック実行
uv run pyrefly check

# 特定ファイル
uv run pyrefly check src/app/main.py
```

## 手順

1. `uv run pyrefly check` で型エラーを検出
2. エラーがあれば型アノテーションを修正
3. 必要に応じて型の追加や修正を提案
