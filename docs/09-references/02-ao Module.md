# ao モジュール

バージョン: 0.0.3

`ao`プロセスの通信はメッセージによって処理されます。各プロセスはANS-104 DataItems形式のメッセージを受信し、次の一般的な操作を行う必要があります。

- isTrusted(msg) - このメッセージが信頼されているか確認する
- send(msg) - 別のプロセスにメッセージを送信する
- spawn(module, msg) - プロセスを生成する

このライブラリの目的は、`ao`開発者ツールキットの中でこのコア機能を提供することです。開発者はこのライブラリを利用するかどうかを選択できますが、デフォルトで統合されています。

## プロパティ

| 名前        | 説明                                       | タイプ   |
| ----------- | ------------------------------------------ | -------- |
| id          | プロセス識別子（TXID）                     | string   |
| \_module    | モジュール識別子（TXID）                   | string   |
| authorities | 信頼されたTXのセット                       | string   |
| \_version   | ライブラリのバージョン                     | string   |
| env         | 評価環境                                   | string   |
| outbox      | 応答用のメッセージとスパーンを保持する     | object   |

## メソッド

### send(msg: Message\<table>) : Message\<table>

send関数は、メッセージオブジェクトまたは部分的なメッセージオブジェクトを受け取り、このオブジェクトに追加の`ao`固有のタグを追加し、完全なメッセージオブジェクトを返します。また、ao.outbox.Messagesテーブルに挿入されます。

**パラメータ**

- msg

スキーマ

```json
{
    "type": "object",
    "properties": {
        "Target": {
            "type": "string",
            "description": "メッセージを送信するプロセス/ウォレット"
        },
        "Data": {
            "type": "any",
            "description": "メッセージDataItemに送信するデータ"
        },
        "Tags": {
            "type": "object or array<name,value>",
            "description": "このプロパティはname,valueオブジェクトの配列またはオブジェクトである可能性があります"
        }
    }
}
```

例 1

```lua
local message = ao.send({
    Target = msg.From,
    Data = "ping",
    Tags = {
        {
            name = "Content-Type",
            value = "text/plain"
        }
    }
})
```

例 2

```lua
local message = ao.send({
    Target = msg.From,
    Data = "ping",
    Tags = {
        ["Content-Type"] = "text/plain"
    }
})
```

**戻り値**

スキーマ

```json
{
    "type": "object",
    "properties": {
        "Target": {
            "type": "string"
        },
        "Data": {
            "type": "any"
        },
        "Tags": {
            "type": "array",
            "description": "name/value配列",
            "items": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "value":{"type":"string"}
                }
            }
        }
    }
}
```

### spawn(module : string, spawn : Spawn\<table>) : Spawn\<table>

`spawn`関数は、最初の引数としてモジュールTXIDを受け取り、完全または部分的なSpawnテーブルを受け取ります。結果は完全なSpawnテーブルを返します。また、spawn関数は一意の参照識別子を持つ`Ref_`タグを生成します。

**パラメータ**

| 名前   | 説明                                                                     | タイプ   |
| ------ | ------------------------------------------------------------------------ | -------- |
| module | 使用するモジュールバイナリを識別するTXID                                 | string   |
| spawn  | `Data`と`Tags`プロパティを含む完全または部分的なテーブルオブジェクト     | table    |

スキーマ

module

```json
{
  "type": "string"
}
```

spawn

```json
{
  "type": "object",
  "properties": {
    "Data": { "type": "any" },
    "Tags": {
      "type": "object or array",
      "description": "name,valueの配列またはオブジェクト"
    }
  }
}
```

**戻り値**

スキーマ

```json
{
  "type": "object",
  "properties": {
    "Data": { "type": "any" },
    "Tags": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "value": { "type": "string" }
        }
      }
    }
  }
}
```

### isTrusted(msg : Message\<table>) : boolean

プロセスを生成する際に、0個以上のAuthorityタグを指定できます。aoライブラリはこれらの値を`authorities`と呼ばれる`ao`プロパティにテーブル配列として追加します。このセットはao.TN.1の`Proof of Authority`機能を提供します。メッセージが`handle`関数に到着したとき、開発者は`ao.isTrusted`を呼び出して、メッセージが信頼できるソースからのものであるかどうかを確認できます。

**パラメータ**

| 名前 | 説明                                         | タイプ  |
| ---- | -------------------------------------------- | ------- |
| msg  | このプロセスによって信頼されているかを確認するメッセージ | table   |

スキーマ

```json
{
    "type": "object",
    "properties": {
        "Target": {
            "type": "string"
        },
        "Data": {
            "type": "any"
        },
        "Tags": {
            "type": "array",
            "description": "name/value配列",
            "items": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "value":{"type":"string"}
                }
            }
        }
    }
}
```
