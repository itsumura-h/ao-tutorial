# まとめ

この最終ガイドでは、自律エージェントを一つ一つの要素から構築してきたシリーズを締めくくります。ここで、エージェントの動作を最適化するためにいくつかの改善を行います。以下は、主な改善点の概要です：

- **シーケンシャルコマンド実行**：`InAction`フラグの導入により、エージェントのアクションがシーケンシャルに実行されるようになりました（前のアクションが成功した場合にのみ次のアクションが実行されます）。この重要な追加により、エージェントが古いゲーム状態に基づいて行動するのを防ぎ、応答性と正確性が向上します。完全な実装は以下の`bot.lua`ファイルの最終コードにあります。

```lua
InAction = InAction or false -- エージェントが同時に複数のアクションを実行しないようにする。
```

- **動的状態更新と決定**：エージェントは自動ティックロジックを使用して動的な更新と決定を行います。このロジックにより、エージェントはティックメッセージを受信したときやアクションを完了したときに自動的に状態を更新し、次の決定を行います。これにより、自律的な動作が促進されます。

```lua
Handlers.add("GetGameStateOnTick", { Action = "Tick" }, function ()
  if not InAction then
    InAction = true
    ao.send({Target = Game, Action = "GetGameState"})
  end
end)
```

- **自動料金転送**：ゲームへの参加を確実にし、中断を防ぐために、自律エージェントは確認料金の転送を自動化します。

```lua
Handlers.add("AutoPay", { Action = "AutoPay" }, function ()
  ao.send({Target = Game, Action = "Transfer", Recipient = Game, Quantity = "1000"})
end)
```

これらの機能に加えて、デバッグ用のロギング機能とゲームイベントの理解を深めるためのカラープリントを追加しました。これらの改善により、自律エージェントはゲーム環境でより効率的で適応性が向上します。

以下のドロップダウンで完全な`bot.lua`コードを確認できます。新しい追加部分は適宜強調されています：

<details>
  <summary><strong>更新された bot.lua ファイル</strong></summary>

```lua
-- 最新のゲーム状態とゲームホストプロセスを保存するためのグローバル変数の初期化。
LatestGameState = LatestGameState or nil
InAction = InAction or false -- エージェントが同時に複数のアクションを実行しないようにする。

Logs = Logs or {}

colors = {
  red = "\27[31m",
  green = "\27[32m",
  blue = "\27[34m",
  reset = "\27[0m",
  gray = "\27[90m"
}

function addLog(msg, text) -- デバッグ用の関数定義はパフォーマンス向上のためコメントアウト、必要に応じて使用可能
  Logs[msg] = Logs[msg] or {}
  table.insert(Logs[msg], text)
end

-- 2点間の距離が指定された範囲内にあるかどうかをチェックします。
-- @param x1, y1: 最初の点の座標。
-- @param x2, y2: 2番目の点の座標。
-- @param range: ポイント間の最大許容距離。
-- @return: ポイントが指定された範囲内にあるかどうかを示すブール値。
function inRange(x1, y1, x2, y2, range)
    return math.abs(x1 - x2) <= range and math.abs(y1 - y2) <= range
end

-- プレイヤーの近接性とエネルギーに基づいて次のアクションを決定します。
-- 任意のプレイヤーが範囲内にいる場合、攻撃を開始します。そうでなければ、ランダムに移動します。
function decideNextAction()
  local player = LatestGameState.Players[ao.id]
  local targetInRange = false

  for target, state in pairs(LatestGameState.Players) do
      if target ~= ao.id and inRange(player.x, player.y, state.x, state.y, 1) then
          targetInRange = true
          break
      end
  end

  if player.energy > 5 and targetInRange then
    print(colors.red .. "プレイヤーが範囲内にいます。攻撃します。" .. colors.reset)
    ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(player.energy)})
  else
    print(colors.red .. "範囲内にプレイヤーがいないか、エネルギーが不足しています。ランダムに移動します。" .. colors.reset)
    local directionMap = {"Up", "Down", "Left", "Right", "UpRight", "UpLeft", "DownRight", "DownLeft"}
    local randomIndex = math.random(#directionMap)
    ao.send({Target = Game, Action = "PlayerMove", Player = ao.id, Direction = directionMap[randomIndex]})
  end
  InAction = false -- InActionロジック追加
end

-- ゲームのアナウンスを表示し、ゲーム状態の更新をトリガーするハンドラ。
Handlers.add(
  "PrintAnnouncements",
  { Action = "Announcement" },
  function (msg)
    if msg.Event == "Started-Waiting-Period" then
      ao.send({Target = ao.id, Action = "AutoPay"})
    elseif (msg.Event == "Tick" or msg.Event == "Started-Game") and not InAction then
      InAction = true -- InActionロジック追加
      ao.send({Target = Game, Action = "GetGameState"})
    elseif InAction then -- InActionロジック追加
      print("前のアクションがまだ進行中です。スキップします。")
    end
    print(colors.green .. msg.Event .. ": " .. msg.Data .. colors.reset)
  end
)

-- ティックメッセージを受信したときにゲーム状態の更新をトリガーするハンドラ。
Handlers.add(
  "GetGameStateOnTick",
  { Action =  "Tick" },
  function ()
    if not InAction then -- InActionロジック追加
      InAction = true -- InActionロジック追加
      print(colors.gray .. "ゲーム状態を取得中..." .. colors.reset)
      ao.send({Target = Game, Action = "GetGameState"})
    else
      print("前のアクションがまだ進行中です。スキップします。")
    end
  end
)

-- 待機期間が始まったときに確認料金の支払いを自動化するハンドラ。
Handlers.add(
  "AutoPay",
  { Action =  "AutoPay" },
  function (msg)
    print("確認料金を自動支払いします。")
    ao.send({ Target = Game, Action = "Transfer", Recipient = Game, Quantity = "1000"})
  end
)

-- ゲーム状態情報を受け取った際にゲーム状態を更新するハンドラ。
Handlers.add(
  "UpdateGameState",
  { Action =  "GameState" },
  function (msg)
    local json = require("json")
    LatestGameState = json.decode(msg.Data)
    ao.send({Target = ao.id, Action = "UpdatedGameState"})
    print("ゲーム状態が更新されました。'LatestGameState'を印刷して詳細を表示します。")
  end
)

-- 次の最適なアクションを決定するハンドラ。
Handlers.add(
  "decideNextAction",
  { Action =  "UpdatedGameState" },
  function ()
    if LatestGameState.GameMode ~= "Playing" then
      InAction = false -- InActionロジック追加
      return
    end
    print("次のアクションを決定しています。")
    decideNextAction()
    ao.send({Target = ao.id, Action = "Tick"})
  end
)

-- 他のプレイヤーから攻撃を受けたときに自動的に反撃するハンドラ。
Handlers.add(
  "ReturnAttack",
  { Action =  "Hit" },
  function (msg)
    if not InAction then -- InActionロジック追加
      InAction = true -- InActionロジック追加
      local playerEnergy = LatestGameState.Players[ao.id].energy
      if playerEnergy == undefined then
        print(colors.red .. "エネルギーを読み取れません。" .. colors.reset)
        ao.send({Target = Game, Action

 = "Attack-Failed", Reason = "エネルギーを読み取れません。"})
      elseif playerEnergy == 0 then
        print(colors.red .. "プレイヤーのエネルギーが不足しています。" .. colors.reset)
        ao.send({Target = Game, Action = "Attack-Failed", Reason = "プレイヤーのエネルギーがありません。"})
      else
        print(colors.red .. "反撃します。" .. colors.reset)
        ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(playerEnergy)})
      end
      InAction = false -- InActionロジック追加
      ao.send({Target = ao.id, Action = "Tick"})
    else
      print("前のアクションがまだ進行中です。スキップします。")
    end
  end
)
```

</details>

## 次は何をする？

知識を駆使してインテリジェントな自律エージェントを作成する方法を習得しました。これらの洞察をゲームの世界に応用する時が来ました。ゲームの詳細を理解し、エージェントの能力を活用してアリーナで優位に立ちましょう。しかし、まだ続きがあります。

今後のセクションでは、ゲームアリーナの詳細に深く掘り下げ、エージェントのパフォーマンスを向上させるための高度な戦略を提供します。挑戦を受けて立つ準備はできていますか？何が作れるか見てみましょう！ 🕹️
