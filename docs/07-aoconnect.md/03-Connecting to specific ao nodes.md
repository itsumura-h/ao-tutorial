# 特定のaoノードへの接続

ao connectをコードにインクルードする際に、特定のMU（Message Unit）とCU（Compute Unit）に接続する機能があります。また、Arweaveゲートウェイを指定することもできます。これは、`connect`関数をインポートし、`connect`関数の呼び出しから関数を抽出することで行えます。

メッセージを送信する際にどのMUが呼び出されているかを知りたい場合や、特定のCUから結果を読み取りたい場合に役立ちます。また、特定の理由で特定のMUとCUを好む場合にも使用できます。デフォルトのarweave.net以外のゲートウェイを使用するためにゲートウェイを指定することもできます。

## connect関数を呼び出さずにインポートする場合

```js
// ここでは、aoconnectはデフォルトのノード/ユニットを暗黙的に使用します。
import {
  result,
  results,
  message,
  spawn,
  monitor,
  unmonitor,
  dryrun,
} from "@permaweb/aoconnect";
```

## 特定のMU、CU、ゲートウェイに接続する場合

```js
import { connect } from "@permaweb/aoconnect";

const { result, results, message, spawn, monitor, unmonitor, dryrun } = connect({
  MU_URL: "https://mu.ao-testnet.xyz",
  CU_URL: "https://cu.ao-testnet.xyz",
  GATEWAY_URL: "https://arweave.net",
});

// これで、spawn、message、およびresultは、直接インポートされた場合と同じように使用できます。
```

<br>

<strong>これらの3つのパラメータはすべてオプションであり、1つまたは2つ、または何も指定しないことも有効です。例えば、MU_URLだけを渡すこともできます。</strong>

```js
import { connect } from "@permaweb/aoconnect";

const { result, results, message, spawn, monitor, unmonitor, dryrun } = connect({
  MU_URL: "https://ao-mu-1.onrender.com",
});
```
