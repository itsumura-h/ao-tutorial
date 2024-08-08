# ゲームをしよう！

チュートリアルをがんばってこなしてきましたね！ここで少し休憩して、エキサイティングなことに挑戦してみましょう。学習の旅に楽しいひとときを加えるゲームはいかがですか？

![AO-Effect Game Banner](/ao-effect-game-banner.png)

## どんなゲーム？

`ao-effect`は、友達や世界中の他のプレイヤーとリアルタイムで競い合うことができるゲームです。この冒険のために、グローバルなゲームプロセスを設定しました。

ルールは簡単です。各プレイヤーは40x40のグリッドでスタートし、健康度は100、エネルギーは0です。エネルギーは最大100まで時間とともに補充されます。グリッドを移動し、他のプレイヤーを見つけ、彼らが範囲内にいるときにエネルギーを使って攻撃します。最後の1人が残るまで、または所定の時間が経過するまで戦いは続きます。

ゲームの詳細なガイドについては、[アリーナの仕組み](arena-mechanics.md)と[アリーナの拡張](build-game.md)をチェックしてください。

> 注意: 一部のコマンド構文が見慣れない場合は心配しないでください。各コマンドの目的を高レベルで理解し、ゲームを楽しむことに集中してください！

## ao-effectの準備

このグローバルな冒険に参加するには、設定が必要です。心配しないで、簡単です！

1. **aosをインストール**

ターミナルを開いて次のコマンドを実行します：

```bash
npm i -g https://get_ao.g8way.io
```

2. **aosを起動**

次に、aosのインスタンスを作成します：

```bash
aos
```

3. **ゲームIDを設定**

ゲームサーバーIDをすぐにアクセスできるように手元に置いておきましょう：

```lua
Game = "tm1jYBC0F2gTZ0EuUQKq5q_esxITDFkAG6QEpLbpI9I"
```

4. **ターミナルにゲームのアナウンスを直接表示（オプション）**

アナウンスの詳細を表示するハンドラを作成する方法はこちらです：

_これは一時的なもので、次のセクションでLuaスクリプトを介してロードします。_

```lua
Handlers.add(
  "PrintAnnouncements",
  { Action = "Announcement" },
  function (msg)
    ao.send({Target = Game, Action = "GetGameState"})
    print(msg.Event .. ": " .. msg.Data)
  end
)
```

これでゲームに参加する準備が整いました。

## ゲームに登録する方法

参加の準備はできましたか？いくつかの簡単なステップで開始できます：

### ゲームサーバーに登録

`ao`のプロセス間の通信はすべてメッセージを通じて行われます。登録するには、次のメッセージをゲームサーバーに送信します：

```lua
Send({ Target = Game, Action = "Register" })

-- Expected Result --
{
   output = "Message added to outbox",
   onReply = function: 0x29e5ac0,
   receive = function: 0x29fe440
}
New Message From tm1...I9I: Action = Registered
New Player Registered: a1b...y1z has joined in waiting.
```

これで`Waiting`ロビーに入ります。場所を確保するには少額の料金が必要です。

### 場所を確保する

場所を確保するにはトークンが必要です。ゲームに次のメッセージを送信してトークンを取得します：

```lua
Send({ Target = Game, Action = "RequestTokens"}).receive().Data

-- Expected Result --
You received 10000000 from a1b2C3d4e5F6g7h8IjkLm0nOpqR8s7t6U5v4w3X2y1z
```

> 注意
> `.receive().Data`は、一時的な[Handler](../../references/handlers.md#handlers-once-name-pattern-handler)を追加して一度だけ実行し、応答データを表示します。代わりに応答が受信トレイに届くのを待ちたい場合は、`.receive()`なしで`Send()`を呼び出し、`Inbox[#Inbox].Data`を実行して応答データを確認できます。
>
> `.receive()`で追加されたハンドラ：
>
> ```
> {
>   name = "_once_0",
>   maxRuns = 1,
>   pattern = {  },
>   handle = function: 0x2925700
> }
> ```

トークンを受け取ったら、次のようにしてゲームの参加費を支払います：

```lua
Send({ Target = Game, Action = "Transfer", Recipient = Game, Quantity = "1000"}).receive().Data

-- Expected Result --
You transferred 1000 to tm1jYBC0F2gTZ0EuUQKq5q_esxITDFkAG6QEpLbpI9I
New Message From tm1...I9I: Action = Payment-Received
```

数秒待つと、プレイヤーの支払いとステータスに関するライブアップデートがターミナルに表示されます。

## ゲームスタート！

### ゲームの仕組み

ゲームの開始: `WaitTime`の2分後、少なくとも2人のプレイヤーが支払いを行った場合にゲームが開始されます。支払いを行わなかったプレイヤーは削除されます。十分なプレイヤーが支払わない場合、支払いを行ったプレイヤーは返金されます。

プレイヤーはゲーム開始時にランダムなグリッドポイントにスポーンします。

### 行動開始！

移動: 最初にできることは移動です。エネルギーは不要です！任意の方向に1マス移動できます：上、下、左、右、または斜め。方向と共にプレイヤーIDも渡して、ゲームが動きを識別できるようにします。次のようにします：

```lua
Send({ Target = Game, Action = "PlayerMove", Player = ao.id, Direction = "DownRight"})
```

利用可能な移動方向は次の通りです：

```lua
Up = {x = 0, y = -1},
Down = {x = 0, y = 1},
Left = {x = -1, y = 0},
Right = {x = 1, y = 0},
UpRight = {x = 1, y = -1},
UpLeft = {x = -1, y = -1},
DownRight = {x = 1, y = 1},
DownLeft = {x = -1, y = 1}
```

> 注意: 方向は大文字小文字を区別します！

グリッド外に移動すると、反対側にポップアップします。

### 攻撃の時！

攻撃: ゲームが進行するにつれてエネルギーが蓄積されます。これを使って3x3グリッド範囲内の他のプレイヤーを攻撃します。自分にはダメージはありませんが、範囲内の他のプレイヤーには影響を与えます。

```lua
Send({ Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = "energy_integer"})
```

健康度は100で始まり、他のプレイヤーからの攻撃で減少します。0になるとゲームオーバーです。

## 終了

ゲームは1人のプレイヤーが残るか、時間が切れると終了します。勝者には報酬が与えられ、その後は再びロビーに戻ります。

ゲームを楽しんでいただけましたか？体験をさらに向上させたり、勝率を高める方法があるとしたらどうでしょうか。次のガイドをチェックしてみてください🤔
