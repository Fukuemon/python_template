"""Data loading and processing utilities."""

from pathlib import Path

import polars as pl


def load_csv(path: str | Path) -> pl.DataFrame:
    """Load CSV file into a Polars DataFrame."""
    return pl.read_csv(path)


def load_parquet(path: str | Path) -> pl.DataFrame:
    """Load Parquet file into a Polars DataFrame."""
    return pl.read_parquet(path)


def save_csv(df: pl.DataFrame, path: str | Path) -> None:
    """Save DataFrame to CSV file."""
    df.write_csv(path)


def save_parquet(df: pl.DataFrame, path: str | Path) -> None:
    """Save DataFrame to Parquet file."""
    df.write_parquet(path)


def describe(df: pl.DataFrame) -> pl.DataFrame:
    """Get descriptive statistics for a DataFrame."""
    return df.describe()


def sample_data() -> pl.DataFrame:
    """Generate sample data for testing."""
    return pl.DataFrame(
        {
            "id": range(1, 101),
            "name": [f"Item {i}" for i in range(1, 101)],
            "value": [i * 10.5 for i in range(1, 101)],
            "category": ["A", "B", "C", "D"] * 25,
        }
    )
