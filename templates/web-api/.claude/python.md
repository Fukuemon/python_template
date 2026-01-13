# Python 開発ベストプラクティス

## 型アノテーション

### 基本ルール

すべての関数に型アノテーションを付ける。

```python
# Good
def get_user(user_id: int) -> User | None:
    ...

def process_items(items: list[str]) -> dict[str, int]:
    ...

# Bad
def get_user(user_id):
    ...
```

### Union型

Python 3.10以降は `|` を使用。

```python
# Good
def find(id: int) -> User | None:
    ...

# Bad（古い書き方）
from typing import Optional, Union
def find(id: int) -> Optional[User]:
    ...
```

### コレクション型

組み込み型を直接使用。

```python
# Good
def process(items: list[str], mapping: dict[str, int]) -> set[int]:
    ...

# Bad（古い書き方）
from typing import List, Dict, Set
def process(items: List[str], mapping: Dict[str, int]) -> Set[int]:
    ...
```

### Callable

`collections.abc` を使用。

```python
# Good
from collections.abc import Callable, Iterable, Mapping

def apply(func: Callable[[int], str], items: Iterable[int]) -> list[str]:
    ...

# Bad
from typing import Callable, Iterable
```

## 命名規則

### 基本

- **変数・関数**: `snake_case`
- **クラス**: `PascalCase`
- **定数**: `UPPER_SNAKE_CASE`
- **プライベート**: `_prefix`（単一アンダースコア）

```python
# Good
user_name = "John"
MAX_RETRY_COUNT = 3

class UserService:
    def get_user_by_id(self, user_id: int) -> User:
        ...

    def _validate_email(self, email: str) -> bool:
        ...
```

### 命名の具体性

```python
# Good - 具体的で意図が明確
user_ids = [1, 2, 3]
active_users = get_active_users()
is_authenticated = check_auth()

# Bad - 曖昧
data = [1, 2, 3]
users = get_active_users()
flag = check_auth()
```

## 関数設計

### 単一責任

1つの関数は1つのことだけを行う。

```python
# Good - 責任が分離されている
def validate_email(email: str) -> bool:
    ...

def send_welcome_email(user: User) -> None:
    ...

def create_user(email: str, name: str) -> User:
    if not validate_email(email):
        raise ValueError("Invalid email")
    user = User(email=email, name=name)
    send_welcome_email(user)
    return user

# Bad - 複数の責任が混在
def create_user_and_send_email_and_notify_admin(email: str, name: str) -> User:
    ...
```

### 引数の数

引数は3つ以下に抑える。多い場合はデータクラスやPydanticモデルを使用。

```python
# Good
@dataclass
class UserCreateParams:
    email: str
    name: str
    age: int
    address: str

def create_user(params: UserCreateParams) -> User:
    ...

# Bad
def create_user(email: str, name: str, age: int, address: str, phone: str) -> User:
    ...
```

### 早期リターン

ネストを減らすため、早期リターンを活用。

```python
# Good
def process_user(user: User | None) -> str:
    if user is None:
        return "No user"
    if not user.is_active:
        return "Inactive"
    return f"Welcome, {user.name}"

# Bad
def process_user(user: User | None) -> str:
    if user is not None:
        if user.is_active:
            return f"Welcome, {user.name}"
        else:
            return "Inactive"
    else:
        return "No user"
```

## エラーハンドリング

### 具体的な例外

汎用的な `Exception` ではなく、具体的な例外を使用。

```python
# Good
def get_user(user_id: int) -> User:
    user = db.get(User, user_id)
    if user is None:
        raise NotFoundError(f"User {user_id} not found")
    return user

# Bad
def get_user(user_id: int) -> User:
    user = db.get(User, user_id)
    if user is None:
        raise Exception("Not found")
    return user
```

### 例外の再送出

コンテキストを保持して再送出。

```python
# Good
try:
    result = external_api.call()
except ExternalAPIError as e:
    raise ServiceError(f"API call failed: {e}") from e

# Bad - 元の例外情報が失われる
try:
    result = external_api.call()
except ExternalAPIError:
    raise ServiceError("API call failed")
```

### tryブロックは最小限に

```python
# Good
try:
    value = int(user_input)
except ValueError:
    value = 0

result = process(value)

# Bad - tryの範囲が広すぎる
try:
    value = int(user_input)
    result = process(value)
    save_to_db(result)
except ValueError:
    value = 0
```

## イミュータビリティ

### デフォルト引数

ミュータブルなデフォルト引数を避ける。

```python
# Good
def append_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items

# Bad - 危険！
def append_item(item: str, items: list[str] = []) -> list[str]:
    items.append(item)
    return items
```

### データクラス

不変なデータには `frozen=True` を使用。

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Point:
    x: int
    y: int
```

## 文字列操作

### f-string

文字列フォーマットには f-string を使用。

```python
# Good
message = f"Hello, {name}! You have {count} messages."

# Bad
message = "Hello, {}! You have {} messages.".format(name, count)
message = "Hello, %s! You have %d messages." % (name, count)
```

### 複数行文字列

```python
# Good
query = """
    SELECT *
    FROM users
    WHERE active = true
"""

# Bad
query = "SELECT * " + \
        "FROM users " + \
        "WHERE active = true"
```

## リスト・辞書操作

### 内包表記

シンプルな変換には内包表記を使用。

```python
# Good
squares = [x ** 2 for x in range(10)]
even_squares = [x ** 2 for x in range(10) if x % 2 == 0]

# Bad
squares = []
for x in range(10):
    squares.append(x ** 2)
```

### 内包表記の限界

複雑な場合は通常のループを使用。

```python
# Good - 複雑な処理は通常のループ
results = []
for item in items:
    if item.is_valid():
        processed = transform(item)
        if processed.score > threshold:
            results.append(processed)

# Bad - 読みにくい
results = [transform(item) for item in items if item.is_valid() and transform(item).score > threshold]
```

### 辞書操作

```python
# Good
user_dict = {user.id: user for user in users}
value = config.get("key", "default")

# Bad
user_dict = {}
for user in users:
    user_dict[user.id] = user

if "key" in config:
    value = config["key"]
else:
    value = "default"
```

## コンテキストマネージャ

リソース管理には `with` を使用。

```python
# Good
with open("file.txt") as f:
    content = f.read()

# Bad
f = open("file.txt")
content = f.read()
f.close()
```

## インポート

### 順序

1. 標準ライブラリ
2. サードパーティ
3. ローカル

```python
# Good
import os
from datetime import datetime

from fastapi import FastAPI
from pydantic import BaseModel

from app.config import settings
from app.users.service import UserService
```

### 明示的インポート

```python
# Good
from datetime import datetime, timedelta
from app.users.models import User

# Bad
from datetime import *
from app.users.models import *
```

## ドキュメンテーション

### Docstring

公開関数・クラスにはdocstringを付ける。

```python
def calculate_tax(amount: float, rate: float = 0.1) -> float:
    """税額を計算する。

    Args:
        amount: 課税対象額
        rate: 税率（デフォルト: 10%）

    Returns:
        計算された税額

    Raises:
        ValueError: amountが負の場合
    """
    if amount < 0:
        raise ValueError("Amount must be non-negative")
    return amount * rate
```

### コメント

「何をしているか」ではなく「なぜそうしているか」を書く。

```python
# Good - 理由を説明
# キャッシュのTTLを5分に設定（外部APIのレート制限対策）
CACHE_TTL = 300

# Bad - コードの説明
# TTLを300に設定
CACHE_TTL = 300
```
