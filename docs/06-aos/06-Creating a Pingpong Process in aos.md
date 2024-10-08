# aosでPingpongプロセスを作成する

このチュートリアルでは、aosでシンプルな「ping-pong」プロセスを作成する手順を説明します。このプロセスでは、「ping」というデータを含むメッセージを受信すると、自動的に「pong」と返信します。これは、aos内でのメッセージハンドリングとプロセス間の相互作用の基本的な例です。

## ステップ1: `aos` CLIを開く

- コマンドラインインターフェースを開き、`aos`と入力してaos環境に入ります。

## ステップ2: エディタにアクセスする

- `aos` CLIで`.editor`と入力してインラインテキストエディタを開きます。ここでping-pongハンドラのコードを書きます。

## ステップ3: Pingpongハンドラを作成する

- エディタに以下のLuaコードを入力してpingpongパターンのハンドラを追加します:

  ```lua
  Handlers.add(
    "pingpong",
    Handlers.utils.hasMatchingData("ping"),
    Handlers.utils.reply("pong")
  )
  ```

- このLuaスクリプトは以下の3つのことを行います:
  1. "pingpong"という名前の新しいハンドラを追加します。
  2. `Handlers.utils.hasMatchingData("ping")`を使用して、受信メッセージに「ping」というデータが含まれているかどうかをチェックします。
  3. メッセージに「ping」が含まれている場合、`Handlers.utils.reply("pong")`が自動的に「pong」というデータを含むメッセージを返信します。

## ステップ4: エディタを終了する

- コードを書いたら、`.done`と入力してEnterキーを押し、エディタを終了してスクリプトを実行します。

## ステップ5: Pingpongプロセスをテストする

- プロセスをテストするために、「ping」というデータを含むメッセージをプロセスに送信します。これを行うには、aos CLIで次のコマンドを入力します:
  ```lua
  Send({ Target = ao.id, Data = "ping" })
  ```
- プロセスは「pong」というデータを含むメッセージで返信するはずです。

## ステップ6: インボックスを監視する

- インボックスをチェックして「ping」メッセージを確認し、アウトボックスで「pong」返信を確認します。

```lua
Inbox[#Inbox].Data
```

## ステップ7: 実験と観察

- 異なるメッセージを送信して実験し、「ping」メッセージだけが「pong」返信をトリガーする様子を観察します。

## ステップ8: プロセスを保存する（オプション）

- このプロセスを将来使用する場合、ハンドラコードをLuaファイルに保存して、aosセッションに簡単にロードできるようにします。

::: info

**追加のヒント:**

- **ハンドラの効率性**: ハンドラ関数のシンプルさが重要です。正しい条件下でのみトリガーされるように効率的にすることを確認してください。

:::

## 結論

おめでとうございます！aosで基本的なping-pongプロセスを作成しました。このチュートリアルは、aos環境内でのメッセージハンドリングとプロセス相互作用の理解の基礎を提供します。これらの概念に慣れてきたら、より複雑なプロセスや相互作用に拡張し、aosの可能性を探求してください。
