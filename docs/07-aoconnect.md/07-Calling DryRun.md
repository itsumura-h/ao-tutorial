# DryRunの呼び出し

DryRunは、特定のプロセスにメッセージオブジェクトを送信し、Resultオブジェクトを取得するプロセスですが、メモリは保存されません。これは、トークンの残高や転送の結果など、メモリの現在の値を返すための読み取りメッセージを作成するのに最適です。実際のメッセージを送信することなく、出力を取得するためにDryRunを使用できます。

```js
import { createDataItemSigner, dryrun } from "@permaweb/aoconnect";

const result = await dryrun({
  process: 'PROCESSID',
  data: '',
  tags: [{name: 'Action', value: 'Balance'}],
  anchor: '1234',
  // そのほかのオプション（Id、Ownerなど）は省略可能
});

console.log(result.Messages[0]);
```
