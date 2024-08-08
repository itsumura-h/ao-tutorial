# アリーナの拡張

Chapter 2 の最後のガイドへようこそ。ここでは、前のチュートリアルで紹介したアリーナフレームワークの上に独自のゲームを構築する方法を学びます。このガイドでは、Chapter の最初に体験した["ao-effect"ゲーム](ao-effect)を作成するプロセスを案内します。この例を進めることで、ゲームのロジックを構築し、アリーナのコアコードと連携する方法についての洞察を得ることができます。

経験豊富な開発者からゲームクリエーターを目指す方まで、このガイドは`aos`環境内で独自のゲームアイデアを実現するための力を与えます。

## 開発環境のセットアップ

最初に、好みのディレクトリに`ao-effect.lua`という新しいファイルを作成します。

> [!注意]
> このファイルは、コードの読み込みを容易にするために、ゲームプロセスが実行されるのと同じディレクトリに配置するのが理想的です。そうでない場合は、相対パスを使用してファイルにアクセスする必要があります。

## コードの作成

さあ、ロジックに取り掛かりましょう。

ゲームロジックでは、アリーナのロジックで定義された関数や変数を呼び出すことになります。これにより、既存のアリーナロジックの上にゲームを構築し、両者の間で変数や関数をシームレスに統合する力が示されます。これにより、両方のロジックがゲームプロセスの統一されたロジックの一部となります。

### ゲームメカニクスの初期化

まず、ゲームのメカニクスを設定するために必要な変数と関数を定義します：

```lua
-- AO EFFECT: AOアリーナゲームのメカニクス

-- ゲームグリッドの寸法
Width = 40 -- グリッドの幅
Height = 40 -- グリッドの高さ
Range = 1 -- 爆発効果の距離

-- プレイヤーエネルギーの設定
MaxEnergy = 100 -- プレイヤーが持つことができる最大エネルギー
EnergyPerSec = 1 -- 秒ごとに獲得するエネルギー

-- 攻撃設定
AverageMaxStrengthHitsToKill = 3 -- プレイヤーを排除するための平均最大ヒット数

-- デフォルトのプレイヤー状態を初期化
-- @return プレイヤーの初期状態を表すテーブル
function playerInitState()
    return {
        x = math.random(Width/8),
        y = math.random(Height/8),
        health = 100,
        energy = 0
    }
end

-- プレイヤーのエネルギーを段階的に増加させる関数
-- 定期的に呼び出されてプレイヤーのエネルギーを更新する
function onTick()
    if GameMode ~= "Playing" then return end  -- "Playing"状態でのみアクティブ

    if LastTick == undefined then LastTick = Now end

    local Elapsed = Now - LastTick
    if Elapsed >= 1000 then  -- 毎秒実行されるアクション
        for player, state in pairs(Players) do
            local newEnergy = math.floor(math.min(MaxEnergy, state.energy + (Elapsed * EnergyPerSec // 2000)))
            state.energy = newEnergy
        end
        LastTick = Now
    end
end
```

このコードは、ゲームのメカニクス（グリッドの寸法、プレイヤーのエネルギー、攻撃設定など）を初期化します。`playerInitState`関数は、ゲーム開始時のプレイヤーの初期状態を設定します。

### プレイヤーの移動

次に、プレイヤーの移動に関するコードを追加します：

```lua
-- プレイヤーの移動を処理する
-- @param msg: 移動方向とプレイヤー情報を含むプレイヤーからのリクエストメッセージ
function move(msg)
    local playerToMove = msg.From
    local direction = msg.Tags.Direction

    local directionMap = {
        Up = {x = 0, y = -1}, Down = {x = 0, y = 1},
        Left = {x = -1, y = 0}, Right = {x = 1, y = 0},
        UpRight = {x = 1, y = -1}, UpLeft = {x = -1, y = -1},
        DownRight = {x = 1, y = 1}, DownLeft = {x = -1, y = 1}
    }

    -- 新しい座標を計算して更新
    if directionMap[direction] then
        local newX = Players[playerToMove].x + directionMap[direction].x
        local newY = Players[playerToMove].y + directionMap[direction].y

        -- グリッドの境界を確認しながらプレイヤーの座標を更新
        Players[playerToMove].x = (newX - 1) % Width + 1
        Players[playerToMove].y = (newY - 1) % Height + 1

        announce("Player-Moved", playerToMove .. " moved to " .. Players[playerToMove].x .. "," .. Players[playerToMove].y .. ".")
    else
        ao.send({Target = playerToMove, Action = "Move-Failed", Reason = "Invalid direction."})
    end
    onTick()  -- オプション: 各移動でエネルギーを更新
end
```

`move`関数は、選択された方向に基づいて新しいプレイヤーの座標を計算し、プレイヤーがグリッドの境界内に留まることを確認します。プレイヤーの移動はゲームに動的なインタラクションを追加し、すべてのプレイヤーおよびリスナーにアナウンスされます。

### プレイヤーの攻撃

次に、プレイヤーの攻撃に関するロジックを実装します：

```lua
-- プレイヤーの攻撃を処理する
-- @param msg: 攻撃情報とプレイヤー状態を含むプレイヤーからのリクエストメッセージ
function attack(msg)
    local player = msg.From
    local attackEnergy = tonumber(msg.Tags.AttackEnergy)

    -- プレイヤーの座標を取得
    local x = Players[player].x
    local y = Players[player].y

    -- プレイヤーに攻撃に十分なエネルギーがあるか確認
    if Players[player].energy < attackEnergy then
        ao.send({Target = player, Action = "Attack-Failed", Reason = "Not enough energy."})
        return
    end

    -- プレイヤーのエネルギーを更新し、ダメージを計算
    Players[player].energy = Players[player].energy - attackEnergy
    local damage = math.floor((math.random() * 2 * attackEnergy) * (1/AverageMaxStrengthHitsToKill))

    announce("Attack", player .. " has launched a " .. damage .. " damage attack from " .. x .. "," .. y .. "!")

    -- 範囲内にいるプレイヤーがいるか確認し、状態を更新
    for target, state in pairs(Players) do
        if target ~= player and inRange(x, y, state.x, state.y, Range) then
            local newHealth = state.health - damage
            if newHealth <= 0 then
                eliminatePlayer(target, player)
            else
                Players[target].health = newHealth
                ao.send({Target = target, Action = "Hit", Damage = tostring(damage), Health = tostring(newHealth)})
                ao.send({Target = player, Action = "Successful-Hit", Recipient = target, Damage = tostring(damage), Health = tostring(newHealth)})
            end
        end
    end
end

-- ターゲットが範囲内にいるか確認するヘルパー関数
-- @param x1, y1: 攻撃者の座標
-- @param x2, y2: 潜在的なターゲットの座標
-- @param range: 攻撃範囲
-- @return ターゲットが範囲内にいるかを示すブール値
function inRange(x1, y1, x2, y2, range)
    return x2 >= (x1 - range) and x2 <= (x1 + range) and y2 >= (y1 - range) and y2 <= (y1 + range)
end
```

`attack`関数は、攻撃エネルギーに基づいてダ

メージを計算し、プレイヤーのエネルギーをチェックし、プレイヤーの健康状態を更新します。プレイヤーの攻撃はゲームに競争要素を加え、プレイヤー間のインタラクションを促進します。攻撃はプレイヤーおよびリスナーにリアルタイムでアナウンスされます。

### ロジックの処理

最後に、ハンドラを設定します：

```lua
-- HANDLERS: AO-Effectのゲーム状態管理

-- プレイヤーの移動を処理するハンドラ
Handlers.add("PlayerMove", { Action = "PlayerMove" }, move)

-- プレイヤーの攻撃を処理するハンドラ
Handlers.add("PlayerAttack", { Action = "PlayerAttack" }, attack)
```

前のガイドで見たように、ハンドラはそれぞれのパターンが一致したときに関数をトリガーします。

最終的な`ao-effect.lua`ファイルのコードを以下のドロップダウンで参照できます：

<details>
  <summary><strong>最終的なao-effect.luaファイル</strong></summary>

```lua
-- AO EFFECT: AOアリーナゲームのメカニクス

-- ゲームグリッドの寸法
Width = 40 -- グリッドの幅
Height = 40 -- グリッドの高さ
Range = 1 -- 爆発効果の距離

-- プレイヤーエネルギーの設定
MaxEnergy = 100 -- プレイヤーが持つことができる最大エネルギー
EnergyPerSec = 1 -- 秒ごとに獲得するエネルギー

-- 攻撃設定
AverageMaxStrengthHitsToKill = 3 -- プレイヤーを排除するための平均最大ヒット数

-- デフォルトのプレイヤー状態を初期化
-- @return プレイヤーの初期状態を表すテーブル
function playerInitState()
    return {
        x = math.random(0, Width),
        y = math.random(0, Height),
        health = 100,
        energy = 0
    }
end

-- プレイヤーのエネルギーを段階的に増加させる関数
-- 定期的に呼び出されてプレイヤーのエネルギーを更新する
function onTick()
    if GameMode ~= "Playing" then return end  -- "Playing"状態でのみアクティブ

    if LastTick == undefined then LastTick = Now end

    local Elapsed = Now - LastTick
    if Elapsed >= 1000 then  -- 毎秒実行されるアクション
        for player, state in pairs(Players) do
            local newEnergy = math.floor(math.min(MaxEnergy, state.energy + (Elapsed * EnergyPerSec // 2000)))
            state.energy = newEnergy
        end
        LastTick = Now
    end
end

-- プレイヤーの移動を処理する
-- @param msg: 移動方向とプレイヤー情報を含むプレイヤーからのリクエストメッセージ
function move(msg)
    local playerToMove = msg.From
    local direction = msg.Tags.Direction

    local directionMap = {
        Up = {x = 0, y = -1}, Down = {x = 0, y = 1},
        Left = {x = -1, y = 0}, Right = {x = 1, y = 0},
        UpRight = {x = 1, y = -1}, UpLeft = {x = -1, y = -1},
        DownRight = {x = 1, y = 1}, DownLeft = {x = -1, y = 1}
    }

    -- 新しい座標を計算して更新
    if directionMap[direction] then
        local newX = Players[playerToMove].x + directionMap[direction].x
        local newY = Players[playerToMove].y + directionMap[direction].y

        -- グリッドの境界を確認しながらプレイヤーの座標を更新
        Players[playerToMove].x = (newX - 1) % Width + 1
        Players[playerToMove].y = (newY - 1) % Height + 1

        announce("Player-Moved", playerToMove .. " moved to " .. Players[playerToMove].x .. "," .. Players[playerToMove].y .. ".")
    else
        ao.send({Target = playerToMove, Action = "Move-Failed", Reason = "Invalid direction."})
    end
    onTick()  -- オプション: 各移動でエネルギーを更新
end

-- プレイヤーの攻撃を処理する
-- @param msg: 攻撃情報とプレイヤー状態を含むプレイヤーからのリクエストメッセージ
function attack(msg)
    local player = msg.From
    local attackEnergy = tonumber(msg.Tags.AttackEnergy)

    -- プレイヤーの座標を取得
    local x = Players[player].x
    local y = Players[player].y

    -- プレイヤーに攻撃に十分なエネルギーがあるか確認
    if Players[player].energy < attackEnergy then
        ao.send({Target = player, Action = "Attack-Failed", Reason = "Not enough energy."})
        return
    end

    -- プレイヤーのエネルギーを更新し、ダメージを計算
    Players[player].energy = Players[player].energy - attackEnergy
    local damage = math.floor((math.random() * 2 * attackEnergy) * (1/AverageMaxStrengthHitsToKill))

    announce("Attack", player .. " has launched a " .. damage .. " damage attack from " .. x .. "," .. y .. "!")

    -- 範囲内にいるプレイヤーがいるか確認し、状態を更新
    for target, state in pairs(Players) do
        if target ~= player and inRange(x, y, state.x, state.y, Range) then
            local newHealth = state.health - damage
            if newHealth <= 0 then
                eliminatePlayer(target, player)
            else
                Players[target].health = newHealth
                ao.send({Target = target, Action = "Hit", Damage = tostring(damage), Health = tostring(newHealth)})
                ao.send({Target = player, Action = "Successful-Hit", Recipient = target, Damage = tostring(damage), Health = tostring(newHealth)})
            end
        end
    end
end

-- ターゲットが範囲内にいるか確認するヘルパー関数
-- @param x1, y1: 攻撃者の座標
-- @param x2, y2: 潜在的なターゲットの座標
-- @param range: 攻撃範囲
-- @return ターゲットが範囲内にいるかを示すブール値
function inRange(x1, y1, x2, y2, range)
    return x2 >= (x1 - range) and x2 <= (x1 + range) and y2 >= (y1 - range) and y2 <= (y1 + range)
end

-- HANDLERS: AO-Effectのゲーム状態管理

-- プレイヤーの移動を処理するハンドラ
Handlers.add("PlayerMove", { Action = "PlayerMove" }, move)

-- プレイヤーの攻撃を処理するハンドラ
Handlers.add("PlayerAttack", { Action = "PlayerAttack" }, attack)
```

</details>

## ロードとテスト

ゲームコードを書き終えたら、`aos`ゲームプロセスにロードしてテストします：

```lua
.load ao-effect.lua
```

> [!重要]
> 同じプロセスでアリーナブループリントもロードすることを確認してください。

友達を招待したり、テストプレイヤープロセスを作成して、ゲームを体験し、最適なパフォーマンスのために必要な調整を行ってください。

## 次のステップ

おめでとうございます！アリーナの上に独自のゲームを構築することに成功しました。このガイドで得た知識とツールを駆使して、独自のゲームを自由に構築する能力を手に入れました。

可能性は無限大です。既存のゲームにさらに機能を追加したり、まったく新しいゲームを作成したりしてください。あなたの想像力を最大限に発揮してください！ ⌃◦🚀
