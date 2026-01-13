---
name: test
description: Run pytest tests for CLI application. Use when running tests, checking test results, or debugging test failures.
allowed-tools: Bash,Read,Grep,Glob
---

# Test

pytest を使用して CLI アプリケーションのテストを実行します。

## 基本コマンド

```bash
# 全テスト実行
uv run pytest

# カバレッジ付き
uv run pytest --cov

# 特定テスト
uv run pytest tests/test_main.py::test_hello

# 詳細出力
uv run pytest -v
```

## CLI テストのパターン

```python
from typer.testing import CliRunner
from app.main import app

runner = CliRunner()

def test_hello():
    result = runner.invoke(app, ["hello", "World"])
    assert result.exit_code == 0
    assert "World" in result.output
```

## 手順

1. `uv run pytest` でテストを実行
2. 失敗したテストがあれば原因を分析
3. 必要に応じてテストコードまたは実装を修正
