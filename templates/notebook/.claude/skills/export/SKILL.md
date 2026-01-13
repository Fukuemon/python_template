---
name: export
description: Export marimo notebook to HTML, Markdown, or Jupyter format. Use for sharing notebooks or creating documentation.
allowed-tools: Bash,Read
---

# Export Notebook

marimo ノートブックを他の形式にエクスポートします。

## 基本コマンド

```bash
# HTML にエクスポート
uv run marimo export html src/app/main.py -o output.html

# Markdown にエクスポート
uv run marimo export md src/app/main.py -o output.md

# Jupyter Notebook 形式
uv run marimo export ipynb src/app/main.py -o output.ipynb

# スクリプトとして実行（出力なし）
uv run marimo export script src/app/main.py
```

## 対応形式

| 形式 | 拡張子 | 用途 |
|------|--------|------|
| HTML | `.html` | インタラクティブな Web ページ |
| Markdown | `.md` | ドキュメント、README |
| Jupyter | `.ipynb` | Jupyter 互換環境 |
| Script | `.py` | 実行可能スクリプト |

## 手順

1. エクスポート形式を選択
2. `uv run marimo export <format> <file> -o <output>` を実行
3. 出力ファイルを確認
