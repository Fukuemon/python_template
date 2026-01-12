# Python Template

[Copier](https://copier.readthedocs.io/)を使用したPythonプロジェクトテンプレート。プロジェクトタイプを選択して、すぐに開発を始められます。

## プロジェクトタイプ

| タイプ | 説明 | 主な依存 |
|--------|------|----------|
| **Web API** | FastAPI RESTful API | fastapi, sqlalchemy, alembic, pydantic |
| **CLI** | コマンドラインツール | typer, rich, pydantic |
| **Notebook** | データ分析 | marimo, polars |

## 使い方

### 1. Copierをインストール

```bash
uv tool install copier
# または
pipx install copier
```

### 2. プロジェクトを作成

```bash
copier copy gh:Fukuemon/python_template my-project
```

対話形式で以下を選択:

1. **プロジェクトタイプ**: Web API / CLI / Notebook
2. **プロジェクト名**: my-awesome-app
3. **Pythonバージョン**: 3.12 / 3.13
4. **オプション**: Dockerfile, GitHub Actions

### 3. セットアップ

```bash
cd my-project
uv sync
```

## 各テンプレートの詳細

### Web API

[zhanymkanov/fastapi-best-practices](https://github.com/zhanymkanov/fastapi-best-practices)を参考にしたドメイン駆動設計。

```text
src/myapp/
├── main.py          # FastAPI app
├── config.py        # Settings
├── database.py      # SQLAlchemy
├── exceptions.py    # Global exceptions
└── users/           # Domain module
    ├── router.py    # Endpoints
    ├── schemas.py   # Pydantic models
    ├── models.py    # DB models
    └── service.py   # Business logic
```

```bash
uv run uvicorn myapp.main:app --reload
uv run alembic upgrade head
```

### CLI

typer + richによるモダンなCLIアプリケーション。

```text
src/myapp/
├── main.py      # Typer app
├── config.py    # Settings
└── __main__.py  # python -m entry
```

```bash
uv run myapp --help
uv run myapp hello World
```

### Notebook

marimoによるリアクティブなPythonノートブック。

```text
notebooks/
└── example.py   # Marimo notebook
src/myapp/
└── data.py      # Data utilities
```

```bash
uv run marimo edit notebooks/example.py
```

## テンプレートの更新

```bash
copier update
```

## 開発ツール

| ツール | 用途 |
|--------|------|
| [uv](https://docs.astral.sh/uv/) | パッケージマネージャー |
| [ruff](https://docs.astral.sh/ruff/) | リンター・フォーマッター |
| [pyrefly](https://pyrefly.org/) | 型チェッカー |
| [pytest](https://docs.pytest.org/) | テストフレームワーク |

## 参考

- [FastAPI Best Practices](https://github.com/zhanymkanov/fastapi-best-practices)
- [src layout vs flat layout](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/)
- [marimo](https://marimo.io/)
- [Copier](https://copier.readthedocs.io/)

## ライセンス

MIT
