# Cronのモニタリング

Cronメッセージを使用する場合、aoユーザーはメッセージのインジェストを開始する方法が必要です。このモニタリングメソッドを使用することで、aoユーザーはcronメッセージのサブスクリプションサービスを開始できます。Cronタグを設定すると、プロセスのアウトボックスにcron結果が生成されますが、これらの結果からメッセージをネットワークを介してプッシュしたい場合は、これらの結果をモニタリングする必要があります。

```js
import { readFileSync } from "node:fs";
import { createDataItemSigner, monitor } from "@permaweb/aoconnect";

const wallet = JSON.parse(
  readFileSync("/path/to/arweave/wallet.json").toString(),
);

const result = await monitor({
  process: "process-id",
  signer: createDataItemSigner(wallet),
});
```

モニタリングを停止するには、`unmonitor`を呼び出します。

```js
import { readFileSync } from "node:fs";
import { createDataItemSigner, unmonitor } from "@permaweb/aoconnect";

const wallet = JSON.parse(
  readFileSync("/path/to/arweave/wallet.json").toString(),
);

const result = await unmonitor({
  process: "process-id",
  signer: createDataItemSigner(wallet),
});
```
