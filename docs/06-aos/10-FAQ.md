# FAQ

## 所有権

<details>
  <summary><strong>プロセスの所有権の理解</strong></summary>

aosコンソールで新しいプロセスを開始すると、そのプロセスの所有権はあなたのウォレットアドレスに設定されます。**aos**はプロセスの所有権を定義するために**Owner**グローバル変数を使用します。所有権を移転するか、誰も所有できないようにロックする場合は、**Owner**変数を別のウォレットアドレスに変更するか、**nil**に設定します。

</details>

## JSON

<details>
  <summary><strong>データをJSONとしてエンコードする</strong></summary>

他のプロセスや外部サービスにデータを送信する際、JSONを使用してデータをエンコードすることがあります。Luaのjsonモジュールを使用して、値を含む純粋なLuaテーブルを**エンコード**および**デコード**できます。

```lua
Send({Target = Router, Data = require('json').encode({hello = "world"})})
```

</details>

## Sendとao.sendの使い分け

<details>
  <summary><strong>Sendとao.sendの使い分け</strong></summary>

両方の関数はプロセスにメッセージを送信しますが、違いはao.sendがメッセージを返す点です。これにより、メッセージをログに記録したり、トラブルシューティングを行うことができます。**Send**関数はコンソールでの簡単なアクセスのために使用されますが、**ao.send**は**handlers**で使用することが推奨されます。ただし、**aos**内ではどちらも交換可能です。

</details>
