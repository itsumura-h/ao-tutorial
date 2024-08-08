# プロセスへのメッセージ送信

メッセージの概念についての詳細は、[ao メッセージ](../../concepts/messages.md)の概念を参照してください。このガイドでは、ao connectを使用してプロセスにメッセージを送信する方法に焦点を当てます。

メッセージの送信は、アプリがaoとやり取りするための中心的な方法です。メッセージはプロセスへの入力です。メッセージには、「target（ターゲット）」、「data（データ）」、「tags（タグ）」、「anchor（アンカー）」、および「signature（署名）」の5つの部分があります。

プロセスモジュールのソースコードまたはドキュメントを参照して、メッセージが計算にどのように使用されるかを確認してください。ao connectライブラリは、以下のコードで渡されたパラメータを翻訳し、メッセージを構築して送信します。

## NodeJSでのメッセージ送信

```js
import { readFileSync } from "node:fs";
import { message, createDataItemSigner } from "@permaweb/aoconnect";

const wallet = JSON.parse(
  readFileSync("/path/to/arweave/wallet.json").toString(),
);

// ここで必要なパラメータはprocessとsignerの2つだけです
await message({
  /*
    プロセスのarweave TXID、これは「target」となります。
    これはメッセージが最終的に送信されるプロセスです。
  */
  process: "process-id",
  // プロセスが入力として使用するタグ
  tags: [
    { name: "Your-Tag-Name-Here", value: "your-tag-value" },
    { name: "Another-Tag", value: "another-value" },
  ],
  // メッセージの「署名」を作成するために使用される署名関数
  signer: createDataItemSigner(wallet),
  /*
    メッセージの「data」部分
    指定されていない場合、ランダムな文字列が生成されます
  */
  data: "any data",
})
  .then(console.log)
  .catch(console.error);
```

## ブラウザでのメッセージ送信

```js
import { message, createDataItemSigner } from "@permaweb/aoconnect";

// ここで必要なパラメータはprocessとsignerの2つだけです
await message({
  /*
    プロセスのarweave TXID、これは「target」となります。
    これはメッセージが最終的に送信されるプロセスです。
  */
  process: "process-id",
  // プロセスが入力として使用するタグ
  tags: [
    { name: "Your-Tag-Name-Here", value: "your-tag-value" },
    { name: "Another-Tag", value: "another-value" },
  ],
  // メッセージの「署名」を作成するために使用される署名関数
  signer: createDataItemSigner(globalThis.arweaveWallet),
  /*
    メッセージの「data」部分
    指定されていない場合、ランダムな文字列が生成されます
  */
  data: "any data",
})
  .then(console.log)
  .catch(console.error);
```
