# ao connectのインストール

## 前提条件

---

ao connectをアプリにインストールするには、NodeJS/NPM 18以上が必要です。
<br>

## インストール方法

### npm

```sh
npm install --save @permaweb/aoconnect
```

### yarn

```sh
yarn add @permaweb/aoconnect -D
```

<br>

このモジュールはNodeJSおよびブラウザから使用できます。以下のようにインクルードします。

#### ESM (Node & Browser) aka type: `module`

```js
import {
  result,
  results,
  message,
  spawn,
  monitor,
  unmonitor,
  dryrun,
} from "@permaweb/aoconnect";
```

#### CJS (Node) aka type: `commonjs`

```js
const {
  result,
  results,
  message,
  spawn,
  monitor,
  unmonitor,
  dryrun,
} = require("@permaweb/aoconnect");
```
