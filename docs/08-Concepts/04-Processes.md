# プロセス

プロセスはメッセージの送受信を通じてネットワーク内で通信する能力を持ち、さらにプロセスを生成することもできます。このダイナミックなデータの伝達およびネットワーク内での相互作用の方法は「ホログラフィックステート」と呼ばれ、ネットワークの共有および持続的な状態を支えています。

![プロセス図](process-diagram.png)

`aos`でプロセスを構築する際には、`Handlers.add`関数を呼び出し、「名前」、「マッチ関数」、「ハンドル関数」を渡すことでハンドラを追加できます。

![ハンドラ図](handler-diagram.png)

コアモジュールには、ハンドラ関数に注入されるヘルパーライブラリが含まれており、このライブラリは`ao`と呼ばれます。

```lua
{
    env = {
        Process = {
            Id = "5WzR7rJCuqCKEq02WUPhTjwnzllLjGu6SA7qhYpcKRs",
            Owner = "_r9LpP4FtClpsGX3TOohubyaeb0IQTZZMcxQ24tTsGo",
            Tags = {...}
        },
        Module = {
            Id = "UAUszdznoUPQvXRbrFuIIH6J0N_LnJ1h4Trej28UgrE",
            Owner = "_r9LpP4FtClpsGX3TOohubyaeb0IQTZZMcxQ24tTsGo",
            Tags = {..}
        }
    },
    id = "5WzR7rJCuqCKEq02WUPhTjwnzllLjGu6SA7qhYpcKRs",
    isTrusted = "function: 0x5468d0",
    result = "function: 0x547120",
    send = "function: 0x547618",
    spawn = "function: 0x5468b0"
}
```

この`ao`ヘルパーで注目すべき主な関数は次のとおりです：

- `ao.send(Message)` - プロセスにメッセージを送信します
- `ao.spawn(Module, Message)` - 新しいプロセスを作成します

## `ao.send`の例

```lua
ao.send({
    Target = Chatroom,
    Action = "Broadcast",
    Data = "Hello from my Process!"
})
```

## `ao.spawn`の例

```lua
ao.spawn(ao.env.Module.Id, {
    ["Memory-Limit"] = "500-mb",
    ["Compute-Limit"] = "900000000000000000"
})
```

## `ao.env`

> 注：`ao.env`は、プロセスを作成する開発者にとって重要なコンテキストデータです。

`ao.env`プロパティには`Process`および`Module`のリファレンスオブジェクトが含まれています。

```lua
env = {
    Process = {
        Id = "5WzR7rJCuqCKEq02WUPhTjwnzllLjGu6SA7qhYpcKRs",
        Owner = "_r9LpP4FtClpsGX3TOohubyaeb0IQTZZMcxQ24tTsGo",
        Tags = {...}
    },
    Module = {
        Id = "UAUszdznoUPQvXRbrFuIIH6J0N_LnJ1h4Trej28UgrE",
        Owner = "_r9LpP4FtClpsGX3TOohubyaeb0IQTZZMcxQ24tTsGo",
        Tags = {..}
    }
}
```

`Process`および`Module`の両方には、`ao`データプロトコルの属性が含まれています。

## まとめ

プロセスはネットワーク内でメッセージの送受信を通じて通信し、新しいプロセスを生成することができます。これにより、ネットワークの共有および持続的なデータ状態である「ホログラフィックステート」が維持されます。開発者は`aos`を使用してプロセスを構築し、特定の名前、マッチ関数、およびハンドル関数を持つハンドラを`Handlers.add`関数を使用して追加できます。コアモジュール内の`ao`ヘルパーライブラリは、メッセージを送信するための`ao.send`や新しいモジュールを作成するための`ao.spawn`などの機能を提供し、重要なプロセスおよびモジュール情報を含む`ao.env`プロパティも提供します。`ao`データプロトコルは、これらの要素の構造と属性を規定しています。
