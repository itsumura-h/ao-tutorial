# ユーティリティ（Utils）

汎用的なテーブル操作やバリデーションのためのユーティリティライブラリです。カリー形式と従来のプログラミングスタイルの両方をサポートしています。

> **注意**: 以下の関数に提供される入力が期待される型に一致していることを確認することが重要です。

### 使用例

```lua
local utils = require(".utils")

local totalSupply = utils.reduce(
  function (acc, v) return acc + v end,
  0,
  { 2, 4, 9 }
)

print(totalSupply) -- 15を出力
```

## モジュール関数

### `concat()`

この関数は配列 `b` を配列 `a` に連結します。

- **パラメータ:**
  - `a`: `{table}` ベースの配列
  - `b`: `{table}` ベースの配列に連結する配列
- **戻り値:** `a` と `b` を結合した配列

#### 使用例

```lua
-- { 1, 2, 3, 4, 5, 6 } を返す
concat({ 1, 2, 3 })({ 4, 5, 6 })

-- { "hello", "world", "and", "you" } を返す
concat({ "hello", "world" }, { "and", "you" })
```

### `reduce()`

この関数は提供されたリデューサ関数を全ての配列要素に対して実行し、最終的に一つの統一された結果を提供します。

- **パラメータ:**
  - `fn`: `{function}` リデューサ関数。前の結果、現在の要素の値とキーをこの順序で受け取ります
  - `initial`: `{any}` オプションの初期値
  - `t`: `{table}` リデューサを実行する配列
- **戻り値:** テーブルの全ての要素に対してリデューサを実行した結果の一つの値

#### 使用例

```lua
local sum = utils.reduce(
  function (acc, v) return acc + v end,
  0,
  { 1, 2, 3 }
)

print(sum) -- 6を出力
```

```lua
local sum = utils
  .reduce(function (acc, v) return acc + v end)(0)({ 5, 4, 3 })

print(sum) -- 12を出力
```

### `map()`

この関数は提供された配列の各要素に対して提供されたマップ関数を呼び出し、その結果で満たされた新しい配列を作成します。

- **パラメータ:**
  - `fn`: `{function}` マップ関数。現在の配列要素とキーを受け取ります
  - `data`: `{table}` マップする配列
- **戻り値:** マップ関数の結果で構成された新しい配列

#### 使用例

```lua
-- { "Odd", "Even", "Odd" } を返す
utils.map(
  function (val, key)
    return (val % 2 == 0 and "Even") or "Odd"
  end,
  { 3, 4, 7 }
)
```

```lua
-- { 4, 8, 12 } を返す
utils.map(function (val, key) return val * 2 end)({ 2, 4, 6 })
```

### `filter()`

この関数は提供されたフィルタ関数のテストに合格した要素だけを保持する、新しい配列を元の配列の一部から作成します。

- **パラメータ:**
  - `fn`: `{function}` フィルタ関数。現在の配列要素を受け取り、その要素を保持するか（`true`）フィルタリングするか（`false`）を決定します
  - `data`: `{table}` フィルタリングする配列
- **戻り値:** フィルタリングされた新しい配列

#### 使用例

```lua
-- 偶数のみを保持
utils.filter(
  function (val) return val % 2 == 0 end,
  { 3, 4, 7 }
)
```

```lua
-- 数字のみを保持
utils.filter(
  function (val) return type(val) == "number" end,
  { "hello", "world", 13, 44 }
)
```

### `find()`

提供された関数に一致する最初の要素を返します。

- **パラメータ:**
  - `fn`: `{function}` 現在の要素を受け取り、一致する場合は `true` を、一致しない場合は `false` を返す関数
  - `t`: `{table}` 要素を見つける配列
- **戻り値:** 見つかった要素、または一致する要素がない場合は `nil`

#### 使用例

```lua
local users = {
  { name = "John", age = 50 },
  { name = "Victor", age = 37 },
  { name = "Maria", age = 33 }
}

-- "John" という名前のユーザーを返す
utils.find(
  function (val) return user.name == "John" end,
  users
)
```

```lua
-- 年齢が 33 のユーザーを返す
utils.find(function (val) return user.age == 33 end)(users)
```

### `reverse()`

配列を逆順に変換します。

- **パラメータ:**
  - `data`: `{table}` 逆順にする配列
- **戻り値:** 逆順にされた元の配列

#### 使用例

```lua
-- { 3, 2, 1 }
utils.reverse({ 1, 2, 3 })
```

### `includes()`

値が配列の一部であるかどうかを判断します。

- **パラメータ:**
  - `val`: `{any}` チェックする要素
  - `t`: `{table}` チェックする配列
- **戻り値:** 提供された値が配列の一部であるかどうかを示すブール値

#### 使用例

```lua
-- これは true です
utils.includes("John", { "Victor", "John", "Maria" })
```

```lua
-- これは false です
utils.includes(4)({ 3, 5, 7 })
```

### `keys()`

テーブルのキーを返します。

- **パラメータ:**
  - `table`: `{table}` キーを取得するテーブル
- **戻り値:** キーの配列

#### 使用例

```lua
-- { "hello", "name" } を返す
utils.keys({ hello = "world", name = "John" })
```

### `values()`

テーブルの値を返します。

- **パラメータ:**
  - `table`: `{table}` 値を取得するテーブル
- **戻り値:** 値の配列

#### 使用例

```lua
-- { "world", "John" } を返す
utils.values({ hello = "world", name = "John" })
```

### `propEq()`

指定されたテーブルのプロパティが提供された値と等しいかどうかをチェックします。

- **パラメータ:**
  - `propName`: `{string}` 比較するプロパティの名前
  - `value`: `{any}` 比較する値
  - `object`: `{table}` プロパティを選択するオブジェクト
- **戻り値:** プロパティの値が提供された値と等しいかどうかを示すブール値

#### 使用例

```lua
local user = { name = "John", age = 50 }

-- true を返す
utils.propEq("age", 50, user)
```

```lua
local user = { name = "Maria", age = 33 }

-- false を返す
utils.propEq("age", 45, user)
```

### `prop()`

提供されたオブジェクトから提供されたプロパティ名に属するプロパティ値を返します。

- **パラメータ:**
  - `propName`: `{string}` 取得するプロパティの名前
  - `object`: `{table}` プロパティ値を選択するオブジェクト
- **戻り値:** プロパティ値、または見つからなかった場合は `nil`

#### 使用例

```lua
local user = { name = "Maria", age = 33 }

-- "Maria" を返す
utils.prop("name", user)
```

```lua
local user = { name = "John", age = 50 }

--

 50 を返す
utils.prop("age")(user)
```

### `compose()`

この関数は複数の配列操作を連鎖させ、それらを提供された配列に対して逆順に実行することができます。

- **パラメータ:**
  - `...`: `{function[]}` 配列操作
  - `v`: `{table}` 提供された関数を実行するオブジェクト
- **戻り値:** 提供された操作からの結果

#### 使用例

```lua
-- 12 を返す
utils.compose(
  utils.reduce(function (acc, val) return acc + val end, 0),
  utils.map(function (val) return val * 2 end)
)({ 1, 2, 3 })
```
