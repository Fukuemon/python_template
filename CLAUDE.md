# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Copier template repository for Python projects. Contains templates for Web API, CLI, and Notebook projects.

## Repository Structure

```text
├── copier.yml              # Copier configuration
├── templates/
│   ├── web-api/            # FastAPI + SQLAlchemy template
│   ├── cli/                # typer CLI template
│   └── notebook/           # marimo + polars template
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
