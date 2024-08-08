# エディタのセットアップ

aoの組み込み関数やユーティリティをすべて覚えるのは難しいことがあります。開発者の体験を向上させるために、お気に入りのテキストエディタに [Lua Language Server](https://luals.github.io) 拡張機能をインストールし、 [ao addon](https://github.com/martonlederer/ao-definitions) を追加することをお勧めします。これにより、組み込みのaos [モジュール](../aos/modules/index) および [グローバル](../aos/intro#globals) がサポートされます。

## VS Code

[sumneko.lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) 拡張機能をインストールする方法：

1. 拡張機能マーケットプレイスで "Lua" by sumneko を検索
2. 拡張機能をダウンロードしてインストール
3. VS Code コマンドパレットを `Shift + Command + P` (Mac) / `Ctrl + Shift + P` (Windows/Linux) で開き、以下のコマンドを実行：

```
> Lua: Open Addon Manager
```

4. Addon Manager で "ao" を検索し、最初の結果をクリックして "Enable" を選択。これでオートコンプリートが利用可能になります！

## その他のエディタ

1. 使用しているエディタが [language server protocol](https://microsoft.github.io/language-server-protocol/implementors/tools/) をサポートしていることを確認
2. Lua Language Server を [luals.github.io](https://luals.github.io/#install) の指示に従ってインストール
3. "ao" アドオンを Language Server にインストール

これで、Luaのコードを書く際にaoの機能をより効率的に利用できるようになります。
