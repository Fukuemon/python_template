---
name: test
description: Run pytest tests with coverage. Use when running tests, checking test results, or debugging test failures.
allowed-tools: Bash,Read,Grep,Glob
---

# Test

pytest を使用してテストを実行します。

## 基本コマンド

```bash
# 全テスト実行
uv run pytest

# カバレッジ付き
uv run pytest --cov

# 特定ファイル
uv run pytest tests/test_users.py

# 特定テスト関数
uv run pytest tests/test_users.py::test_create_user

# 詳細出力
uv run pytest -v

# 失敗時に即停止
uv run pytest -x
```

## 手順

1. `uv run pytest` でテストを実行
2. 失敗したテストがあれば原因を分析
3. 必要に応じてテストコードまたは実装を修正
