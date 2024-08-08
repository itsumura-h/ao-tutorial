# メッセージ

メッセージはao内の基本的なデータプロトコルユニットとして機能し、[ANS-104 DataItems](https://specs.g8way.io/?tx=xwOgX-MmqN5_-Ny_zNu2A8o-PnTGsoRb_3FrtiMAkuw)から作成されており、Arweaveのネイティブ構造と一致しています。プロセスで使用されるとき、メッセージは以下のように構成されます：

```lua
{
    Cron = false,
    Data = "Hello aos",
    Epoch = 0,
    From = "5WzR7rJCuqCKEq02WUPhTjwnzllLjGu6SA7qhYpcKRs",
    Id = "ayVo53qvZswpvxLlhMf8xmGjwxN0LGuHzzQpTLT0_do",
    Nonce = 1,
    Owner = "z1pq2WzmaYnfDwvEFgUZBj48anUsxxN64ZjbWOsIn08",
    Signature = "...",
    Tags = {
        Type = "Message",
        Variant = "ao.TN.1",
        ["Data-Protocol"] = "ao",
        ["From-Module"] = "lXfdCypsU3BpYTWvupgTioLoZAEOZL2_Ihcqepz6RiQ",
        ["From-Process"] = "5WzR7rJCuqCKEq02WUPhTjwnzllLjGu6SA7qhYpcKRs"
    },
    Target = "5WzR7rJCuqCKEq02WUPhTjwnzllLjGu6SA7qhYpcKRs",
    Timestamp = 1704936415711,
    ["Block-Height"] = 1340762,
    ["Forwarded-By"] = "z1pq2WzmaYnfDwvEFgUZBj48anUsxxN64ZjbWOsIn08",
    ["Hash-Chain"] = "hJ0B-0yxKxeL3IIfaIIF7Yr6bFLG2vQayaF8G0EpjbY"
}
```

この構造は、割り当てタイプとメッセージタイプを統合し、プロセスがメッセージのコンテキストを効果的に理解して処理できるようにします。

メッセージを送信する際の、aoコンピュータ内でのメッセージの流れを示す視覚的な図は以下の通りです。

![メッセージワークフロー](message-workflow-diagram.png)

メッセージワークフローは、メッセージの署名が認証されるMU（Messenger Unit）から始まります。次に、SU（Scheduler Unit）がメッセージにエポックとノンスを割り当て、メッセージを割り当てタイプでバンドルし、Arweaveに送信します。続いて、`aoconnect`ライブラリがCU（Compute Unit）から結果を取得します。CUは、SU（Scheduler Unit）から現在のメッセージIDまでのすべての前のメッセージを呼び出し、それらを処理して結果を導き出します。処理が完了すると、計算された結果が`aoconnect`に返され、`aos`のようなクライアントインターフェース内で統合されます。

## まとめ

メッセージは、ArweaveにネイティブなANS-104データアイテムを活用することで、aoネットワークの主要なデータプロトコルタイプとして機能します。メッセージには、データ内容、発信元、ターゲット、署名やノンスなどの暗号要素を含むいくつかのフィールドが含まれます。メッセージの流れは、メッセージが署名されるメッセンジャーユニット（MU）から始まり、タイムスタンプとシーケンスを割り当てるスケジューラーユニット（SU）を経て、Arweaveにバンドルおよび公開されます。その後、`aoconnect`ライブラリがCU（Compute Unit）から結果を読み取り、プロセスを計算して結果を返します。CUは、これらのプロセスを実行する環境です。
