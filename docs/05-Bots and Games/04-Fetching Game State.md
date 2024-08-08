# ゲーム状態の取得

ターミナルにゲームのアナウンスが表示されるようになり、ゲームのダイナミクスをよりよく把握できるようになりました。しかし、これらのインサイトはゲーム内で発生する特定のアクションに限定されています。

すべてのプレイヤーの位置、健康、エネルギーなどの包括的なゲームデータにオンデマンドでアクセスできると、戦略的な計画が大幅に改善され、脅威、機会、タイミングの評価がより効果的になるでしょう。

前のガイドで作成したボットに別のハンドラを追加することを考えたなら、その通りです！

## コードの記述

`bot.lua`ファイルに戻り、既存のハンドラを次のように更新します：

```lua
Handlers.add(
  "HandleAnnouncements",
  { Action = "Announcement" },
  function (msg)
    ao.send({Target = Game, Action = "GetGameState"})
    print(msg.Event .. ": " .. msg.Data)
  end
)
```

ハンドラの調整内容：

- 役割を広げるために名前を`"HandleAnnouncements"`に変更。
- 最新のゲーム状態を要求する追加の操作を追加。ゲームは`GetGameState`アクションタグに応答するように設計されています。

アナウンスを印刷した後、`Inbox`で最新のメッセージを次のように確認できます：

```lua
Inbox[#Inbox]
```

このメッセージの`Data`フィールドには、最新のゲーム状態が含まれています：

- `GameMode`: ゲームが`Waiting`状態か`Playing`状態か。
- `TimeRemaining`: ゲームの開始または終了までの残り時間。
- `Players`: すべてのプレイヤーの位置、健康、エネルギーなどのステータスを含むテーブル。

しかし、これを一歩進めて、最新の状態から情報を読み取るだけでなく、他の自動化に使用できるようにしましょう。

最新の状態を保存する新しい変数を次のように定義しましょう：

```lua
LatestGameState = LatestGameState or nil
```

この構文は、ターミナルで`bot.lua`ファイルの連続したバージョンをロードするときに変数の既存の値を保持し、上書きしません。既存の値がない場合、変数に`nil`値が割り当てられます。

次に、別のハンドラを次のように実装します：

```lua
-- ゲーム状態情報を受け取った際にゲーム状態を更新するハンドラ。
Handlers.add(
  "UpdateGameState",
  { Action = "GameState" },
  function (msg)
    local json = require("json")
    LatestGameState = json.decode(msg.Data)
    ao.send({Target = ao.id, Action = "UpdatedGameState"})
    print("Game state updated. Print \'LatestGameState\' for detailed view.")
  end
)
```

前のハンドラからのゲームプロセスの応答には、アクションタグ`GameState`の値が含まれており、この2番目のハンドラをトリガーします。トリガーされると、ハンドル関数は組み込みの`json`パッケージをロードし、データをjsonに解析して`LatestGameState`変数に保存します。

このハンドラは、状態が更新されたときにプロセスにメッセージを送信します。この機能の重要性は次のセクションで説明します。

最新の`bot.lua`コードは以下のドロップダウンから参照できます：

<details>
  <summary><strong>更新された bot.lua ファイル</strong></summary>

```lua
LatestGameState = LatestGameState or nil

Handlers.add(
"HandleAnnouncements",
{ Action = "Announcement" },
function (msg)
  ao.send({Target = Game, Action = "GetGameState"})
  print(msg.Event .. ": " .. msg.Data)
end
)

Handlers.add(
"UpdateGameState",
{ Action = "GameState" },
function (msg)
  local json = require("json")
  LatestGameState = json.decode(msg.Data)
  ao.send({Target = ao.id, Action = "UpdatedGameState"})
  print("Game state updated. Print \'LatestGameState\' for detailed view.")
end
)
```

</details>

## ロードとテスト

この新機能をテストするために、aosプレイヤーターミナルで次のようにファイルをロードします：

```lua
.load bot.lua
```

次に、`LatestGameState`が正しく更新されたかどうかを確認するために、その名前を次のように入力します：

```lua
LatestGameState
```

ゲームの最新状態へのリアルタイムアクセスを持つことで、ボットは次のアクションを決定するための情報に基づいた決定を下せるようになります。次に、このデータを活用してアクションを自動化してみましょう 🚶
