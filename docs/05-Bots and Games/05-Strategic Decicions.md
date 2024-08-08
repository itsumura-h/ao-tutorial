# 戦略的決定

[最新のゲーム状態](game-state)を利用して、ボットを`自律エージェント`に進化させることができます。この進化により、ゲーム状態に対する反応だけでなく、文脈、エネルギー、近接性を考慮して戦略的なアクションを行う機能が追加されます。

## コードの記述

`bot.lua`ファイルに戻り、次の関数を追加します：

```lua
-- 2点間の近接性を判断します。
function inRange(x1, y1, x2, y2, range)
    return math.abs(x1 - x2) <= range and math.abs(y1 - y2) <= range
end

-- 近接性とエネルギーに基づいて次の行動を戦略的に決定します。
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
    print("プレイヤーが範囲内にいます。攻撃します。")
    ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(player.energy)})
  else
    print("範囲内にプレイヤーがいないか、エネルギーが不足しています。ランダムに移動します。")
    local directionMap = {"Up", "Down", "Left", "Right", "UpRight", "UpLeft", "DownRight", "DownLeft"}
    local randomIndex = math.random(#directionMap)
    ao.send({Target = Game, Action = "PlayerMove", Player = ao.id, Direction = directionMap[randomIndex]})
  end
end
```

`decideNextAction`関数は、エージェントが環境の包括的な理解に基づいて考え行動する能力を示しています。最新のゲーム状態を分析し、エネルギーが十分で範囲内に相手がいる場合は攻撃し、そうでない場合は移動します。

次に、この関数が自動的に実行されるようにハンドラを追加します。

```lua
Handlers.add(
  "decideNextAction",
  { Action = "UpdatedGameState" },
  function ()
    if LatestGameState.GameMode ~= "Playing" then
      return
    end
    print("次のアクションを決定しています。")
    decideNextAction()
  end
)
```

このハンドラは、最新のゲーム状態が取得され更新されたときにトリガーされます。ゲームが`Playing`モードのときだけアクションが実行されます。

最新の`bot.lua`コードは以下のドロップダウンから参照できます：

<details>
  <summary><strong>更新された bot.lua ファイル</strong></summary>

```lua
LatestGameState = LatestGameState or nil

function inRange(x1, y1, x2, y2, range)
    return math.abs(x1 - x2) <= range and math.abs(y1 - y2) <= range
end

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
    print("プレイヤーが範囲内にいます。攻撃します。")
    ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(player.energy)})
  else
    print("範囲内にプレイヤーがいないか、エネルギーが不足しています。ランダムに移動します。")
    local directionMap = {"Up", "Down", "Left", "Right", "UpRight", "UpLeft", "DownRight", "DownLeft"}
    local randomIndex = math.random(#directionMap)
    ao.send({Target = Game, Action = "PlayerMove", Player = ao.id, Direction = directionMap[randomIndex]})
  end
end

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
end
)

Handlers.add(
"decideNextAction",
{ Action = "UpdatedGameState" },
function ()
  if LatestGameState.GameMode ~= "Playing" then
    return
  end
  print("次のアクションを決定しています。")
  decideNextAction()
end
)
```

</details>

## ロードとテスト

最新のアップグレードをテストするために、aosプレイヤーターミナルで次のようにファイルをロードします：

```lua
.load bot.lua
```

プロセスの出力を観察し、自律エージェントがリアルタイムで戦略的な利点を活かしてどのように決定を行うかを確認してください。しかし、他のプレイヤーがあなたを攻撃して逃げた場合はどうしますか？次のセクションでは、攻撃を受けた際に自動的に反撃する方法を学びます 🤺
