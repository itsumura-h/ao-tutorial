# `ao`でトークンを作成する

トークンを作成する際には、[Token Specification](../../references/token.md)に従って、`ao`内で[Lua Language](../../references/lua.md)を使用してトークンを発行します。

### トークンを作成する2つの方法：

**1 - トークンのブループリントを使用する：**

`.load-blueprint token`

トークンのブループリントを使用すると、すべてのハンドラーと状態が既に定義されたトークンが作成されます。これはトークンを作成する最も簡単な方法です。ブループリントをロードした後でこれらのハンドラーと状態をカスタマイズすることができます。

利用可能なブループリントの詳細はこちらをご覧ください：[Blueprints](../aos/blueprints/index.md)

::: info
トークンのブループリントを使用すると迅速に作業を進めることができますが、カスタマイズのために[ロードとテスト](token.html#loading-and-testing)を理解する必要があります。
:::

**2 - スクラッチから構築する：**

以下のガイドは、スクラッチからトークンを作成するプロセスをガイドします。これはトークンを作成するためのより高度な方法ですが、トークンの動作をよりよく理解することができます。

## 準備

### **ステップ1：トークンの初期化**

- お気に入りのテキストエディタを開き、前のチュートリアルで使用したのと同じフォルダから開きます。
- `token.lua`という新しいファイルを作成します。
- `token.lua`内で、トークンの状態を初期化し、残高、名前、ティッカーなどを定義します：

```lua
local json = require('json')

if not Balances then Balances = { [ao.id] = 100000000000000 } end

if Name ~= 'My Coin' then Name = 'My Coin' end

if Ticker ~= 'COIN' then Ticker = 'COIN' end

if Denomination ~= 10 then Denomination = 10 end

if not Logo then Logo = 'optional arweave TXID of logo image' end
```

![token.lua image 1](/token1.png)

ここで行ったことを分解します：

- `local json = require('json')`：このコードの最初の行は、後で使用するためにモジュールをインポートします。

- `if not Balances then Balances = { [ao.id] = 100000000000000 } end`：この2行目は、プロセスがトークンの全残高を保持するようにBalancesテーブルを初期化します。

- 次の4行は、それぞれトークンの名前、ティッカー、単位、ロゴを定義するためのもので、`if Denomination`は必須ですが、他はオプションです。

::: info
コード `if Denomination ~= 10 then Denomination = 10 end` は、トークンの単位を定義します。
:::

### **ステップ2：情報と残高のハンドラー**

<br>

#### 受信メッセージハンドラー

まず、受信メッセージを処理するためのハンドラーを追加します。

```lua
Handlers.add('info', Handlers.utils.hasMatchingTag('Action', 'Info'), function(msg)
  ao.send(
      { Target = msg.From, Tags = { Name = Name, Ticker = Ticker, Logo = Logo, Denomination = tostring(Denomination) } })
end)
```

![Token.lua image 2](/token2.png)

::: info
この時点で、すべてのハンドラーを`.editor`ではなく`token.lua`ファイル内に構築していることに気づいたかもしれません。

多くのハンドラーとプロセスがある場合、`.editor`を使用してハンドラーを作成するのは問題ありませんが、トークンの初期化、情報と残高のハンドラーの設定、転送ハンドラー、および鋳造ハンドラーを作成するためにフルプロセスを作成しているため、すべてを1つのファイルにまとめる方が最適です。

これにより、`token.lua`ファイルを`aos`にリロードするたびに各ハンドラーが更新されるため、一貫性を保つことができます。
:::

このコードは、誰かがActionタグが"info"のメッセージを送信すると、トークンが定義されたすべての情報を返信メッセージで送信することを意味します。`Target = msg.From`に注意してください。これはaoにメッセージを送信したプロセスに返信していることを示します。

#### 情報とトークン残高ハンドラー

次に、トークン残高に関する情報を提供する2つのハンドラーを追加します。

```lua
Handlers.add('balance', Handlers.utils.hasMatchingTag('Action', 'Balance'), function(msg)
  local bal = '0'

  -- ターゲットが提供されていない場合、送信者の残高を返します
  if (msg.Tags.Target and Balances[msg.Tags.Target]) then
    bal = tostring(Balances[msg.Tags.Target])
  elseif Balances[msg.From]) then
    bal = tostring(Balances[msg.From])
  end

  ao.send({
    Target = msg.From,
    Tags = { Target = msg.From, Balance = bal, Ticker = Ticker, Data = json.encode(tonumber(bal)) }
  })
end)

Handlers.add('balances', Handlers.utils.hasMatchingTag('Action', 'Balances'),
             function(msg) ao.send({ Target = msg.From, Data = json.encode(Balances) }) end)

```

上記の最初のハンドラー`Handlers.add('balance'`は、プロセスまたはユーザーが自分の残高またはターゲットの残高を要求した場合に処理し、情報を含むメッセージで返信します。2つ目のハンドラー`Handlers.add('balances'`は、Balancesテーブル全体を返信します。

### **ステップ3：転送ハンドラー**

テストを開始する前に、プロセスまたはユーザー間でトークンを転送するための2つのハンドラーを追加します。

```lua
Handlers.add('transfer', Handlers.utils.hasMatchingTag('Action', 'Transfer'), function(msg)
  assert(type(msg.Tags.Recipient) == 'string', 'Recipient is required!')
  assert(type(msg.Tags.Quantity) == 'string', 'Quantity is required!')

  if not Balances[msg.From] then Balances[msg.From] = 0 end

  if not Balances[msg.Tags.Recipient] then Balances[msg.Tags.Recipient] = 0 end

  local qty = tonumber(msg.Tags.Quantity)
  assert(type(qty) == 'number', 'qty must be number')

  if Balances[msg.From] >= qty then
    Balances[msg.From] = Balances[msg.From] - qty
    Balances[msg.Tags.Recipient] = Balances[msg.Tags.Recipient] + qty

    --[[
      CastタグがTransferメッセージに設定されていない場合、送信者と受信者のみに通知を送信します。
    ]] --
    if not msg.Tags.Cast then
      -- 送信者に送信されるDebit-Noticeメッセージテンプレート
      local debitNotice = {
        Target = msg.From,
        Action = 'Debit-Notice',
        Recipient = msg.Recipient,
        Quantity = tostring(qty),
        Data = Colors.gray ..
            "You transferred " ..
            Colors.blue .. msg.Quantity .. Colors.gray .. " to " .. Colors.green .. msg.Recipient .. Colors.reset
      }
      -- 受信者に送信されるCredit-Noticeメッセージテンプレート
      local creditNotice = {
        Target = msg.Recipient,
        Action = 'Credit-Notice',
        Sender = msg.From,
        Quantity = tostring(qty),
        Data = Colors.gray ..
            "You received " ..
            Colors.blue .. msg.Quantity .. Colors.gray .. " from " .. Colors.green .. msg.From .. Colors.reset
      }

      -- Credit-NoticeとDebit-Noticeメッセージに転送されたタグを追加
      for tagName, tagValue in pairs(msg) do
        -- "X-"で始まるタグは転送されます
        if string.sub(tagName, 1, 2) == "X-" then
          debitNotice[tagName] = tagValue
          creditNotice[tagName] = tagValue
        end
      end

      -- Debit-NoticeとCredit-Noticeを送信
      ao.send(debitNotice)
      ao.send(creditNotice)
    end
  else
    ao.send({
      Target = msg.Tags.From,
      Tags = { Action = 'Transfer-Error', ['Message

-Id'] = msg.Id, Error = 'Insufficient Balance!' }
    })
  end
end)
```

要約すると、このコードは、RecipientとQuantityのタグが提供されていることを確認し、送信者と受信者の残高が存在しない場合に初期化し、指定された数量を受信者に転送しようとします。

```lua
Balances[msg.From] = Balances[msg.From] - qty
Balances[msg.Tags.Recipient] = Balances[msg.Tags.Recipient] + qty
```

転送が成功した場合、送信者にはDebit-Noticeが送信され、受信者にはCredit-Noticeが送信されます。

```lua
-- 送信者にDebit-Noticeを送信
ao.send({
    Target = msg.From,
    Tags = { Action = 'Debit-Notice', Recipient = msg.Tags.Recipient, Quantity = tostring(qty) }
})
-- 受信者にCredit-Noticeを送信
ao.send({
    Target = msg.Tags.Recipient,
    Tags = { Action = 'Credit-Notice', Sender = msg.From, Quantity = tostring(qty) }
})
```

残高が不足している場合、失敗メッセージが送信されます。

```lua
ao.send({
    Target = msg.Tags.From,
    Tags = { Action = 'Transfer-Error', ['Message-Id'] = msg.Id, Error = 'Insufficient Balance!' }
})
```

`if not msg.Tags.Cast then`の行は、Castタグが設定されていない場合にメッセージをプッシュしないことを意味します。これはaoプロトコルの一部です。

### **ステップ4：鋳造ハンドラー**

最後に、新しいトークンを鋳造するためのハンドラーを追加します。

```lua
Handlers.add('mint', Handlers.utils.hasMatchingTag('Action', 'Mint'), function(msg, env)
  assert(type(msg.Tags.Quantity) == 'string', 'Quantity is required!')

  if msg.From == env.Process.Id then
    -- 指定された数量に従ってトークンプールにトークンを追加
    local qty = tonumber(msg.Tags.Quantity)
    Balances[env.Process.Id] = Balances[env.Process.Id] + qty
  else
    ao.send({
      Target = msg.Tags.From,
      Tags = {
        Action = 'Mint-Error',
        ['Message-Id'] = msg.Id,
        Error = 'Only the Process Owner can mint new ' .. Ticker .. ' tokens!'
      }
    })
  end
end)
```

このコードは、Quantityタグが提供されていることを確認し、指定された数量をBalancesテーブルに追加します。

## ロードとテスト

`token.lua`ファイルを作成した場合、または`.load-blueprint token`を使用した場合、次にテストを開始する準備が整いました。

#### 1 - aosプロセスを開始する

ターミナルで`aos`を実行してaosプロセスを開始します。

#### 2 - token.luaファイルをロードする

ガイドに従って`token.lua`ファイルが同じディレクトリにある場合、aosプロンプトからファイルをロードします。

```lua
.load token.lua
```

#### 3 - トークンのテスト

今度はメッセージをaosプロセスIDに送信して、動作を確認します。同じaosプロンプトからao.idをターゲットとして使用して自分自身にメッセージを送信します。

```lua
Send({ Target = ao.id, Action = "Info" })
```

これにより、契約で定義された情報が出力されます。返信を確認するために最新の受信ボックスメッセージを確認します。

```lua
Inbox[#Inbox].Tags
```

これにより、契約で定義された情報が表示されます。

::: info
最新メッセージを数値で確認することを確認してください。まず`#Inbox`を実行して、受信ボックスにあるメッセージの総数を確認します。次に、最後のメッセージ番号を実行してデータを確認します。

**例：**

`#Inbox`が`5`を返す場合、`Inbox[5].Data`を実行してデータを確認します。
:::

#### 4 - 転送

今度は、他のウォレットまたはプロセスIDにトークンの残高を転送してみます。

::: info
他のプロセスIDが必要な場合は、別のターミナルウィンドウで`aos [name]`を実行して新しいプロセスIDを取得できます。現在使用しているものとは異なる`aos [name]`を使用してください。

**例：**

1つのターミナルウィンドウで`aos`を使用している場合、別のターミナルウィンドウで`aos test`を実行して新しいプロセスIDを取得できます。
:::

```lua
Send({ Target = ao.id, Tags = { Action = "Transfer", Recipient = '他のウォレットまたはプロセスID', Quantity = '10000' }})
```

送信後、送信者側には`Debit-Notice`、受信者側には`Credit-Notice`に類似したメッセージがターミナルに表示されます。

#### 5 - 残高の確認

今度は、トークンの残高を確認します。

```lua
Send({ Target = ao.id, Tags = { Action = "Balances" }})
```

```lua
Inbox[#Inbox].Data
```

これにより、送信プロセスIDと受信プロセスIDが表示されます。

#### 6 - トークンの鋳造

最後に、トークンを鋳造してみます。

```lua
Send({ Target = ao.id, Tags = { Action = "Mint", Quantity = '1000' }})
```

再度残高を確認します。

```lua
Send({ Target = ao.id, Tags = { Action = "Balances" }})
Inbox[#Inbox].Data
```

これにより、トークンを鋳造したプロセスIDの残高が増加したことが確認できます。

## 結論

以上で「Build a Token」ガイドは終了です。カスタムトークンの作成方法を学ぶことで、プロジェクトに大きな可能性を引き出すことができます。新しい通貨、ゲームのトークン、ガバナンストークン、その他想像できるあらゆるものを作成することができます。
