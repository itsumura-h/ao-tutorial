# クエスト FAQ

::: info

`ao`エコシステムは非常に初期段階であり、多くの機会に満ちています。コミュニティのクエストボードには、エコシステムを成長させるためにソフトウェアをテストし、構築する方法がたくさんあり、その過程でネイティブ通貨であるCREDを獲得することができます。

:::

## ビデオチュートリアル

<iframe width="680" height="350" src="https://www.youtube.com/embed/QA3OmkLcdRs?si=CLAZrIUhJ0aEGYxM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## どのようなクエストが利用可能ですか？

`ao`ローカルネット内には、クエスト情報を問い合わせることができる開発者チャットルームがあります。まず、`aos`を起動します：

```sh
$ aos
```

次に、まだ参加していない場合は、`Quests`チャットルームに参加します。オプションで、スクリーンネーム/ハンドルを第二引数として提供できます。

```lua
aos> Join("Quests")
# もしくは
aos> Join("Quests", "MyScreenName")
```

その後、`/Quests`スラッシュコマンドをそのチャットルームに送信します。複数のチャットルームに参加している場合、第二引数で特定のチャットルームにのみメッセージを送ることができます。

```lua
aos> Say("/Quests")
# もしくは
aos> Say("/Quests", "Quests")
```

数秒後、ボットがチャットルームに利用可能なクエストのリストを放送します。

## クエストの詳細を確認するにはどうすればよいですか？

特定のクエストの詳細を知りたい場合は、`Quests`チャットルームに`/Quests:[index]`スラッシュコマンドを送信します。`[index]`はクエスト番号に置き換えてください。例えば：

```lua
aos> Say("/Quests:1", "Quests")
# もしくは
aos> Say("/Quests:2", "Quests")
```

### クエスト1: "Begin"

クエスト1の詳細な手順は、このクックブックの[Begin](/tutorials/begin/index)チュートリアルにあります。

### クエスト2: "Bots-and-Games"

クエスト2の詳細な手順は、このクックブックの[Bots and Games](/tutorials/bots-and-games/index)チュートリアルにあります。

## クエストを完了するにはどうすればよいですか？

クエストの説明にあるすべての手順を実行し、クレームの提出を含めてください。

## CREDを受け取るにはどうすればいいですか？
各クエストのテキスト説明には、クレームリクエストを提出する方法が記載されています。クエストを完全に完了した後、クエスト説明に従ってクレームを提出してください。クエストのすべてのステップを完了し、クレームリクエストを提出することで、CREDを受け取ることができます。クレームリクエストの処理には時間がかかります。

## CREDはいつ受け取れますか？
リクエストは手動で確認され、すべての必要なステップを実行したかどうかが検証されます。営業日には、クレームの処理に約24時間かかりますので、ご了承ください。

## 現在のCRED残高を確認/検証するにはどうすればいいですか？
`credUtils`ブループリントを`ao`プロセスにロードすることで、CRED残高を迅速に確認でき、友達にCREDを送ることもできます！

```
aos> .load-blueprint credUtils
Loading...  credUtils                                        # サンプル出力
undefined                                                    # サンプル出力
aos> CRED.balance
Your CRED balance has not been checked yet. Updating now.    # サンプル出力
CRED Balance updated: 500.000                                # サンプル出力
```

[aosブループリント](https://cookbook_ao.arweave.dev/guides/aos/blueprints/index.html)についての詳細を読む。
