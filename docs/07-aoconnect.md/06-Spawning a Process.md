# プロセスの生成

プロセスの概念についての詳細は、[ao プロセス](../../concepts/processes.md)の概念で確認できます。このガイドでは、ao connect を使用してプロセスを生成する方法に焦点を当てます。

プロセスを生成するためには、Arweave にアップロードされた ao モジュールの TXID が必要です。モジュールはプロセスのソースコードです。プロセス自体は、そのソースのインスタンスです。

また、スケジューラーユニット (SU) のウォレットアドレスも必要です。この指定された SU は、このプロセスのスケジューラとして機能します。つまり、システム内のすべてのノードが、このプロセスの読み書きを行うために、この SU を使用する必要があることを認識できます。以下のアドレスを使用できます。

## 利用可能なスケジューラのウォレットアドレス

```lua
TZ7o7SIZ06ZEJ14lXwVtng1EtSx60QkPy-kh-kdAXog
```

## NodeJS でプロセスを生成する

```js
import { readFileSync } from "node:fs";

import { createDataItemSigner, spawn } from "@permaweb/aoconnect";

const wallet = JSON.parse(
  readFileSync("/path/to/arweave/wallet.json").toString(),
);

const processId = await spawn({
  // ao モジュールの Arweave TXID
  module: "module TXID",
  // スケジューラーユニットの Arweave ウォレットアドレス
  scheduler: "_GQ33BkPtZrqxA84vM8Zk-N2aO0toNNu_C-l-rawrBA",
  // ウォレットを含むサイナー関数
  signer: createDataItemSigner(wallet),
  /*
    プロセスのソースコードやドキュメントを参照して、
    計算に影響を与える可能性のあるタグを確認してください。
  */
  tags: [
    { name: "Your-Tag-Name-Here", value: "your-tag-value" },
    { name: "Another-Tag", value: "another-value" },
  ],
});
```

## ブラウザでプロセスを生成する

```js
import { createDataItemSigner, spawn } from "@permaweb/ao-sdk";

const processId = await spawn({
  // ao モジュールの Arweave TXID
  module: "module TXID",
  // スケジューラーユニットの Arweave ウォレットアドレス
  scheduler: "_GQ33BkPtZrqxA84vM8Zk-N2aO0toNNu_C-l-rawrBA",
  // ウォレットを含むサイナー関数
  signer: createDataItemSigner(globalThis.arweaveWallet),
  /*
    プロセスのソースコードやドキュメントを参照して、
    計算に影響を与える可能性のあるタグを確認してください。
  */
  tags: [
    { name: "Your-Tag-Name-Here", value: "your-tag-value" },
    { name: "Another-Tag", value: "another-value" },
  ],
});
```
