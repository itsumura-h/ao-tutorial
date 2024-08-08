# 投票ブループリント

投票ブループリントは、`ao`で投票システムを迅速に構築するための設計済みテンプレートです。これにより、簡単に始めることができ、ニーズに合わせてカスタマイズすることができます。

## 前提条件

投票ブループリントを使用するには、最初に[トークンブループリント](./token.md)をロードする必要があります。

## 投票ブループリントの内容

- **バランス**: `Balances`配列は、参加者のトークンバランスを保存するために使用されます。
- **投票**: `Votes`配列は、参加者の投票を保存するために使用されます。
- **投票アクションハンドラー**: `vote`ハンドラーは、プロセスが投票できるようにします。プロセスが`Action = "Vote"`というタグ付きのメッセージを送信すると、ハンドラーは`Votes`配列に投票を追加し、投票を確認するメッセージをプロセスに返します。
- **ファイナライゼーションハンドラー**: `finalize`ハンドラーは、プロセスが投票プロセスを最終化できるようにします。プロセスが`Action = "Finalize"`というタグ付きのメッセージを送信すると、ハンドラーは投票を処理し、投票プロセスを最終化します。

### 使用方法:

1. お好みのテキストエディタを開きます。
2. ターミナルを開きます。
3. `aos`プロセスを開始します。
4. 次のコマンドを入力します: `.load-blueprint voting`

### ブループリントがロードされたか確認する:

`Handlers.list`と入力して、新しくロードされたハンドラーを確認します。

## 投票ブループリントの内容:

```lua
Balances = Balances or {}
Votes = Votes or {}

-- 投票アクションハンドラー
Handlers.vote = function(msg)
  local quantity = Stakers[msg.From].amount
  local target = msg.Tags.Target
  local side = msg.Tags.Side
  local deadline = tonumber(msg['Block-Height']) + tonumber(msg.Tags.Deadline)
  assert(quantity > 0, "No staked tokens to vote")
  Votes[target] = Votes[target] or { yay = 0, nay = 0, deadline = deadline }
  Votes[target][side] = Votes[target][side] + quantity
end

-- ファイナライゼーションハンドラー
local finalizationHandler = function(msg)
  local currentHeight = tonumber(msg['Block-Height'])
  -- 投票を処理する
  for target, voteInfo in pairs(Votes) do
      if currentHeight >= voteInfo.deadline then
          if voteInfo.yay > voteInfo.nay then
              print("Handle Vote")
          end
          -- 処理後に投票記録をクリアする
          Votes[target] = nil
      end
  end
end

-- ハンドラーフローを続行するためのラップ関数
local function continue(fn)
  return function (msg)
    local result = fn(msg)
    if (result) == -1 then
      return 1
    end
    return result
  end
end

Handlers.add("vote",
  continue(Handlers.utils.hasMatchingTag("Action", "Vote")), Handlers.vote)
-- すべてのメッセージに対してファイナライゼーションハンドラーを呼び出す
Handlers.add("finalize", function (msg) return -1 end, finalizationHandler)
```

このブループリントを利用することで、簡単に投票システムを構築できます。ニーズに応じてカスタマイズして、独自の投票システムを作成してください。
