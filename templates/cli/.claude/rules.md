# CLI 開発ルール

## アーキテクチャ

### プロジェクト構成

```text
src/app/
├── main.py        # Typerアプリケーション、コマンド定義
├── config.py      # 設定管理
├── __main__.py    # python -m エントリポイント
└── utils.py       # ユーティリティ関数（必要に応じて）
```

### 大規模CLIの場合

コマンドが増えた場合はサブコマンドごとにファイル分割。

```text
src/app/
├── main.py           # メインアプリ、サブコマンド登録
├── config.py
├── commands/
│   ├── __init__.py
│   ├── user.py       # user サブコマンド群
│   └── project.py    # project サブコマンド群
└── utils.py
```

```python
# main.py
import typer
from app.commands import user, project

app = typer.Typer()
app.add_typer(user.app, name="user")
app.add_typer(project.app, name="project")
```

## Typer ベストプラクティス

### コマンド定義

```python
from typing import Annotated
import typer

app = typer.Typer()

@app.command()
def hello(
    name: Annotated[str, typer.Argument(help="挨拶する相手の名前")],
    count: Annotated[int, typer.Option("--count", "-c", help="挨拶の回数")] = 1,
    formal: Annotated[bool, typer.Option("--formal", "-f", help="丁寧な挨拶")] = False,
) -> None:
    """NAMEに挨拶する。"""
    greeting = "こんにちは" if formal else "やあ"
    for _ in range(count):
        typer.echo(f"{greeting}、{name}！")
```

### 引数とオプション

- **引数（Argument）**: 必須の位置引数
- **オプション（Option）**: `--name` 形式のオプショナルな値
- **フラグ**: `--verbose` のようなブール値

```python
@app.command()
def process(
    # 必須の位置引数
    input_file: Annotated[Path, typer.Argument(help="入力ファイル")],
    # オプション（デフォルト値あり）
    output: Annotated[Path, typer.Option("--output", "-o", help="出力先")] = Path("output.txt"),
    # フラグ
    verbose: Annotated[bool, typer.Option("--verbose", "-v", help="詳細出力")] = False,
) -> None:
    ...
```

### ヘルプテキスト

- コマンドのdocstringがヘルプに表示される
- 引数・オプションには `help` パラメータで説明を追加

### 出力

#### Rich を使用したリッチな出力

```python
from rich.console import Console
from rich.table import Table

console = Console()

# テーブル出力
table = Table(title="ユーザー一覧")
table.add_column("ID", style="cyan")
table.add_column("名前", style="green")
table.add_row("1", "Alice")
console.print(table)

# 色付きテキスト
console.print("[green]成功！[/green]")
console.print("[red]エラー: ファイルが見つかりません[/red]")

# プログレスバー
from rich.progress import track
for item in track(items, description="処理中..."):
    process(item)
```

#### 標準出力 vs 標準エラー

```python
# 正常な出力 → stdout
typer.echo("処理結果: 100件")

# エラーやログ → stderr
typer.echo("警告: ファイルが大きいです", err=True)
```

### エラーハンドリング

```python
@app.command()
def process(file: Path) -> None:
    if not file.exists():
        typer.echo(f"エラー: {file} が見つかりません", err=True)
        raise typer.Exit(code=1)

    try:
        result = do_process(file)
    except ProcessError as e:
        typer.echo(f"処理エラー: {e}", err=True)
        raise typer.Exit(code=1)

    typer.echo(f"完了: {result}")
```

### 確認プロンプト

```python
@app.command()
def delete(
    name: str,
    force: Annotated[bool, typer.Option("--force", "-f")] = False,
) -> None:
    """項目を削除する。"""
    if not force:
        confirm = typer.confirm(f"{name} を削除しますか？")
        if not confirm:
            typer.echo("キャンセルしました")
            raise typer.Abort()

    do_delete(name)
    typer.echo(f"{name} を削除しました")
```

### 入力プロンプト

```python
@app.command()
def login() -> None:
    """ログインする。"""
    username = typer.prompt("ユーザー名")
    password = typer.prompt("パスワード", hide_input=True)
    # ...
```

## 設定管理

### 環境変数と設定ファイル

```python
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="MYAPP_",
    )

    api_key: str = ""
    debug: bool = False
    output_dir: Path = Path("./output")

settings = Settings()
```

### 設定ファイルの場所

```python
from pathlib import Path

def get_config_dir() -> Path:
    """OSに応じた設定ディレクトリを返す。"""
    if sys.platform == "win32":
        base = Path(os.environ.get("APPDATA", "~"))
    elif sys.platform == "darwin":
        base = Path("~/Library/Application Support")
    else:
        base = Path(os.environ.get("XDG_CONFIG_HOME", "~/.config"))
    return base.expanduser() / "myapp"
```

## テスト

### CLIテスト

```python
from typer.testing import CliRunner
from app.main import app

runner = CliRunner()

def test_hello() -> None:
    result = runner.invoke(app, ["hello", "World"])
    assert result.exit_code == 0
    assert "World" in result.output

def test_hello_with_count() -> None:
    result = runner.invoke(app, ["hello", "World", "--count", "3"])
    assert result.exit_code == 0
    assert result.output.count("World") == 3

def test_missing_argument() -> None:
    result = runner.invoke(app, ["hello"])
    assert result.exit_code != 0
```

### 入力のモック

```python
def test_with_input() -> None:
    result = runner.invoke(app, ["login"], input="user\npassword\n")
    assert result.exit_code == 0
```
