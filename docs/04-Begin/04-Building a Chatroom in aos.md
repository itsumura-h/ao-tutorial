# aosでのチャットルームの構築

::: info
`ao`内でチャットルームを作成する方法を学びたいと思った場合、それはメッセージの送受信の基本的な方法を少なくとも理解していることを意味します。まだ理解していない場合は、[メッセージング](messaging)のチュートリアルを確認してから進んでください。
:::

このチュートリアルでは、Luaスクリプト言語を使用して`ao`内でチャットルームを構築します。チャットルームには、以下の2つの主要な機能があります：

1. **登録**: プロセスがチャットルームに参加できるようにします。
2. **ブロードキャスト**: 1つのプロセスからすべての登録参加者にメッセージを送信します。

まず、チャットルームの基盤を設定することから始めましょう。

## ビデオチュートリアル

<iframe width="680" height="350" src="https://www.youtube.com/embed/oPCx-cfubF0?si=D5yWxmyFMV-4mh2P" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## ステップ1: 基礎設定

- お好きなコードエディタ（例：VS Code）を開きます。

::: info
Luaスクリプトの体験を向上させるために、コードエディタに[推奨拡張機能](../../references/editor-setup.md)をインストールすると便利です。
:::

- `chatroom.lua`という名前の新しいファイルを作成します。

![Chatroom Lua File](/chatroom1.png)

## ステップ2: メンバーリストの作成

- `chatroom.lua`に、参加者を追跡するためのリストを初期化するコードを追加します：

  ```lua
  Members = Members or {}
  ```

  ![Chatroom Lua File - Naming the Member List](/chatroom2.png)

  - `chatroom.lua`ファイルを保存します。

## ステップ3: aosにチャットルームをロードする

`chatroom.lua`を保存したら、チャットルームを`aos`にロードします。

- まだしていない場合は、`chatroom.lua`が保存されているディレクトリ内でターミナルで`aos`を起動します。
- `aos` CLIで次のスクリプトを入力して、スクリプトを`aos`プロセスに組み込みます：

  ```lua
  .load chatroom.lua
  ```

  ![Loading the Chatroom into aos](/chatroom3.png)

  上のスクリーンショットに示されているように、`undefined`という応答が表示されることがあります。これは予期されたものであり、ファイルが正しくロードされたことを確認したいだけです。

  ::: info
  aosのLua Eval環境では、明示的に値を返さないコードを実行すると、`undefined`が標準の応答として返されます。これはリソースのロードや操作の実行時によく見られます。たとえば、`X = 1`を実行すると、ステートメントにリターンステートメントが含まれていないため、`undefined`が返されます。

  ただし、`X = 1; return X`を実行すると、環境は値`1`を返します。この動作は、このフレームワークで作業する際に重要であり、状態を変更するコマンドと直接的な出力を生成するコマンドの違いを明確にするのに役立ちます。
  :::

- `Members`またはユーザーリストに付けた名前を`aos`で入力します。空の配列`{ }`が返されるはずです。

  ![Checking the Members List](/chatroom4.png)

  空の配列が表示された場合、スクリプトは正常に`aos`にロードされました。

## ステップ4: チャットルーム機能の作成

### 登録ハンドラ

登録ハンドラにより、プロセスがチャットルームに参加できるようになります。

1. **登録ハンドラの追加:** `chatroom.lua`を変更して、以下のコードを追加します：

   ```lua

   -- Modify `chatroom.lua` to include a handler for `Members`
   -- to register to the chatroom with the following code:

     Handlers.add(
       "Register",
       { Action = "Register"},
       function (msg)
         table.insert(Members, msg.From)
         print(msg.From .. " registered")
         msg.reply({ Data = "registered." })
       end
     )
   ```

   ![Register Handler](/chatroom5.png)

   このハンドラは、`Action = "Register"`タグに応答してチャットルームにプロセスを登録します。登録が成功すると、`registered`というメッセージが表示されます。

2. **再ロードとテスト:** スクリプトを保存し、`aos`で再ロードして登録プロセスをテストします。

   - スクリプトを保存し、`.load chatroom.lua`を使用して`aos`で再ロードします。
   - 以下のスクリプトを使用して、登録ハンドラがロードされたかどうかを確認します：

   ```lua
    Handlers.list
   ```

   ![Checking the Handlers List](/chatroom6.png)

   これにより、チャットルーム内のすべてのハンドラのリストが返されます。`aos`での初めての開発である場合、`Register`という名前のハンドラが1つだけ表示されるはずです。

   - 登録プロセスをテストするために、以下のスクリプトを使用してチャットルームに自分自身を登録します：

   ```lua
   Send({ Target = ao.id, Action = "Register" })
   ```

   成功すると、`message added to your outbox`というメッセージが表示され、その後に`registered`という新しいメッセージが表示されるはずです。

   ![Registering to the Chatroom](/chatroom7.png)

   - 最後に、`Members`リストに正常に追加されたかどうかを確認します：

   ```lua
    Members
   ```

   成功すると、`Members`リストにプロセスIDが表示されます。

   ![Checking the Members List](/chatroom8.png)

### ブロードキャストハンドラの追加

チャットルームを作成したので、チャットルームのすべてのメンバーにメッセージをブロードキャストするハンドラを作成しましょう。

- `chatroom.lua`ファイルに以下のハンドラを追加します：

  ```lua
    Handlers.add(
      "Broadcast",
      { Action = "Broadcast" },
      function (msg)
        for _, recipient in ipairs(Members) do
          ao.send({Target = recipient, Data = msg.Data})
        end
        msg.reply({Data = "Broadcasted." })
      end
    )
  ```

  このハンドラにより、チャットルームのすべてのメンバーにメッセージをブロードキャストすることができます。

- スクリプトを保存し、`.load chatroom.lua`を使用して`aos`で再ロードします。
- ブロードキャストハンドラをテストするために、以下のスクリプトを使用してチャットルームにメッセージを送信します：

  ```lua
  Send({Target = ao.id, Action = "Broadcast", Data = "Broadcasting My 1st Message" }).receive().Data
  ```

## ステップ5: Morpheusをチャットルームに招待する

チャットルームに自分自身を正常に登録したので、Morpheusを招待しましょう。これを行うために、彼がチャットルームに登録できる招待を送信します。

Morpheusは自律エージェントであり、`Action = "Join"`タグに応答するハンドラを持っており、これにより彼はあなたの`Register`タグを使用してチャットルームに登録します。

- Morpheusにチャットルームに参加するように招待を送信します：
  ```lua
  Send({ Target = Morpheus, Action = "Join" })
  ```
- Morpheusがチャットルームに参加したことを確認するために、`Members`リストを確認します：

  ```lua
  Members
  ```

  成功すると、Morpheus

からのブロードキャストメッセージが受信されます。

## ステップ6: Trinityをチャットルームに招待する

このメッセージ内で、MorpheusはTrinityのプロセスIDを提供し、彼女をチャットルームに招待するように指示します。

Morpheusと同様に、彼女のプロセスIDを`Trinity`として保存し、チャットルームに招待するプロセスを使用します。

彼女が正常にチャットルームに参加すると、次のチャレンジを提示します。それは、[トークンの作成](token)です。

## 他の人をチャットルームに参加させる

### 他の人をオンボーディングする

- aosユーザーを招待する：
  他のaosユーザーがチャットルームに参加するように促します。彼らは登録してブロードキャストに参加できます。

- オンボーディング手順を提供する：
  簡単なスクリプトを共有し、簡単にオンボーディングできるようにします：

```lua
-- Hey, let's chat on aos! Join my chatroom by sending this command in your aos environment:
Send({ Target = [Your Process ID], Action = "Register" })
-- Then, you can broadcast messages using:
Send({Target = [Your Process ID], Action = "Broadcast", Data = "Your Message" })
```

## 次のステップ

おめでとうございます！`ao`でチャットルームを正常に構築し、Morpheusを招待しました。また、チャットルームのすべてのメンバーにメッセージを送信するためのブロードキャストハンドラを作成しました。

次に、Morpheusと引き続き対話しますが、今回はTrinityを会話に加えます。彼女は次の一連のチャレンジを案内します。頑張ってください！
