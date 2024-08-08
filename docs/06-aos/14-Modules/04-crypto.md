# crypto

## 概要

`crypto`モジュールは、純粋なLuaでハッシュ、暗号化、その他の暗号化アルゴリズムのような暗号プリミティブを提供します。これにより、セキュアな通信やデータストレージの開発が容易になります。このドキュメントでは、モジュールの機能、インストール、および使用方法について説明します。

## 使用方法

```lua
local crypto = require(".crypto")
```

## プリミティブ

1. ダイジェスト (sha1, sha2, sha3, keccak, blake2bなど)
2. 暗号 (AES, ISSAC, Morus, NORXなど)
3. 乱数生成器 (ISAAC)
4. MACs (HMAC)
5. KDFs (PBKDF2)
6. ユーティリティ (Array, Stream, Queueなど)

---

# ダイジェスト

## MD2

指定されたメッセージのMD2ダイジェストを計算します。

- **パラメータ:**

  - `stream` (Stream): ストリーム形式のメッセージ

- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = crypto.utils.stream.fromString("ao")

return crypto.digest.md2(str).asHex() -- 0d4e80edd07bee6c7965b21b25a9b1ea
```

## MD4

指定されたメッセージのMD4ダイジェストを計算します。

- **パラメータ:**

  - `stream` (Stream): ストリーム形式のメッセージ

- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = crypto.utils.stream.fromString("ao")

return crypto.digest.md4(str).asHex() -- e068dfe3d8cb95311b58be566db66954
```

## MD5

指定されたメッセージのMD5ダイジェストを計算します。

- **パラメータ:**

  - `stream` (Stream): ストリーム形式のメッセージ

- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = crypto.utils.stream.fromString("ao")

return crypto.digest.md5(str).asHex() -- adac5e63f80f8629e9573527b25891d3
```

## SHA1

指定されたメッセージのSHA1ダイジェストを計算します。

- **パラメータ:**

  - `stream` (Stream): ストリーム形式のメッセージ

- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = crypto.utils.stream.fromString("ao")

return crypto.digest.sha1(str).asHex() -- c29dd6c83b67a1d6d3b28588a1f068b68689aa1d
```

## SHA2_256

指定されたメッセージのSHA2-256ダイジェストを計算します。

- **パラメータ:**
  - `stream` (Stream): ストリーム形式のメッセージ
- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = crypto.utils.stream.fromString("ao")

return crypto.digest.sha2_256(str).asHex() -- ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
```

## SHA2_512

指定されたメッセージのSHA2-512ダイジェストを計算します。

- **パラメータ:**
  - `msg` (string): ダイジェストを計算するメッセージ
- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = "ao"

return crypto.digest.sha2_512(str).asHex() -- 6f36a696b17ce5a71efa700e8a7e47994f3e134a5e5f387b3e7c2c912abe94f94ee823f9b9dcae59af99e2e34c8b4fb0bd592260c6720ee49e5deaac2065c4b1
```

## SHA3

次の関数が含まれています：

1. `sha3_256`
2. `sha3_512`
3. `keccak256`
4. `keccak512`

各関数は、指定されたメッセージのそれぞれのダイジェストを計算します。

- **パラメータ:**

  - `msg` (string): ダイジェストを計算するメッセージ

- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェスト。

例:

```lua
local str = "ao"

crypto.digest.sha3_256(str).asHex()  -- 1bbe785577db997a394d5b4555eec9159cb51f235aec07514872d2d436c6e985
crypto.digest.sha3_512(str).asHex()  -- 0c29f053400cb1764ce2ec555f598f497e6fcd1d304ce0125faa03bb724f63f213538f41103072ff62ddee701b52c73e621ed4d2254a3e5e9a803d83435b704d
crypto.digest.keccak256(str).asHex() -- 76da52eec05b749b99d6e62bb52333c1569fe75284e6c82f3de12a4618be00d6
crypto.digest.keccak512(str).asHex() -- 046fbfad009a12cef9ff00c2aac361d004347b2991c1fa80fba5582251b8e0be8def0283f45f020d4b04ff03ead9f6e7c43cc3920810c05b33b4873b99affdea
```

## Blake2b

指定されたメッセージのBlake2bダイジェストを計算します。

- **パラメータ:**

  - `data` (string): ハッシュ化するデータ。
  - `outlen` (number): 出力ハッシュの長さ（オプション） **デフォルトは64**。
  - `key` (string): ハッシュ化に使用するキー（オプション） **デフォルトは""**。

- **戻り値:** 異なる形式でダイジェストを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのダイジェスト。
  - `asHex()`: 16進数形式の文字列としてのダイジェスト。
  - `asString()`: 文字列形式のダイジェ

スト。

例:

```lua
local str = "ao"

crypto.digest.blake2b(str).asHex() -- 576701fd79a126f2c414ef94adf1117c88943700f312679d018c29c378b2c807a3412b4e8d51e191c48fb5f5f54bf1bca29a714dda166797b3baf9ead862ae1d
crypto.digest.blake2b(str, 32).asHex() -- 7050811afc947ba7190bb3c0a7b79b4fba304a0de61d529c8a35bdcbbb5544f4
crypto.digest.blake2b(str, 32, "secret_key").asHex() -- 203c101980fdf6cf24d78879f2e3db86d73d91f7d60960b642022cd6f87408f8
```

---

# 暗号

## AES

Advanced Encryption Standard (AES) は、機密情報を暗号化するために使用される対称ブロック暗号です。暗号化と復号化の2つの関数があります。

### Encrypt

AESアルゴリズムを使用して、指定されたメッセージを暗号化します。

- **パラメータ:**

  - `data` (string): 暗号化するデータ。
  - `key` (string): 暗号化に使用するキー。
  - `iv` (string) オプション: 暗号化に使用する初期化ベクトル。 **デフォルトは""**
  - `mode` (string) オプション: 暗号化に使用する動作モード。 **デフォルトは"CBC"**。使用可能なモードは `CBC`, `ECB`, `CFB`, `OFB`, `CTR`。
  - `keyLength` (number) オプション: 暗号化に使用するキーの長さ。 **デフォルトは128**。

- **戻り値:** 異なる形式で暗号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての暗号化データ。
  - `asHex()`: 16進数形式の文字列としての暗号化データ。
  - `asString()`: 文字列形式の暗号化データ。

### Decrypt

AESアルゴリズムを使用して、指定されたメッセージを復号化します。

- **パラメータ:**

  - `cipher` (string): 16進数でエンコードされた暗号化データ。
  - `key` (string): 復号化に使用するキー。
  - `iv` (string) オプション: 復号化に使用する初期化ベクトル。 **デフォルトは""**
  - `mode` (string) オプション: 復号化に使用する動作モード。 **デフォルトは"CBC"**。使用可能なモードは `CBC`, `ECB`, `CFB`, `OFB`, `CTR`。
  - `keyLength` (number) オプション: 復号化に使用するキーの長さ。 **デフォルトは128**。

- **戻り値:** 異なる形式で復号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての復号化データ。
  - `asHex()`: 16進数形式の文字列としての復号化データ。
  - `asString()`: 文字列形式の復号化データ。

例:

```lua
local str = "ao"

local iv = "super_secret_shh"
local key_128 = "super_secret_shh"

local encrypted = crypto.cipher.aes.encrypt("ao", key, iv).asHex() -- A3B9E6E1FBD9D46930E5F76807C84B8E
local decrypted = crypto.cipher.aes.decrypt(encrypted, key, iv).asHex() -- 616F0000000000000000000000000000

crypto.utils.hex.hexToString(decrypted) -- ao
```

## ISSAC暗号

ISAACは、暗号的に安全な擬似乱数生成器（CSPRNG）およびストリーム暗号です。次の関数があります。

1. `seedIsaac`: ISAAC暗号を指定されたシードで初期化します。
2. `getRandomChar`: ISAAC暗号を使用してランダムな文字を生成します。
3. `random`: ISAAC暗号を使用して指定された範囲内のランダムな数値を生成します。
4. `getRandom`: ISAAC暗号を使用してランダムな数値を生成します。
5. `encrypt`: ISAAC暗号を使用して指定されたメッセージを暗号化します。
6. `decrypt`: ISAAC暗号を使用して指定されたメッセージを復号化します。

### Encrypt

ISAAC暗号を使用して、指定されたメッセージを暗号化します。

- **パラメータ:**
  - `msg` (string): 暗号化するメッセージ。
  - `key` (string): 暗号化に使用するキー。
- **戻り値:** 異なる形式で暗号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての暗号化データ。
  - `asHex()`: 16進数形式の文字列としての暗号化データ。
  - `asString()`: 文字列形式の暗号化データ。

### Decrypt

ISAAC暗号を使用して、指定されたメッセージを復号化します。

- **パラメータ:**
  - `cipher` (string): 16進数でエンコードされた暗号化データ。
  - `key` (string): 復号化に使用するキー。
- **戻り値:** 異なる形式で復号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての復号化データ。
  - `asHex()`: 16進数形式の文字列としての復号化データ。
  - `asString()`: 文字列形式の復号化データ。

例:

```lua
local message = "ao"
local key = "secret_key"

local encrypted = crypto.cipher.issac.encrypt(message, key)
local decrypted = crypto.cipher.issac.decrypt(encrypted.asString(), key) -- ao

encrypted.asHex() -- 7851
```

### random

ISAAC暗号を使用してランダムな数値を生成します。

- **パラメータ:**
  - `min` (number) オプション: ランダム数の最小値。 **デフォルトは0**。
  - `max` (number) オプション: ランダム数の最大値。 **デフォルトは2^31 - 1**。
  - `seed` (string) オプション: 乱数生成に使用するシード。 **デフォルトはmath.random(0,2^32 - 1)**。
- **戻り値:** 指定された範囲内のランダム数。

例:

```lua
crypto.cipher.issac.random(0, 100) -- 42
```

## Morus暗号

MORUSは、高性能の認証付き暗号化アルゴリズムで、CAESARコンペティションのファイナリストとして選ばれました。

### Encrypt

MORUS暗号を使用して、指定されたメッセージを暗号化します。

- **パラメータ:**
  - `key` (string): 暗号化キー（16または32バイトの文字列）。
  - `iv` (string): ノンスまたは初期値（16バイトの文字列）。
  - `msg` (string): 暗号化するメッセージ（可変長の文字列）。
  - `ad` (string) オプション: 追加データ（可変長の文字列）。 **デフォルトは""**。
- **戻り値:** 異なる形式で暗号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての暗号化データ。
  - `asHex()`: 16進数形式の文字列としての暗号化データ。
  - `asString()`: 文字列形式の暗号化データ。

### Decrypt

MORUS暗号を使用して、指定されたメッセージを復号化します。

- **パラメータ:**
  - `key` (string): 暗号化キー（16または32バイトの文字列）。
  - `iv` (string): ノンスまたは初期値（16バイトの文字列）。
  - `cipher` (string):

 暗号化されたメッセージ（可変長の文字列）。
  - `adLen` (number) オプション: 追加データの長さ（可変長の文字列）。 **デフォルトは0**。
- **戻り値:** 異なる形式で復号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての復号化データ。
  - `asHex()`: 16進数形式の文字列としての復号化データ。
  - `asString()`: 文字列形式の復号化データ。

例:

```lua
local m = "ao"
local k = "super_secret_shh"
local iv = "0000000000000000"
local ad= ""

local e = crypto.cipher.morus.encrypt(k, iv, m, ad)
local d = crypto.cipher.morus.decrypt(k, iv, e.asString(), #ad) -- ao

e.asHex() -- 514ed31473d8fb0b76c6cbb17af35ed01d0a
```

## NORX暗号

NORXは、認証付き暗号化スキームで、CAESARコンペティションの最終候補の1つとして選ばれました。スポンジ構造に基づいており、効率的で多用途な実装を可能にするシンプルな置換を使用しています。

### Encrypt

NORX暗号を使用して、指定されたメッセージを暗号化します。

- **パラメータ:**
  - `key` (string): 暗号化キー（32バイトの文字列）。
  - `nonce` (string): ノンスまたは初期値（32バイトの文字列）。
  - `plain` (string): 暗号化するメッセージ（可変長の文字列）。
  - `header` (string) オプション: 追加データ（可変長の文字列）。 **デフォルトは""**。
  - `trailer` (string) オプション: 追加データ（可変長の文字列）。 **デフォルトは""**。
- **戻り値:** 異なる形式で暗号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての暗号化データ。
  - `asHex()`: 16進数形式の文字列としての暗号化データ。
  - `asString()`: 文字列形式の暗号化データ。

### Decrypt

NORX暗号を使用して、指定されたメッセージを復号化します。

- **パラメータ:**
  - `key` (string): 暗号化キー（32バイトの文字列）。
  - `nonce` (string): ノンスまたは初期値（32バイトの文字列）。
  - `crypted` (string): 暗号化されたメッセージ（可変長の文字列）。
  - `header` (string) オプション: 追加データ（可変長の文字列）。 **デフォルトは""**。
  - `trailer` (string) オプション: 追加データ（可変長の文字列）。 **デフォルトは""**。
- **戻り値:** 異なる形式で復号化データを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての復号化データ。
  - `asHex()`: 16進数形式の文字列としての復号化データ。
  - `asString()`: 文字列形式の復号化データ。

例:

```lua
local key = "super_duper_secret_password_shhh"
local nonce = "00000000000000000000000000000000"

local data = "ao"

-- ヘッダーとトレーラーはオプションです
local header, trailer = data, data

local encrypted = crypto.cipher.norx.encrypt(key, nonce, data, header, trailer).asString()
local decrypted = crypto.cipher.norx.decrypt(key, nonce, encrypted, header, trailer) -- ao

local authTag = encrypted:sub(#encrypted-32+1)

crypto.utils.hex.stringToHex(encrypted) -- 0bb35a06938e6541eccd4440adb7b46118535f60b09b4adf378807a53df19fc4ea28
crypto.utils.hex.stringToHex(authTag) -- 5a06938e6541eccd4440adb7b46118535f60b09b4adf378807a53df19fc4ea28
```

---

# 乱数生成器

モジュールには、暗号的に安全な擬似乱数生成器（CSPRNG）およびストリーム暗号であるISAACを使用した乱数生成器が含まれています。

- **パラメータ:**
  - `min` (number) オプション: ランダム数の最小値。 **デフォルトは0**。
  - `max` (number) オプション: ランダム数の最大値。 **デフォルトは2^31 - 1**。
  - `seed` (string) オプション: 乱数生成に使用するシード。 **デフォルトはmath.random(0,2^32 - 1)**。
- **戻り値:** 指定された範囲内のランダム数。

例:

```lua
crypto.random.(0, 100, "seed") -- 42
```

---

# MACs

## HMAC

ハッシュベースのメッセージ認証コード（HMAC）は、暗号化ハッシュ関数を使用したメッセージ認証のメカニズムです。HMACは、MD5やSHA-1などの任意の反復暗号化ハッシュ関数と組み合わせて使用できます。

モジュールは`createHmac`という関数を提供し、これを使用してHMACインスタンスを作成します。

- **パラメータ:**
  - `data` (Stream): ハッシュ化するデータ。
  - `key` (Array): ハッシュ化に使用するキー。
  - `algorithm` (string) オプション: ハッシュ化に使用するアルゴリズム。 **デフォルトは"sha256"**。使用可能なアルゴリズムは "sha1", "sha256"。
- **戻り値:** 異なる形式でHMACを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしてのHMAC。
  - `asHex()`: 16進数形式の文字列としてのHMAC。
  - `asString()`: 文字列形式のHMAC。

例:

```lua
local data = crypto.utils.stream.fromString("ao")
local key = crypto.utils.array.fromString("super_secret_key")

crypto.mac.createHmac(data, key).asHex() -- 3966f45acb53f7a1a493bae15afecb1a204fa32d
crypto.mac.createHmac(data, key, "sha256").asHex() -- 542da02a324155d688c7689669ff94c6a5f906892aa8eccd7284f210ac66e2a7
```

---

# KDFs

## PBKDF2

パスワードベースのキー導出関数2（PBKDF2）は、パスワードやパスフレーズに対して疑似乱数関数（ハッシュベースのメッセージ認証コード（HMAC）など）を適用し、塩値と一緒に多くの回数繰り返して導出キーを生成します。生成されたキーは、後続の操作で暗号化キーとして使用できます。

- **パラメータ:**
  - `password` (Array): キーを導出するパスワード。
  - `salt` (Array): 使用する塩値。
  - `iterations` (number): 実行する反復回数。
  - `keyLen` (number): 導出するキーの長さ。
  - `digest` (string) オプション: 使用するダイジェストアルゴリズム。 **デフォルトは"sha1"**。使用可能なアルゴリズムは "sha1", "sha256"。
- **戻り値:** 異なる形式で導出キーを取得する関数を含むテーブル。
  - `asBytes()`: バイトテーブルとしての導出キー。
  - `asHex()`: 16進数形式の文字列としての導出キー。
  - `asString()`: 文字列形式の導出キー。

例:

```lua
local salt = crypto.utils.array.fromString("salt")
local password = crypto.utils.array.fromString("password")
local iterations = 4
local keyLen = 16

local res = crypto.kdf.pbkdf2(password, salt, iterations, keyLen).asHex() -- C

4C21BF2BBF61541408EC2A49C89B9C6
```

---

# ユーティリティ

## Array

使用例:

```lua
local arr = crypto.utils.array

arr.fromString("ao") -- Array
arr.toString(arr.fromString("ao")) -- ao

arr.fromHex("616f") -- Array
arr.toHex(arr.fromHex("616f")) -- 616f

arr.concat(arr.fromString("a"), arr.fromString("o")) -- Array
arr.truncate(arr.fromString("ao"), 1) -- Array

arr.XOR(arr.fromString("a"), arr.fromString("o")) -- Array

arr.substitute(arr.fromString("a"), arr.fromString("o")) -- Array
arr.permute(arr.fromString("a"), arr.fromString("o")) -- Array

arr.copy(arr.fromString("ao")) -- Array
arr.slice(arr.fromString("ao"), 0, 1) -- Array
```

### `size`

配列のサイズを返します。

- **パラメータ:**
  - `arr` (Array): 配列のサイズを取得します。
- **戻り値:** 配列のサイズ。

### `fromString`

文字列から配列を作成します。

- **パラメータ:**
  - `str` (string): 配列を作成する文字列。
- **戻り値:** 文字列から作成された配列。

### `toString`

配列を文字列に変換します。

- **パラメータ:**
  - `arr` (Array): 文字列に変換する配列。
- **戻り値:** 配列を文字列として返します。

### `fromStream`

ストリームから配列を作成します。

- **パラメータ:**
  - `stream` (Stream): ストリームを作成する文字列。
- **戻り値:** ストリームから作成された配列。

### `readFromQueue`

キューからデータを読み取り、配列に格納します。

- **パラメータ:**
  - `queue` (Queue): キューからデータを読み取ります。
  - `size` (number): 読み取るデータのサイズ。
- **戻り値:** キューから読み取ったデータを含む配列。

### `writeToQueue`

配列からキューにデータを書き込みます。

- **パラメータ:**
  - `queue` (Queue): キューに書き込むデータ。
  - `array` (Array): 配列からデータを書き込みます。
- **戻り値:** なし

### `toStream`

配列をストリームに変換します。

- **パラメータ:**
  - `arr` (Array): ストリームに変換する配列。
- **戻り値:** (Stream) 配列をストリームとして返します。

### `fromHex`

16進数の文字列から配列を作成します。

- **パラメータ:**
  - `hex` (string): 配列を作成する16進数の文字列。
- **戻り値:** 16進数の文字列から作成された配列。

### `toHex`

配列を16進数の文字列に変換します。

- **パラメータ:**
  - `arr` (Array): 16進数の文字列に変換する配列。
- **戻り値:** 配列を16進数の文字列として返します。

### `concat`

2つの配列を連結します。

- **パラメータ:**
  - `a` (Array): 連結する配列。
  - `b` (Array): 連結する配列。
- **戻り値:** 連結された配列。

### `truncate`

配列を指定された長さに切り詰めます。

- **パラメータ:**
  - `a` (Array): 切り詰める配列。
  - `newSize` (number): 配列の新しいサイズ。
- **戻り値:** 切り詰められた配列。

### `XOR`

2つの配列に対してビットごとのXOR演算を行います。

- **パラメータ:**
  - `a` (Array): 最初の配列。
  - `b` (Array): 2つ目の配列。
- **戻り値:** XOR演算の結果。

### `substitute`

最初の配列のキーと2つ目の配列の値を持つ新しい配列を作成します。

- **パラメータ:**
  - `input` (Array): 置換する配列。
  - `sbox` (Array): 置換に使用する配列。
- **戻り値:** 置換された配列。

### `permute`

2つ目の配列のキーと最初の配列の値を持つ新しい配列を作成します。

- **パラメータ:**
  - `input` (Array): 並べ替える配列。
  - `pbox` (Array): 並べ替えに使用する配列。
- **戻り値:** 並べ替えられた配列。

### `copy`

配列のコピーを作成します。

- **パラメータ:**
  - `input` (Array): コピーする配列。
- **戻り値:** コピーされた配列。

### `slice`

配列のスライスを作成します。

- **パラメータ:**
  - `input` (Array): スライスする配列。
  - `start` (number): スライスの開始インデックス。
  - `stop` (number): スライスの終了インデックス。
- **戻り値:** スライスされた配列。

---

## Stream

Streamは、バイト列を表すデータ構造であり、ストリーミング方式でデータを保存および操作するために使用されます。

使用例:

```lua
local stream = crypto.utils.stream

local str = "ao"
local arr = {97, 111}

stream.fromString(str) -- Stream
stream.toString(stream.fromString(str)) -- ao

stream.fromArray(arr) -- Stream
stream.toArray(stream.fromArray(arr)) -- {97, 111}

stream.fromHex("616f") -- Stream
stream.toHex(stream.fromHex("616f")) -- 616f
```

### `fromString`

文字列からストリームを作成します。

- **パラメータ:**
  - `str` (string): ストリームを作成する文字列。
- **戻り値:** 文字列から作成されたストリーム。

### `toString`

ストリームを文字列に変換します。

- **パラメータ:**
  - `stream` (Stream): 文字列に変換するストリーム。
- **戻り値:** ストリームを文字列として返します。

### `fromArray`

配列からストリームを作成します。

- **パラメータ:**
  - `arr` (Array): ストリームを作成する配列。
- **戻り値:** 配列から作成されたストリーム。

### `toArray`

ストリームを配列に変換します。

- **パラメータ:**
  - `stream` (Stream): 配列に変換するストリーム。
- **戻り値:** ストリームを配列として返します。

### `fromHex`

16進数の文字列からストリームを作成します。

- **パラメータ:**
  - `hex` (string): ストリームを作成する16進数の文字列。
- **戻り値:** 16進数の文字列から作成されたストリーム。

### `toHex`

ストリームを16進数の文字列に変換します。

- **パラメータ:**
  - `stream` (Stream): 16進数の文字列に変換するストリーム。
- **戻り値:** ストリームを16進数の文字列として返します。

---

## Hex

使用例:

```lua
local hex = crypto.utils.hex

hex.hexToString("616f") -- ao
hex.stringToHex("ao") -- 616f
```

### `hexToString`

16進数の文字列を文字列に変換します。

- **パラメータ:**
  - `hex` (string): 文字列に変換する16進数の文字列。
- **戻り値:** 16進数の文字列を文字列として返します。

### `stringToHex`

文字列を16進数の文字列に変換します。

- **パラメータ:**
  - `str` (string): 16進数の文字列に変換する文字列。
- **戻り値:** 文字列を16進数の文字列として返します。

---

## Queue

Queueは、要素のシーケンスを表すデータ構造であり、先入れ先出し（

FIFO）方式でデータを保存および操作するために使用されます。

使用例:

```lua
local q = crypto.utils.queue()

q.push(1)
q.push(2)
q.pop() -- 1
q.size() -- 1
q.getHead() -- 2
q.getTail() -- 2
q.reset()
```

### `push`

要素をキューにプッシュします。

- **パラメータ:**
  - `queue` (Queue): 要素をプッシュするキュー。
  - `element` (any): キューにプッシュする要素。
- **戻り値:** なし

### `pop`

キューから要素をポップします。

- **パラメータ:**
  - `queue` (Queue): 要素をポップするキュー。
  - `element` (any): キューからポップする要素。
- **戻り値:** ポップされた要素。

### `size`

キューのサイズを返します。

- **パラメータ:** なし
- **戻り値:** キューのサイズ。

### `getHead`

キューの先頭を返します。

- **パラメータ:** なし
- **戻り値:** キューの先頭。

### `getTail`

キューの末尾を返します。

- **パラメータ:** なし
- **戻り値:** キューの末尾。

### `reset`

キューをリセットします。

- **パラメータ:** なし
