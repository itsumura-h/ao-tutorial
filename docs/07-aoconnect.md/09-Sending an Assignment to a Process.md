# プロセスへのアサインメントの送信

アサインメントは、他のメッセージからデータをプロセスにロードするため、またはメッセージを重複させないために使用できます。一つのメッセージを作成し、それを任意の数のプロセスにアサインできます。これにより、アサインメントを送信したプロセスで利用可能になります。

## NodeJSでのアサインメントの送信

```js
import { readFileSync } from "node:fs";

import { assign } from "@permaweb/aoconnect";

await assign({
  process: "process-id",
  message: "message-id",
})
  .then(console.log)
  .catch(console.error);
```

## DataItemフィールドの除外

また、ほとんどのDataItemフィールドを除外することもできます。これにより、CUがプロセスにロードしないよう指示できます。例えば、タグなどのヘッダデータのみが必要で、データ自体は必要ない場合などです。Ownerを除外しても効果はありません。なぜなら、CUはOwnerを必要とするため、Ownerを除外してもCUには無視されます。大文字のDataItem/MessageフィールドのみがCUに効果を持ちます。

```js
import { readFileSync } from "node:fs";

import { assign } from "@permaweb/aoconnect";

await assign({
  process: "process-id",
  message: "message-id",
  exclude: ["Data", "Anchor"],
})
  .then(console.log)
  .catch(console.error);
```

## L1トランザクションのアサイン

ベースレイヤーパラメータをアサインに渡すことで、レイヤー1トランザクションをアサインすることもできます。これは、トークンのミントなど、ベースレイヤーを使用する際に有用です。デフォルトでは、L1トランザクションが少なくとも20の確認を持っていない場合、SUはそれを拒否します。これは、プロセスが作成されたときに`Settlement-Depth`タグを異なる数値に設定することで変更できます。

```js
import { readFileSync } from "node:fs";

import { assign } from "@permaweb/aoconnect";

await assign({
  process: "process-id",
  message: "layer 1 tx id",
  baseLayer: true,
})
  .then(console.log)
  .catch(console.error);
```
