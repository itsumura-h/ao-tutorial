# aoトークンとサブレッジャー仕様

**ステータス:** DRAFT-1  
**ターゲットネットワーク:** ao.TN.1

この仕様書は、標準的なaoトークンプロセスに必要なメッセージハンドラーと機能を説明します。この標準に準拠した実装は、通常、ユーザーが転送可能な資産を管理できる機能を提供し、その希少性はプロセスによって維持されます。

準拠したプロセスは、資産の所有権をエンコードするための残高の台帳を実装する可能性があります。準拠したプロセスには、通常、トークンの所有権の希少性を確保するための安全策と共に、この台帳を修正するための一連のメソッドが用意されています。

さらに、この仕様書では、「サブレッジャー」プロセスタイプについても説明しており、これを実装すると、親プロセスからトークンを子プロセスに移動させる機能が提供されます。このサブレッジャープロセスの`From-Module`が参加者によって信頼される場合、これらのサブレッジャーは、元のトークンと直接メッセージを交換することなく、'source'トークンで取引を行うために使用できます。オプションとして、参加者がサブレッジャープロセスが動作している`Module`を信頼している場合、これらのプロセス間での残高を_ファンジブル_（同等性がある）として扱うことができます。これにより、任意の数の並行プロセスおよびそれに伴う取引を、1つのトークンで同時に処理できるようになります。

# トークンプロセス

仕様に準拠したトークンプロセスは、さまざまな形式のメッセージに応答します。それぞれの形式は`Action`タグで指定されています。トークンがサポートする必要がある全ての`Action`メッセージのセットは以下の通りです。

| 名前      | 説明                                                                                   | 読み取り専用        |
|-----------|----------------------------------------------------------------------------------------|---------------------|
| Balance   | 識別子の残高を取得する                                                                | :heavy_check_mark:  |
| Balances  | すべての台帳/アカウントの残高リストを取得する                                          | :heavy_check_mark:  |
| Transfer  | 1つ以上のユニットを送信する、送信元の残高から1つ以上のターゲットに、通知オプション付きで送信 | :x:                 |
| Mint      | レジャープロセスがルートであり、トークン供給を増やしたい場合                           | :x:                 |

このセクションの残りの部分では、準拠したトークンプロセスを生成するために必要なタグと、各`Action`メッセージの形式とその結果について説明します。

## スポーニングパラメータ

すべての準拠したトークンプロセスは、スポーニングメッセージに以下の不可変パラメータを含めなければなりません。

| タグ           | 説明                                                                                                    | オプション        |
|----------------|---------------------------------------------------------------------------------------------------------|------------------|
| Name           | ユーザーに表示されるトークンのタイトル。                                                               | :heavy_check_mark: |
| Ticker         | トークンを迅速に参照できるようにするための短縮名。                                                   | :heavy_check_mark: |
| Logo           | アプリケーションがトークンの隣に表示することを望む画像、迅速に視覚的に識別できるようにするためのもの。   | :heavy_check_mark: |
| Denomination    | ユーザーに表示される数量と残高が1単位と見なされるトークンの数。                                       | :x:              |

## メッセージプロトコル

### Balance(Target? : string)

ターゲットの残高を返します。ターゲットが指定されていない場合、メッセージの送信者の残高を返す必要があります。

例の`Action`メッセージ：

```lua
send({
    Target = "{トークンプロセス識別子}",
    Tags = {
        Action = "Balance",
        Target = "{IDENTIFIER}"
    }
})
```

例のレスポンスメッセージ：

```
{
    Tags = {
        Balance = "50",
        Target = "LcldyO8wwiGDzC3iXzGofdO8JdR4S1_2A6Qtz-o33-0",
        Ticker = "FUN"
    }
}
```

### Balances()

トークンのすべての参加者の残高を返します。

```lua
send({
    Target = "[トークンプロセス識別子]",
    Tags = {
        Action = "Balances",
        Limit = 1000, # TODO: ユーザーがコンピュートとレスポンスに対して支払っている場合、これは必要ですか？
        Cursor? = "BalanceIdentifer"
    }
})
```

例のレスポンスメッセージ：

```lua
{
    Data = {
        "MV8B3MAKTsUOqyCzQ0Tsa2AR3TiWTBU1Dx0xM4MO-f4": 100,
        "LcldyO8wwiGDzC3iXzGofdO8JdR4S1_2A6Qtz-o33-0": 50
    }
}
```

### Transfer(Target, Quantity)

送信者に十分な残高がある場合、`Quantity`を`Target`に送信し、受信者に`Credit-Notice`を発行し、送信者に`Debit-Notice`を発行します。`Credit-`および`Debit-Notice`は、元の`Transfer`メッセージからすべてのタグを`X-`プレフィックスで転送する必要があります。送信者に十分な残高がない場合は、失敗し、送信者に通知します。

```lua
send({
    Target = "[トークンプロセス識別子]",
    Tags = {
        { name = "Action", value = "Transfer" },
        { name = "Recipient", value = "[ADDRESS]" },
        { name = "Quantity", value = "100" },
        { name = "X-[転送されたタグ名]", value= "[VALUE]" }
    }
})
```

成功したトランスファーが発生した場合、`Cast`が設定されていない場合は通知メッセージを送信する必要があります。

```lua
ao.send({
    Target = "[受信者アドレス]",
    Tags = {
        { name = "Action", value = "Credit-Notice" },
        { name = "Sender", value = "[ADDRESS]" },
        { name = "Quantity", value = "100"},
        { name = "X-[転送されたタグ名]", value= "[VALUE]" }
    }
})
```

受信者は、メッセージの`From-Process`タグから受け取ったトークンを推測します。

### Get-Info()

```lua
send({
    Target = "{トークン}",
    Tags = {
        Action = "Info"
    }
})
```

### Mint() [オプション]

`Mint`アクションを実装すると、プロセスが有効な参加者に新しいトークンを作成させる方法が提供されます。

```lua
send({
    Target ="{トークンプロセス}",
    Tags = {
        Action = "Mint",
        Quantity = "1000"
    }
})
```

# サブレッジャープロセス

サブレッジャーが適切に機能するためには、サブレッジャーはトークン契約の完全なメッセージプロトコルを実装する必要があります（`Mint`アクションを除く）。サブレッジャーは、プロセスに対して追加の機能とスポーニングパラメータを実装する必要があります。これらの変更は以下のセクションで説明されています。

### スポーニングパラメータ

すべての準拠したサブレッジャープロセスは、スポーニングメッセージに以下の不可変パラメータを含めなければなりません。

| タグ           | 説明                                                                                          | オプション |
|----------------|-----------------------------------------------------------------------------------------------|----------|
| Source-Token   | このサブレッジャーが表す最上位プロセスの`ID`。                                                | :x

:      |
| Parent-Token   | このサブレッジャーが接続されている親プロセスの`ID`。                                        | :x:      |

### `Credit-Notice`ハンドラー

`Credit-Notice`メッセージを受信したとき、準拠したサブレッジャープロセスは、問題のプロセスが`Parent-Token`であるかどうかを確認しなければなりません。もしそうであれば、サブレッジャーは`Sender`の残高を指定された数量分増加させます。

### Transfer(Target, Quantity)

受信者にトークンを転送する際、通常のタグに加えて、`Source-Token`および`Parent-Token`の値も提供する必要があります。これにより、トランスファーメッセージの受信者は、サブレッジャープロセスの`Module`を信頼している場合、`Source-Token`からの預金と同等の受領をクレジットすることができます。

修正された`Credit-Notice`は以下のように構成されるべきです。

```lua
ao.send({
    Target = "[受信者アドレス]",
    Tags = {
        { name = "Action", value = "Credit-Notice" },
        { name = "Quantity", value = "100"},
        { name = "Source-Token", value = "[ADDRESS]" },
        { name = "Parent-Token", value = "[ADDRESS]" },
        { name = "X-[転送されたタグ名]", value= "[VALUE]" }
    }
})
```

### Withdraw(Target?, Quantity)

すべてのサブレッジャーは、残高保持者がトークンを親台帳に引き出すことを許可しなければなりません。`Action: Withdraw`メッセージを受信した際、サブレッジャーは呼び出し元のアドレスに要求されたトークンを転送するために`Parent-Ledger`にメッセージを送信し、ローカルでそのアカウントをデビットします。この転送により、呼び出し元に対して`Parent-Ledger`からの`Credit-Notice`が発生します。

```lua
send({
    Target = "[トークンプロセス識別子]",
    Tags = {
     { name = "Action", value = "Withdraw" },
     { name = "Recipient", value = "[ADDRESS]" },
     { name = "Quantity", value = "100" }
    }
})
```

# トークン例

> 注: トークンを実装する際は、すべてのメッセージのタグが「文字列」でなければならないことを忘れないでください。`tostring`関数を使用して、単純な型を文字列に変換できます。

```lua
if not balances then
  balances = { [ao.id] = 100000000000000 }
end

if name ~= "Fun Coin" then
  name = "Fun Coin"
end

if ticker ~= "Fun" then
  ticker = "fun"
end

if denomination ~= 6 then
  denomination = 6
end

-- 受信メッセージを処理するハンドラー
handlers.add(
  "transfer",
  handlers.utils.hasMatchingTag("Action", "Transfer"),
  function (msg)
    assert(type(msg.Tags.Recipient) == 'string', 'Recipient is required!')
    assert(type(msg.Tags.Quantity) == 'string', 'Quantity is required!')

    if not balances[msg.From] then
      balances[msg.From] = 0
    end

    if not balances[msg.Tags.Recipient] then
      balances[msg.Tags.Recipient] = 0
    end

    local qty = tonumber(msg.Tags.Quantity)
    assert(type(qty) == 'number', 'qty must be number')
    -- handlers.utils.reply("Transfering qty")(msg)
    if balances[msg.From] >= qty then
      balances[msg.From] = balances[msg.From] - qty
      balances[msg.Tags.Recipient] = balances[msg.Tags.Recipient] + qty
      ao.send({
        Target = msg.From,
        Tags = {
          Action = "Debit-Notice",
          Quantity = tostring(qty)
        }
      })
      ao.send({
      Target = msg.Tags.Recipient,
      Tags = {
        Action = "Credit-Notice",
        Quantity = tostring(qty)
      }})
      -- if msg.Tags.Cast and msg.Tags.Cast == "true" then
      --   return
      -- end

    end
  end
)

handlers.add(
  "balance",
  handlers.utils.hasMatchingTag("Action", "Balance"),
  function (msg)
    assert(type(msg.Tags.Target) == "string", "Target Tag is required!")
    local bal = "0"
    if balances[msg.Tags.Target] then
      bal = tostring(balances[msg.Tags.Target])
    end
    ao.send({Target = msg.From, Tags = {
      Target = msg.From,
      Balance = bal,
      Ticker = ticker or ""
    }})
  end
)

local json = require("json")

handlers.add(
  "balances",
  handlers.utils.hasMatchingTag("Action", "Balances"),
  function (msg)
    ao.send({
      Target = msg.From,
      Data = json.encode(balances)
    })
  end
)

handlers.add(
  "info",
  handlers.utils.hasMatchingTag("Action", "Info"),
  function (msg)
    ao.send({Target = msg.From, Tags = {
      Name = name,
      Ticker = ticker,
      Denomination = tostring(denomination)
    }})
  end
)
```
