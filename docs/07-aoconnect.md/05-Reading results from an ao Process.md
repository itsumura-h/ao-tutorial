# ao プロセスからの結果の読み取り

ao では、メッセージが生成した結果は Compute Units (CU) によって提供されます。結果は、メッセージ、スパウン、出力、およびエラーというフィールドを持つ JSON オブジェクトです。

結果は、プロセスによって生成されたメッセージやスパウンを送信するために ao システムが使用します。プロセスは、結果でメッセージやスパウンを返すことで、開発者と同じようにメッセージを送信できます。

結果にアクセスして、メッセージによって生成された出力を表示する場合や、生成されたメッセージやスパウンを確認する場合があります。メッセージとスパウンは自動的に Messenger Units (MU) によって処理されるため、手動で送信する必要はありません。`results` の呼び出しにより、複数の結果のページネーションリストも取得できます。

## 単一の結果を取得する

```js
import { result } from "@permaweb/aoconnect";

let { Messages, Spawns, Output, Error } = await result({
  // メッセージの arweave TXID
  message: "message-id",
  // プロセスの arweave TXID
  process: "process-id",
});
```

## 複数の結果を取得する

```js
import { results } from "@permaweb/aoconnect";

// 最初のページの結果を取得する
let resultsOut = await results({
  process: "process-id",
  sort: "ASC",
  limit: 25,
});

// カーソルを使用して追加の結果を取得する
let resultsOut2 = await results({
  process: "process-id",
  from: resultsOut.edges?.[resultsOut.edges.length - 1]?.cursor ?? null,
  sort: "ASC",
  limit: 25,
});
```
