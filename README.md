# professional-ios
Profesional iOS用のリポジトリ

## 検証環境と実行方法

検証用ツールチェーンはXcode 26.6 / Swift 6.3です。Swiftの言語モード・iOSの最低バージョンは各プロジェクトの設定を使用します。macOSでXcodeをインストールし、初回起動時の追加コンポーネントのインストールを完了してください。

リポジトリのルートで以下を実行します。

```sh
# 検証対象と番号の一覧
swift Scripts/verify.swift --list

# 全対象を順番に検証
swift Scripts/verify.swift

# 1件だけ検証（0始まり）
swift Scripts/verify.swift --index 0
```

アプリは署名不要のSimulator向けにビルドし、Swiftパッケージは `swift test` で検証します。作業用ディレクトリは実行ごとに作成・削除するため、初回と同様に時間がかかります。依存パッケージの取得にはネットワーク接続が必要です。

## 検証対象

| 番号 | 対象 | 種類 | 開く場所 |
| ---: | --- | --- | --- |
| 0 | `Bankey` | Simulatorビルド | `Bankey/Bankey.xcodeproj` |
| 1 | `NavigationControllerDemo` | Simulatorビルド | `NavigationControllerDemo/NavigationControllerDemo.xcodeproj` |
| 2 | `PageViewControllerDemo` | Simulatorビルド | `PageViewControllerDemo/PageViewControllerDemo.xcodeproj` |
| 3 | `Password-Reset` | Simulatorビルド | `Password-Reset/Password-Reset.xcodeproj` |
| 4 | `ScrollViewDemo( NoStoryboard )` | Simulatorビルド | `ScrollViewDemo( NoStoryboard )/ScrollViewDemo( NoStoryboard ).xcodeproj` |
| 5 | `ScrollViewDemo` | Simulatorビルド | `ScrollViewDemo/ScrollViewDemo.xcodeproj` |
| 6 | `TabBarControllerDemo` | Simulatorビルド | `TabBarControllerDemo/TabBarControllerDemo.xcodeproj` |
| 7 | `UITextFieldSandbox` | Simulatorビルド | `UITextFieldSandbox/UITextFieldSandbox.xcodeproj` |
| 8 | `BankeyCore` | Swift回帰テスト | `Bankey/Package.swift` |

アプリを操作するには表のworkspace（ある場合）またはprojectをXcodeで開き、対象のschemeとiPhone Simulatorを選択して実行します。実機で動かす場合は、ご自身のSigning Teamを設定してください。

## CIと検証範囲

`Quality` ワークフローは上記と同じ一覧・スクリプトを使い、対象ごとにビルドまたはテストを実行します。ビルドの成功だけでは、画面表示、アクセシビリティ、通信先の動作、テスト網羅性は保証されません。UIサンプルはSimulator上での操作確認も必要です。

## 振る舞いの回帰テスト

Bankeyの金額表示はDecimalのまま小数第2位へ四捨五入し、セントを2桁に揃えます。負数は-$0.05の形式で表示し、ゼロへ丸めた値には負号を付けません。セル内の重複した金額生成処理を削除し、読み上げにも整形済み金額を使います。

既存の口座・ログインの振る舞いに加え、0.05、1.005、999.995、負数、ゼロ、NaNを検証します。

```sh
swift test --package-path Bankey
```

この教材の通貨表記はen_US・米ドル固定です。

## Swiftコード品質

[設計・命名・所有関係の方針と、この教材への適用範囲](SWIFT-QUALITY.md)を参照してください。

パスワード画面の入力検証と解放テストは `swift Scripts/test-password.swift` でSimulator上でも実行します。
