# Python / FastAPI 開発ルール

## アーキテクチャ

### ドメイン駆動設計

このプロジェクトはドメイン単位でモジュールを分割する構成を採用しています。

```text
src/app/
├── main.py          # アプリケーションエントリポイント
├── config.py        # グローバル設定
├── database.py      # データベース接続
├── exceptions.py    # グローバル例外
└── users/           # ドメインモジュール
    ├── router.py    # APIエンドポイント
    ├── schemas.py   # Pydanticスキーマ
    ├── models.py    # SQLAlchemyモデル
    └── service.py   # ビジネスロジック
```

### 新しいドメインの追加

1. `src/app/newdomain/` ディレクトリを作成
2. `router.py`, `schemas.py`, `models.py`, `service.py` を追加
3. `alembic/env.py` でモデルをインポート
4. `main.py` でルーターを登録

### モジュール間の依存

他のドメインからインポートする場合は、明示的なモジュール名を使用してください。

```python
# Good
from app.users import service as users_service
from app.users.schemas import UserResponse

# Bad
from app.users.service import *
```

## コーディング規約

### 型アノテーション

すべての関数に型アノテーションを付けてください。

```python
# Good
def get_user(user_id: int) -> User | None:
    ...

# Bad
def get_user(user_id):
    ...
```

### Pydanticスキーマ

- 入力用と出力用のスキーマを分離する
- `model_config = ConfigDict(from_attributes=True)` でORMモデルからの変換を有効化

```python
class UserCreate(BaseModel):
    """ユーザー作成用スキーマ"""
    email: EmailStr
    name: str

class UserResponse(BaseModel):
    """ユーザーレスポンス用スキーマ"""
    model_config = ConfigDict(from_attributes=True)

    id: int
    email: EmailStr
    name: str
    created_at: datetime
```

### 例外処理

- グローバル例外クラスを使用する
- ドメイン固有の例外が必要な場合は `domain/exceptions.py` に定義

```python
# Good
from app.exceptions import NotFoundError

raise NotFoundError("User not found")

# Bad
from fastapi import HTTPException
raise HTTPException(status_code=404, detail="User not found")
```

### サービス層

- ビジネスロジックは `service.py` に実装
- ルーターはリクエスト/レスポンスの変換とサービス呼び出しのみ
- サービス関数は純粋関数として実装（副作用はDBセッション経由のみ）

```python
# service.py
def create_user(db: Session, user_in: UserCreate) -> User:
    user = User(email=user_in.email, name=user_in.name)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

# router.py
@router.post("/", response_model=UserResponse)
async def create_user(
    user_in: UserCreate,
    db: Session = Depends(get_db),
) -> UserResponse:
    user = service.create_user(db, user_in)
    return UserResponse.model_validate(user)
```

## テスト

### テストの構成

- `tests/` ディレクトリにテストを配置
- ドメインごとに `test_users.py` のようにファイルを分割
- `conftest.py` で共通フィクスチャを定義

### 非同期テスト

FastAPIのエンドポイントテストは `pytest-asyncio` を使用します。

```python
@pytest.mark.asyncio
async def test_create_user(client: AsyncClient) -> None:
    response = await client.post("/users/", json={"email": "test@example.com", "name": "Test"})
    assert response.status_code == 201
```

### テストデータベース

- テストごとにデータベースをリセット
- `conftest.py` でテスト用のセッションを提供

## データベース

### マイグレーション

```bash
# マイグレーション作成
uv run alembic revision --autogenerate -m "Add users table"

# マイグレーション実行
uv run alembic upgrade head

# ロールバック
uv run alembic downgrade -1
```

### モデル定義

- `Mapped` 型を使用した型安全なカラム定義
- タイムスタンプは `server_default` で自動設定

```python
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())
```

## 設定

### 環境変数

- `pydantic-settings` で型安全に読み込み
- `.env.example` に必要な環境変数を記載
- シークレットは絶対にコミットしない

```python
class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    database_url: str = "sqlite:///./app.db"
    debug: bool = False
```

## API設計

### エンドポイント

- RESTful な命名規則に従う
- 複数形を使用（`/users`, `/posts`）
- ネストは1階層まで（`/users/{id}/posts`）

### ステータスコード

- 200: 成功（GET, PUT, PATCH）
- 201: 作成成功（POST）
- 204: 削除成功（DELETE）
- 400: バリデーションエラー
- 404: リソースが見つからない
- 409: 競合（重複など）
