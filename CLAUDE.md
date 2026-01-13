# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Copier template repository for Python projects. Contains templates for Web API, CLI, and Notebook projects.

## Repository Structure

```text
├── copier.yml              # Copier configuration
├── templates/
│   ├── web-api/            # FastAPI + SQLAlchemy template
│   │   └── .claude/        # Claude Code configuration
│   ├── cli/                # typer CLI template
│   │   └── .claude/        # Claude Code configuration
│   └── notebook/           # marimo + polars template
│       └── .claude/        # Claude Code configuration
└── README.md
```

## Template Usage

```bash
# Install copier
uv tool install copier

# Create project from template
copier copy gh:Fukuemon/python_template my-project
```

## Template Development

Each template in `templates/` contains:
- `pyproject.toml.jinja` - Project dependencies
- `src/{{_package_name}}/` - Source code with Jinja templates
- `CLAUDE.md.jinja` - Claude Code instructions for generated projects

## Jinja Variables

- `project_name` - Project name (e.g., my-app)
- `_package_name` - Python package name (e.g., my_app)
- `project_description` - Project description
- `python_version` - Python version (3.12, 3.13)
- `include_docker` - Include Dockerfile
- `include_github_actions` - Include CI/CD

## Claude Code Features

Each template includes `.claude/` directory with:

### Rules (`.claude/rules.md`, `.claude/python.md`)

Project-specific and common Python development rules:

- Type annotation best practices
- Error handling patterns
- Domain-driven design (web-api)
- CLI development patterns (cli)
- Data analysis patterns (notebook)

### Hooks (`.claude/settings.json`)

各テンプレートに以下の hooks を設定:

| Event | Matcher | 用途 |
|-------|---------|------|
| PostToolUse | `Write\|Edit` | Python ファイル編集時に ruff format/check --fix を自動実行 |
| PreToolUse | `Read\|Edit\|Write` | `.env` ファイルへのアクセスをブロック（セキュリティ） |
| SessionStart | `startup` | PYTHONPATH 環境変数を自動設定 |

### Skills (`.claude/skills/`)

| Template | Skills |
|----------|--------|
| web-api  | `test`, `lint`, `typecheck`, `migrate`, `server` |
| cli      | `test`, `lint`, `typecheck`, `run` |
| notebook | `lint`, `typecheck`, `edit`, `run`, `export` |

Skills は `SKILL.md` ファイルに YAML フロントマターで定義:

```yaml
---
name: test
description: Run pytest tests with coverage. Use when running tests...
allowed-tools: Bash,Read,Grep,Glob
---
```

### Permissions

Pre-approved bash commands for each template:

- `uv run ruff *` - Linting/formatting
- `uv run pyrefly *` - Type checking
- `uv run pytest *` - Testing (web-api, cli)
- `uv run alembic *` - Database migrations (web-api)
- `uv run uvicorn *` - Development server (web-api)
- `uv run marimo *` - Notebook operations (notebook)
- `uv sync *`, `uv add *` - 依存関係管理
