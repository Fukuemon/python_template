# Notebook 開発ルール

## アーキテクチャ

### プロジェクト構成

```text
├── notebooks/           # Marimoノートブック
│   ├── analysis.py      # データ分析
│   └── visualization.py # 可視化
├── src/app/
│   ├── data.py          # データ読み込み・変換
│   └── utils.py         # ユーティリティ
└── data/                # データファイル（gitignore推奨）
```

### ノートブックとモジュールの分離

- 再利用可能なロジックは `src/` に配置
- ノートブックはデータ探索と可視化に集中

```python
# src/app/data.py
def load_sales_data(path: Path) -> pl.DataFrame:
    """売上データを読み込み、前処理を行う。"""
    return (
        pl.read_csv(path)
        .with_columns(pl.col("date").str.to_date())
        .filter(pl.col("amount") > 0)
    )

# notebooks/analysis.py (marimo)
from app.data import load_sales_data

df = load_sales_data(Path("data/sales.csv"))
```

## Marimo ベストプラクティス

### セル設計

各セルは単一の責任を持つ。

```python
@app.cell
def _():
    """データの読み込み"""
    import polars as pl
    df = pl.read_csv("data.csv")
    return df, pl

@app.cell
def _(df, pl):
    """データの前処理"""
    cleaned = df.filter(pl.col("value").is_not_null())
    return cleaned,

@app.cell
def _(cleaned, mo):
    """結果の表示"""
    mo.md(f"クリーニング後: {cleaned.height}行")
    return
```

### リアクティビティの活用

Marimoは依存関係を自動追跡。変数を変更すると依存セルが自動更新。

```python
@app.cell
def _(mo):
    # UIウィジェットで値を変更
    threshold = mo.ui.slider(0, 100, value=50, label="閾値")
    threshold
    return threshold,

@app.cell
def _(df, threshold, pl):
    # thresholdの変更で自動的に再実行
    filtered = df.filter(pl.col("score") > threshold.value)
    filtered
    return filtered,
```

### インタラクティブUI

```python
@app.cell
def _(mo):
    # スライダー
    slider = mo.ui.slider(1, 100, value=50)

    # ドロップダウン
    dropdown = mo.ui.dropdown(["A", "B", "C"], value="A")

    # チェックボックス
    checkbox = mo.ui.checkbox(label="フィルターを有効化")

    # テキスト入力
    text = mo.ui.text(placeholder="検索...")

    mo.hstack([slider, dropdown, checkbox, text])
    return slider, dropdown, checkbox, text
```

### マークダウン

```python
@app.cell
def _(mo, df):
    mo.md(
        f"""
        ## データサマリー

        - 行数: **{df.height}**
        - 列数: **{df.width}**

        ### カラム

        {', '.join(df.columns)}
        """
    )
    return
```

## Polars ベストプラクティス

### メソッドチェーン

```python
# Good - メソッドチェーンで読みやすく
result = (
    df
    .filter(pl.col("status") == "active")
    .group_by("category")
    .agg(
        pl.col("amount").sum().alias("total"),
        pl.col("amount").mean().alias("average"),
        pl.len().alias("count"),
    )
    .sort("total", descending=True)
)

# Bad - 中間変数が多い
filtered = df.filter(pl.col("status") == "active")
grouped = filtered.group_by("category")
aggregated = grouped.agg(...)
result = aggregated.sort("total", descending=True)
```

### 式（Expression）の活用

```python
# Good - 式を変数に格納して再利用
is_high_value = pl.col("amount") > 1000
is_recent = pl.col("date") > datetime(2024, 1, 1)

df.filter(is_high_value & is_recent)

# 複数の集計
df.group_by("category").agg(
    pl.col("amount").filter(is_high_value).sum().alias("high_value_total"),
    pl.col("amount").filter(~is_high_value).sum().alias("low_value_total"),
)
```

### パフォーマンス

```python
# Good - selectで必要な列のみ取得
df.select(["id", "name", "amount"])

# Good - lazyモードで最適化
result = (
    pl.scan_csv("large_file.csv")  # lazy読み込み
    .filter(pl.col("status") == "active")
    .select(["id", "amount"])
    .collect()  # ここで実行
)

# Bad - 全列読み込み後にフィルター
df = pl.read_csv("large_file.csv")
df = df.filter(...)
```

### よく使うパターン

```python
# 欠損値処理
df.with_columns(
    pl.col("value").fill_null(0),
    pl.col("name").fill_null("Unknown"),
)

# 型変換
df.with_columns(
    pl.col("date").str.to_date(),
    pl.col("amount").cast(pl.Float64),
)

# 条件分岐
df.with_columns(
    pl.when(pl.col("score") >= 80)
    .then(pl.lit("A"))
    .when(pl.col("score") >= 60)
    .then(pl.lit("B"))
    .otherwise(pl.lit("C"))
    .alias("grade")
)

# ウィンドウ関数
df.with_columns(
    pl.col("amount").sum().over("category").alias("category_total"),
    pl.col("amount").rank().over("category").alias("rank_in_category"),
)
```

## データ管理

### データファイルの扱い

```python
# Good - Pathを使用
from pathlib import Path

DATA_DIR = Path("data")
df = pl.read_csv(DATA_DIR / "sales.csv")

# 出力時はParquetを推奨（高速、型保持）
df.write_parquet(DATA_DIR / "processed.parquet")
```

### 大きなデータ

```python
# ストリーミング処理
result = (
    pl.scan_csv("huge_file.csv")
    .filter(...)
    .group_by(...)
    .agg(...)
    .collect(streaming=True)
)

# サンプリング
sample = pl.read_csv("huge_file.csv", n_rows=10000)
```

### .gitignore

```gitignore
# データファイル
data/*.csv
data/*.parquet
*.db

# ただしサンプルは含める
!data/sample.csv
```

## ノートブックの管理

### バージョン管理

Marimoノートブックは純粋なPythonファイルなので、Gitで管理可能。

```bash
# 差分確認
git diff notebooks/analysis.py
```

### 実行

```bash
# 編集モード（インタラクティブ）
uv run marimo edit notebooks/analysis.py

# 実行モード（読み取り専用）
uv run marimo run notebooks/analysis.py

# スクリプトとして実行
uv run python notebooks/analysis.py
```

### エクスポート

```bash
# HTMLとしてエクスポート
uv run marimo export html notebooks/analysis.py -o report.html
```
