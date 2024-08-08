# 自動応答

[前回のガイド](decisions)に従い、単純なボットから洗練された自律エージェントへと進化しました。次に、その機能をさらに強化し、カウンターアタック機能を追加します。これにより、攻撃を受けた際に即座に反撃でき、相手が逃げる前に驚かせることができます。

## コードの記述

`bot.lua`ファイルに次のハンドラを追加します：

```lua
-- 他のプレイヤーから攻撃を受けたときに自動的に反撃するハンドラ。
Handlers.add(
  "ReturnAttack",
  { Action = "Hit" },
  function (msg)
      local playerEnergy = LatestGameState.Players[ao.id].energy
      if playerEnergy == undefined then
        print("エネルギーを読み取れません。")
        ao.send({Target = Game, Action = "Attack-Failed", Reason = "エネルギーを読み取れません。"})
      elseif playerEnergy == 0 then
        print("プレイヤーのエネルギーが不足しています。")
        ao.send({Target = Game, Action = "Attack-Failed", Reason = "プレイヤーのエネルギーがありません。"})
      else
        print("反撃します。")
        ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(playerEnergy)})
      end
      InAction = false
      ao.send({Target = ao.id, Action = "Tick"})
  end
)
```

プレイヤーが攻撃を受けると、`Hit`アクションのメッセージを受信します。この設定により、エージェントは十分なエネルギーがある場合に即座に反撃できます。

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
  { Action =  "Announcement" },
  function (msg)
    ao.send({Target = Game, Action = "GetGameState"})
    print(msg.Event .. ": " .. msg.Data)
  end
)

Handlers.add(
  "UpdateGameState",
  { Action =  "GameState" },
  function (msg)
    local json = require("json")
    LatestGameState = json.decode(msg.Data)
    ao.send({Target = ao.id, Action = "UpdatedGameState"})
  end
)

Handlers.add(
  "decideNextAction",
  { Action =  "UpdatedGameState" },
  function ()
    if LatestGameState.GameMode ~= "Playing" then
      return
    end
    print("次のアクションを決定しています。")
    decideNextAction()
  end
)

Handlers.add(
  "ReturnAttack",
  { Action =  "Hit" },
  function (msg)
      local playerEnergy = LatestGameState.Players[ao.id].energy
      if playerEnergy == undefined then
        print("エネルギーを読み取れません。")
        ao.send({Target = Game, Action = "Attack-Failed", Reason = "エネルギーを読み取れません。"})
      elseif playerEnergy == 0 then
        print("プレイヤーのエネルギーが不足しています。")
        ao.send({Target = Game, Action = "Attack-Failed", Reason = "プレイヤーのエネルギーがありません。"})
      else
        print("反撃します。")
        ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(playerEnergy)})
      end
      InAction = false
      ao.send({Target = ao.id, Action = "Tick"})
  end
)
```

</details>

## ロードとテスト

カウンターアタック機能をアクティブにしてテストするために、aosプレイヤーターミナルでボットファイルをロードします：

```lua
.load bot.lua
```

ターミナルで自律エージェントの反応を観察し、即座に反撃する機能を確認します。この機能により、エージェントの戦略的深さと自律性が進化していることが示されます。次のセクションでは、これまでに得た知識を統合し、最適化のためのいくつかの機能を追加します。
