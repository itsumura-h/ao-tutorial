# Pretty

このモジュールは、整形された、人間にとって読みやすい形式での出力を可能にします。

## モジュール関数

### `tprint()`

提供されたテーブルの構造をフォーマットした文字列を返します。

- **パラメータ:**
  - `tbl`: `{table}` フォーマットするテーブル
  - `indent`: `{number}` 各レベルのインデント (オプション)
- **戻り値:** フォーマットされたテーブル構造の文字列

#### 使用例

```lua
local pretty = require(".pretty")

local formatted = pretty.tprint({
  name = "John Doe",
  age = 22,
  friends = { "Maria", "Victor" }
}, 2)

-- フォーマットされたテーブル構造を出力
print(formatted)
```
