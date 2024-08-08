# エディタの設定

aoの組み込み関数やユーティリティをすべて覚えるのは時に難しいことがあります。開発者体験を向上させるために、[Lua Language Server](https://luals.github.io)拡張機能をお気に入りのテキストエディタにインストールし、[aoアドオン](https://github.com/martonlederer/ao-definitions)を追加することをお勧めします。これにより、すべての組み込みaos [モジュール](../guides/aos/index.md)や[グローバル](../guides/aos/intro#globals)に対応します。

## VS Code

[sumneko.lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)拡張機能をインストールします：

1. 拡張機能マーケットプレイスで「Lua」を検索し、sumnekoのものを見つけます
2. 拡張機能をダウンロードしてインストールします
3. VS Codeのコマンドパレットを開くために、`Shift + Command + P`（Mac）または`Ctrl + Shift + P`（Windows/Linux）を押し、次のコマンドを実行します：

```
> Lua: Open Addon Manager
```

4. まずワークスペースを開きます。アドオンマネージャーで「ao」を検索し、最初の結果が表示されるはずです。「Enable」をクリックしてオートコンプリートを楽しみましょう！

この手順を各ワークスペースごとに行いたくない場合は、生成されたワークスペースの`settings.json`ファイルから`Lua.workspace.library`オブジェクトをグローバル`settings.json`ファイルにコピーすることができます。

## その他のエディタ

1. エディタが[言語サーバープロトコル](https://microsoft.github.io/language-server-protocol/implementors/tools/)をサポートしているか確認します
2. [luals.github.io](https://luals.github.io/#install)の手順に従ってLua Language Serverをインストールします
3. 言語サーバーに「ao」アドオンをインストールします
