# .load

この機能を使用すると、ローカルマシンのソースファイルからLuaコードを読み込むことができます。このシンプルな機能により、aosプロセスでの作業において素晴らしいDX（開発者体験）を提供します。

ハンドラーを作成する際、大量のコードを書くことがあります。その際、vscodeのような豊富な開発環境を利用したくなるでしょう。Lua拡張機能をインストールして、構文チェックを行うこともできます。

では、ローカルのLuaソースコードをaoプロセスに公開する方法はどうすればよいでしょうか？ ここで`.load`コマンドが役立ちます。

hello.lua

```lua
Handlers.add(
  "ping",
  Handlers.utils.hasMatchingData("ping"),
  Handlers.utils.reply("pong")
)
```

aosシェル

```lua
.load hello.lua
```

簡単ですね！ 🐶
