# アリーナのメカニクス

このガイドでは、`aos`でアリーナスタイルのゲームを設計および管理するために必要な基本的なメカニクスの包括的な概要を提供します。アリーナゲームでは、参加者はラウンドごとに戦略的に競い合い、最後の勝者が残るまで相手を排除します。

ここで紹介するフレームワークは、同じ基本機能を共有するさまざまなゲームを構築するための基盤を提供します。ゲーム開発の詳細を探求し、この多用途のアリーナ内で創造力を発揮しましょう。

## 基本機能

アリーナスタイルのゲームを支える基本機能について説明します：

1. **ゲーム進行モード：**

アリーナゲームはラウンドごとに構造化されており、次の進行モードがループします： `"Not-Started"` → `"Waiting"` → `"Playing"` → `[誰かが勝つかタイムアウト]` → `"Waiting"`...

> [!注意]
> 待機状態後に十分なプレイヤーがいない場合、ループはタイムアウトします。

ラウンドはプレイヤーが参加するための定義された時間枠を提供し、ゲームプレイの興奮を増幅させます。

2. **トークンステーク：**

プレイヤーはゲームに参加するために指定された数量のトークン（`PaymentQty`で定義）をデポジットする必要があります。これらのトークンはゲームに実質的なステーク要素を追加します。

3. **ボーナス報酬：**

勝利のスリルを超えて、プレイヤーは追加の報酬の可能性に引き付けられます。ビルダーは、ラウンドごとに分配されるボーナストークン（`BonusQty`で定義）を提供する柔軟性を持ちます。プレイヤーが行ったベットもこれらのボーナスに追加されます。これらのボーナスは追加のインセンティブとなり、ゲームプレイの競争精神を高めます。

4. **プレイヤー管理：**

- 次のゲームに参加を待っているプレイヤーは`Waiting`テーブルで追跡されます。
- アクティブなプレイヤーとそのゲーム状態は`Players`テーブルに保存されます。
- 排除されたプレイヤーはすぐに`Players`テーブルから削除され、次のゲームのために`Waiting`テーブルに配置されます。

5. **ラウンド勝者の報酬：**

プレイヤーが他のプレイヤーを排除すると、勝者は自分のオリジナルのステークに加えて、排除されたプレイヤーのデポジットトークンを報酬として受け取ります。さらに、各ラウンドの勝者はボーナストークンの一部も分配されます。

6. **リスナーモード：**

アクティブに参加するのではなく、ゲームの進行を見守りたい人には「リスナー」モードがあります。プロセスはリスナーとして登録され、ゲームのすべてのアナウンスにアクセスできます。プレイヤーとして参加しない場合でも、明示的に削除をリクエストしない限り、ゲームの進行を観察し続けることができます。

7. **ゲーム状態管理：**

アリーナゲームの流れと公平性を維持するために、自動化システムがゲーム状態の遷移を監視します。これらの遷移は、待機、プレイ、終了フェーズを含みます。各状態の時間（`WaitTime`および`GameTime`）は、ラウンドが無期限に続かないように定義された時間枠に従うことを保証します。

アリーナのコードは以下のドロップダウンで確認できます：

<details>
  <summary><strong>アリーナゲームのブループリント</strong></summary>

```lua
-- ARENA GAME BLUEPRINT.

-- This blueprint provides the framework to operate an 'arena' style game
-- inside an ao process. Games are played in rounds, where players aim to
-- eliminate one another until only one remains, or until the game time
-- has elapsed. The game process will play rounds indefinitely as players join
-- and leave.

-- When a player eliminates another, they receive the eliminated player's deposit token
-- as a reward. Additionally, the builder can provide a bonus of these tokens
-- to be distributed per round as an additional incentive. If the intended
-- player type in the game is a bot, providing an additional 'bonus'
-- creates an opportunity for coders to 'mine' the process's
-- tokens by competing to produce the best agent.

-- The builder can also provide other handlers that allow players to perform
-- actions in the game, calling 'eliminatePlayer()' at the appropriate moment
-- in their game logic to control the framework.

-- Processes can also register in a 'Listen' mode, where they will receive
-- all announcements from the game, but are not considered for entry into the
-- rounds themselves. They are also not unregistered unless they explicitly ask
-- to be.

-- GLOBAL VARIABLES.

-- Game progression modes in a loop:
-- [Not-Started] -> Waiting -> Playing -> [Someone wins or timeout] -> Waiting...
-- The loop is broken if there are not enough players to start a game after the waiting state.
GameMode = GameMode or "Not-Started"
StateChangeTime = StateChangeTime or undefined

-- State durations (in milliseconds)
WaitTime = WaitTime or 2 * 60 * 1000 -- 2 minutes
GameTime = GameTime or 20 * 60 * 1000 -- 20 minutes
Now = Now or undefined -- Current time, updated on every message.

-- Token information for player stakes.
UNIT = 1000
PaymentToken = PaymentToken or "ADDR"  -- Token address
PaymentQty = PaymentQty or tostring(math.floor(UNIT))    -- Quantity of tokens for registration
BonusQty = BonusQty or tostring(math.floor(UNIT))        -- Bonus token quantity for winners

-- Players waiting to join the next game and their payment status.
Waiting = Waiting or {}
-- Active players and their game states.
Players = Players or {}
-- Number of winners in the current game.
Winners = 0
-- Processes subscribed to game announcements.
Listeners = Listeners or {}
-- Minimum number of players required to start a game.
MinimumPlayers = MinimumPlayers or 2

-- Default player state initialization.
PlayerInitState = PlayerInitState or {}

-- Sends a state change announcement to all registered listeners.
-- @param event: The event type or name.
-- @param description: Description of the event.
function announce(event, description)
    for ix, address in pairs(Listeners) do
        ao.send({
            Target = address,
            Action = "Announcement",
            Event = event,
            Data = description
        })
    end
    return print(Colors.gray .. "Announcement: " .. Colors.red .. event .. " " .. Colors.blue .. description .. Colors.reset)
end

-- Sends a reward to a player.
-- @param recipient: The player receiving the reward.
-- @param qty: The quantity of the reward.
-- @param reason: The reason for the reward.
function sendReward(recipient, qty, reason)
    if type(qty) ~= number then
      qty = tonumber(qty)
    end
    ao.send({
        Target = PaymentToken,
        Action = "Transfer",
        Quantity = tostring(qty),
        Recipient = recipient,
        Reason = reason
    })
    return print(Colors.gray .. "Sent Reward: " ..
      Colors.blue .. tostring(qty) ..
      Colors.gray .. ' tokens to ' ..
      Colors.green .. recipient .. " " ..
      Colors.blue .. reason .. Colors.reset
    )
end

-- Starts the waiting period for players to become ready to play.
function startWaitingPeriod()
    GameMode = "Waiting"
    StateChangeTime = Now + WaitTime
    announce("Started-Waiting-Period", "The game is about to begin! Send your token to take part.")
    print('Starting Waiting Period')
end

-- Starts the game if there are enough players.
function startGamePeriod()
    local paidPlayers = 0
    for player, hasPaid in pairs(Waiting) do
        if hasPaid then
            paidPlayers = paidPlayers + 1
        end
    end

    if paidPlayers < MinimumPlayers then
        announce("Not-Enough-Players", "Not enough players registered! Restarting...")
        for player, hasPaid in pairs(Waiting) do
            if hasPaid then
                Waiting[player] = false
                sendReward(player, PaymentQty, "Refund")
            end
        end
        startWaitingPeriod()
        return
    end

    LastTick = undefined
    GameMode = "Playing"
    StateChangeTime = Now + GameTime
    for player, hasPaid in pairs(Waiting) do
        if hasPaid then
            Players[player] = playerInitState()
       

 else
            ao.send({
                Target = player,
                Action = "Ejected",
                Reason = "Did-Not-Pay"
            })
            removeListener(player) -- Removing player from listener if they didn't pay
        end
    end
    announce("Started-Game", "The game has started. Good luck!")
    print("Game Started....")
end

-- Handles the elimination of a player from the game.
-- @param eliminated: The player to be eliminated.
-- @param eliminator: The player causing the elimination.
function eliminatePlayer(eliminated, eliminator)
    sendReward(eliminator, PaymentQty, "Eliminated-Player")
    Waiting[eliminated] = false
    Players[eliminated] = nil

    ao.send({
        Target = eliminated,
        Action = "Eliminated",
        Eliminator = eliminator
    })

    announce("Player-Eliminated", eliminated .. " was eliminated by " .. eliminator .. "!")

    local playerCount = 0
    for player, _ in pairs(Players) do
        playerCount = playerCount + 1
    end
    print("Eliminating player: " .. eliminated .. " by: " .. eliminator) -- Useful for tracking eliminations

    if playerCount < MinimumPlayers then
        endGame()
    end

end

-- Ends the current game and starts a new one.
function endGame()
    print("Game Over")

    Winners = 0
    Winnings = tonumber(BonusQty) / Winners -- Calculating winnings per player

    for player, _ in pairs(Players) do
        Winners = Winners + 1
    end

    Winnings = tonumber(BonusQty) / Winners

    for player, _ in pairs(Players) do
        -- addLog("EndGame", "Sending reward of:".. Winnings + PaymentQty .. "to player: " .. player) -- Useful for tracking rewards
        sendReward(player, Winnings + tonumber(PaymentQty), "Win")
        Waiting[player] = false
    end

    Players = {}
    announce("Game-Ended", "Congratulations! The game has ended. Remaining players at conclusion: " .. Winners .. ".")
    startWaitingPeriod()
end

-- Removes a listener from the listeners' list.
-- @param listener: The listener to be removed.
function removeListener(listener)
    local idx = 0
    for i, v in ipairs(Listeners) do
        if v == listener then
            idx = i
            break
        end
    end
    if idx > 0 then
        table.remove(Listeners, idx)
    end
end

-- HANDLERS: Game state management

-- Handler for cron messages, manages game state transitions.
Handlers.add(
    "Game-State-Timers",
    function(Msg)
        return "continue"
    end,
    function(Msg)
        Now = Msg.Timestamp
        if GameMode == "Not-Started" then
            startWaitingPeriod()
        elseif GameMode == "Waiting" then
            if Now > StateChangeTime then
                startGamePeriod()
            end
        elseif GameMode == "Playing" then
            if onTick and type(onTick) == "function" then
              onTick()
            end
            if Now > StateChangeTime then
                endGame()
            end
        end
    end
)

-- Handler for player deposits to participate in the next game.
Handlers.add(
    "Transfer",
    function(Msg)
        return
            Msg.Action == "Credit-Notice" and
            Msg.From == PaymentToken and
            tonumber(Msg.Quantity) >= tonumber(PaymentQty) and "continue"
    end,
    function(Msg)
        Waiting[Msg.Sender] = true
        ao.send({
            Target = Msg.Sender,
            Action = "Payment-Received"
        })
        announce("Player-Ready", Msg.Sender .. " is ready to play!")
    end
)

-- Registers new players for the next game and subscribes them for event info.
Handlers.add(
    "Register",
   { Action = "Register" },
    function(Msg)
        if Msg.Mode ~= "Listen" and Waiting[Msg.From] == undefined then
            Waiting[Msg.From] = false
        end
        removeListener(Msg.From)
        table.insert(Listeners, Msg.From)
        ao.send({
            Target = Msg.From,
            Action = "Registered"
        })
        announce("New Player Registered", Msg.From .. " has joined in waiting.")
    end
)

-- Unregisters players and stops sending them event info.
Handlers.add(
    "Unregister",
   { Action = "Unregister" },
    function(Msg)
        removeListener(Msg.From)
        ao.send({
            Target = Msg.From,
            Action = "Unregistered"
        })
    end
)

-- Adds bet amount to BonusQty
Handlers.add(
    "AddBet",
    { Reason = "AddBet" },
    function(Msg)
        BonusQty = tonumber(BonusQty) + tonumber(Msg.Tags.Quantity)
        announce("Bet-Added", Msg.From .. "has placed a bet. " .. "BonusQty amount increased by " .. Msg.Tags.Quantity .. "!")
    end
)

-- Retrieves the current game state.
Handlers.add(
    "GetGameState",
   { Action = "GetGameState" },
    function (Msg)
        local json = require("json")
        local TimeRemaining = StateChangeTime - Now
        local GameState = json.encode({
            GameMode = GameMode,
            TimeRemaining = TimeRemaining,
            Players = Players,
            })
        ao.send({
            Target = Msg.From,
            Action = "GameState",
            Data = GameState})
    end
)

-- Alerts users regarding the time remaining in each game state.
Handlers.add(
    "AnnounceTick",
   { Action = "Tick" },
    function (Msg)
        local TimeRemaining = StateChangeTime - Now
        if GameMode == "Waiting" then
            announce("Tick", "The game will start in " .. (TimeRemaining/1000) .. " seconds.")
        elseif GameMode == "Playing" then
            announce("Tick", "The game will end in " .. (TimeRemaining/1000) .. " seconds.")
        end
    end
)

-- Sends tokens to players with no balance upon request
Handlers.add(
    "RequestTokens",
   { Action = "RequestTokens" },
    function (Msg)
        print("Transfering Tokens: " .. tostring(math.floor(10000 * UNIT)))
        ao.send({
            Target = ao.id,
            Action = "Transfer",
            Quantity = tostring(math.floor(10000 * UNIT)),
            Recipient = Msg.From,
        })
    end
)
```

</details>

## アリーナゲームのブループリント

このアリーナフレームワークを使用したい方のために、このコードをブループリントとして簡単に利用できるようにしました。ターミナルで次のコードを実行するだけです：

```lua
.load-blueprint arena
```

## まとめ

アリーナのメカニクスを理解することで、前のセクションで作成した自律エージェントを改善するだけでなく、この基本機能を活用して独自のゲームを構築する能力も身に付けることができます。

次のセクション「ゲームの構築」では、これらのメカニクスを活用して、このフレームワーク内で魅力的でユニークなゲームを構築する方法について詳しく説明します。ゲーム開発のダイナミックな世界に飛び込む準備はできていますか？ 🎮
