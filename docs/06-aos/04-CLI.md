# CLI

aosには、以下のことを行うためのコマンドライン引数があります:

- [name] - 新しいプロセスを作成するか、ウォレットの既存プロセスをロードします
- --load [file] - ファイルをロードします。このコマンドを一つ以上追加できます
- --cron [interval] - プロセスを作成するときにのみ使用されます
- --wallet [walletfile] - 特定のウォレットを使用します

## 複数のプロセスをaosで管理する

```sh
aos
```

名前が`default`のプロセスを開始または接続します

```sh
aos chatroom
```

名前が`chatroom`のプロセスを開始または接続します

```sh
aos treasureRoom
```

名前が`treasureRoom`のプロセスを開始または接続します

## Loadフラグ

```sh
aos treasureRoom --load greeting.lua --load treasure.lua --load puzzle.lua
```

loadフラグを使用すると、複数のソースファイルをプロセスにロードできます

## CRONフラグ

プロセスをスケジュールに従って反応させるためには、プロセスを生成する際にaoに指示する必要があります。

```sh
aos chatroom --cron 2-minutes
```

## タグフラグ

タグフラグを使用すると、カスタムタグ（例えば、静的環境変数として使用）を使用してプロセスを開始できます。

```sh
aos chatroom --tag-name Chat-Theme --tag-value Dark --tag-name Chat-Name --tag-value Mychat
```

上記のコマンドは、プロセスを生成するトランザクションに追加のタグを追加します。

```ts
// プロセスデータアイテムタグ
[
  ...
  { name: "Chat-Theme", value: "Dark" },
  { name: "Chat-Name", value: "Mychat" }
  ...
]
```
