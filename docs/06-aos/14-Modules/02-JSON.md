# JSON

JSONモジュールを使用すると、JavaScript Object Notationを使用してオブジェクトをエンコードおよびデコードできます。

### 使用例

```lua
local json = require("json")

json.encode({
  a_string = "This is a string",
  nums = { 1, 2, 3 }
})
```

## モジュール関数

### `encode()`

この関数は、LuaオブジェクトをJSON形式の文字列として返します。

- **パラメータ:**
  - `val`: `{any}` JSONとしてフォーマットするオブジェクト
- **戻り値:** 提供されたオブジェクトのJSON文字列表現

#### 使用例

```lua
--[[
  出力:
  "[{"name":"John Doe","age":23},{"name":"Bruce Wayne",age:34}]"
]]--
print(json.encode({
  { name = "John Doe", age = 23 },
  { name = "Bruce Wayne", age = 34 }
}))

-- "false"を出力
print(json.encode(false))
```

### `decode()`

この関数はJSON文字列を受け取り、Luaオブジェクトに変換します。

- **パラメータ:**
  - `val`: `{any}` デコードするJSON文字列
- **戻り値:** JSON文字列に対応するLuaオブジェクト（無効なJSON文字列の場合はエラーをスローします）

#### 使用例

```lua
--[[
  以下のテーブルを作成:
  { hello = "world" }
]]--
json.decode('{ "hello": "world" }')

-- 値がtrueのブール値を作成
json.decode("true")
```
