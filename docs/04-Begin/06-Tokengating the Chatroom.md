# チャットルームのトークンゲート

::: info
トークンを作成して`Trinity`に送信したので、そのトークンを使用してチャットルームをトークンゲートできます。これにより、トークンを持っている人だけがチャットルームに入ることができます。
:::

## ビデオチュートリアル

<iframe width="680" height="350" src="https://www.youtube.com/embed/VTYmd_E4Igc?si=CEQ0i8qeh33-eJKN" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## チャットルームのトークンゲート方法

チャットルームをトークンゲートするためのハンドラを作成しましょう。このハンドラは`Action = "Broadcast"`タグに応答し、チャットルーム用に作成したオリジナルの`Broadcast`ハンドラを置き換えます。

## ステップ1：同じ`aos`プロセスを開始する

チュートリアル全体で使用してきた同じ`aos`プロセスを使用していることを確認してください。

## ステップ2：`chatroom.lua`ファイルを開く

これは、[チャットルーム](chatroom)のチュートリアルでチャットルームを作成するために使用したファイルです。

## ステップ3：`Broadcast`ハンドラを編集する

オリジナルの`Broadcast`ハンドラを次のコードに置き換えます：

```lua
Handlers.add(
    "Broadcast",
    { Action = "Broadcast" },
    function(m)
        if Balances[m.From] == nil or tonumber(Balances[m.From]) < 1 then
            print("UNAUTH REQ: " .. m.From)
            return
        end
        local type = m.Type or "Normal"
        print("Broadcasting message from " .. m.From .. ". Content: " .. m.Data)
        for i = 1, #Members, 1 do
            ao.send({
                Target = Members[i],
                Action = "Broadcasted",
                Broadcaster = m.From,
                Data = m.Data
            })
        end
    end
)
```

このハンドラは、メッセージをチャットルームにブロードキャストする前に送信者のトークン残高を確認します。送信者がトークンを持っていない場合、メッセージはブロードキャストされません。

ファイルを保存します。

## ステップ4：`chatroom.lua`ファイルを再ロードする

オリジナルの`broadcast`ハンドラを新しいものに置き換えるために、`chatroom.lua`ファイルを再ロードします。

```lua
.load chatroom.lua
```

## ステップ5：トークンゲートのテスト

チャットルームがトークンゲートされたので、チャットルームにメッセージを送信してテストします。

### オリジナルのaosプロセスから

まず、オリジナルのaosプロセスからテストします。

```lua
Send({ Target = ao.id , Action = "Broadcast", Data = "Hello" })
```

期待される結果：

```
{
   output = "Message added to outbox",
   ...
}
Broadcasting message from [Your Process ID]. Content: Hello.
New Message From [Your Process ID]: Action = Broadcasted
```

## 別のプロセスIDからのテスト

### 新しいaosプロセスから

次に、トークンを持っていない新しいaosプロセスからテストします。

```sh
aos chatroom-no-token # 新しいプロセス名を指定
```

まず、チャットルームに登録する必要があります。

```lua
.load chatroom.lua
Send({ Target = ao.id, Action = "Register" })
```

期待される結果：

```
message added to outbox
New Message From [Your Process ID]: Data = registered
```

次に、チャットルームにメッセージを送信してみます。

```lua
Send({ Target = ao.id , Action = "Broadcast", Data = "Hello?" })
```

期待される結果：

```
message added to outbox
UNAUTH REQ: [New Process ID]
```

ご覧のとおり、新しいプロセスはトークンを持っていないため、メッセージはブロードキャストされませんでした。

## Trinityに「完了しました」と伝える

オリジナルのaosプロセスから、チャットルームに「It is done」と言うブロードキャストメッセージを送信します。

```lua
Send({ Target = ao.id , Action = "Broadcast", Data = "It is done" })
```

::: warning
正確なデータの一致と大文字小文字の区別に注意してください。MorpheusやTrinityからの応答がない場合は、データとタグの内容を確認してください。
:::

Trinityはチャットルームがトークンゲートされたことに応答します。

### 期待される結果：

Trinityは次のようにメッセージを送信します：
"I guess Morpheus was right. You are the one. Consider me impressed.
You are now ready to join The Construct, an exclusive chatroom available
to only those that have completed this tutorial.
Now, go join the others by using the same tag you used `Register`, with
this process ID: [Construct Process ID]
Good luck.
-Trinity". メッセージの後にはフッターが続きます。

## 結論

やりました！チャットルームをトークンゲートすることに成功しました。これで、チュートリアルを完全に完了した人だけが入ることができる`Construct`へのアクセスが解除されました。

### おめでとうございます！

多くの可能性を示しました。このチュートリアルを楽しんでいただけたでしょうか。これで`ao`で自由に構築する準備が整いました。
