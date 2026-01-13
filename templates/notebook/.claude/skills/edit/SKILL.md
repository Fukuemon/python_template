---
name: edit
description: Open marimo notebook in edit mode. Use for editing notebooks, creating cells, or modifying code interactively.
allowed-tools: Bash
---

# Edit Notebook

marimo ノートブックをエディタモードで起動します。

## 基本コマンド

```bash
# デフォルトノートブックを編集
uv run marimo edit src/app/main.py

# 特定ファイルを編集
uv run marimo edit notebooks/analysis.py

# 新規ノートブック作成
uv run marimo edit new_notebook.py
```

## 特徴

- **リアクティブ**: セルを編集すると依存セルが自動再実行
- **純粋な Python**: `.py` ファイルとして保存（git 管理可能）
- **型安全**: 静的解析ツールと互換性あり

## アクセス

- エディタ: http://localhost:2718

## 手順

1. `uv run marimo edit <file>` でエディタを起動
2. ブラウザでノートブックを編集
3. 変更は自動保存される
