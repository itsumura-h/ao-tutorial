# Arweaveからデータを取得するためのaoの使用

ao開発のワークフローの中で、Arweaveからデータを取得したい場合があります。aoを使用すると、プロセスがネットワークにそのデータを提供するよう指示するアサインメントを送信できます。

Arweaveからデータをリクエストするには、取得したいプロセスのリストと、メッセージのtxidを指定した`Message`を含む`Assign`を呼び出します。

```lua
Assign({
  Processes = { ao.id },
  Message = 'message-id'
})
```

また、`Send`を使用して、`Assignments`パラメータにプロセスIDのテーブルを渡すこともできます。これにより、ネットワークがメッセージを生成し、`Assignments`リスト内のすべてのプロセスIDにそのメッセージを割り当てることができます。

```lua
Send({
  Target = ao.id,
  Data = 'Hello World',
  Assignments = { 'process-id-1', 'process-id-2' }
})
```

## なぜArweaveからデータを取得するのか？

プロセスが何かに関する決定を下すためにメッセージからデータにアクセスする必要がある場合や、`data`ロード機能を通じてプロセスに機能を追加したい場合、あるいはプロセスからメッセージにアクセスしたいが、メッセージ全体を複製したくない場合があるかもしれません。
