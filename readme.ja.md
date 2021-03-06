# DeviceConnect iOS について

Device Connect WebAPIはスマートフォン上で仮想サーバとして動作するWebAPIで、様々なウェアラブルデバイスやIoTデバイスをWebブラウザやアプリから統一的な記述で簡単に利用することができます。
Device Connect iOSはiOS版のDeviceConnectのプラットフォームになります。

このガイドでは以下のことについて解説していきます。

* [プロジェクトの説明](#section1)
* [dConnectBrowserのビルドと起動](#section2)
* [動作確認](#section3)
* [DeviceConnectアプリの開発](#section4)
* [サポートするXcodeのバージョン](#section5)

# <a name="section1">プロジェクトの説明</a>
## dConnectDevicePlugin
| プロジェクト名|内容  |
|:-----------|:---------|
|dConnectDeviceAllJoyn|AllJoynのデバイスプラグイン。|
|dConnectDeviceAWSIoT|AWSIoTのデバイスプラグイン。|
|dConnectDeviceChromeCast|Chromecastのデバイスプラグイン。|
|dConnectDeviceHitoe|Hitoeのデバイスプラグイン。|
|dConnectDeviceHost|iOS端末のデバイスプラグイン。|
|dConnectDeviceHue|Hueのデバイスプラグイン。|
|dConnectDeviceIRKit|IRKitのデバイスプラグイン。|
|dConnectDeviceLinking|Linkingのデバイスプラグイン。|
|dConnectDevicePebble|Pebbleのデバイスプラグイン。|
|dConnectDeviceSonyCamera|QX10などのSonyCameraのデバイスプラグイン。|
|dConnectDeviceSphero|Spheroのデバイスプラグイン。|
|dConnectDeviceTheta|THETAのデバイスプラグイン。|
|dConnectDeviceTest|DeviceConnectのテスト用のデバイスプラグイン。|
|DCMDevicePluginSDK|共通の独自拡張Profileライブラリ。 |

## dConnectSDK
| プロジェクト名|内容  |
|:-----------|:---------|
|dConnectBrowser|DeviceConnect用のBrowserアプリ。|
|dConnectBrowserForIOS9|DeviceConnect用のiOS9以降用Browserアプリ。|
|dConnectSDKForIOS|DeviceConnectのプラットフォーム本体用ライブラリ。このライブラリをデバイスプラグインやネイティブアプリを作成するときに使用する。|
|dConnectSDKSample|DeviceConnectのJavaScript用テストを実行するためのアプリ。|

# <a name="section2">dConnectBrowserのビルドと起動</a>
　dConnectBrowserをiOS端末へインストールするには、まずXcodeのインストールとiOSのDeveloper登録を済ませ、実機転送ができる環境を整えておいてください。<br>
　その状態で、DeviceConnect.xcworkspaceを起動してください。起動されるワークスペースには、dConnectBrowserに実装されているデバイスプラグインとdConnectBrowserのプロジェクトの一覧が表示されます。<br>
　基本的には、dConnectBrowserのみの起動でも動作しますが、他のデバイスプラグインに変更を加えた場合などは以下のビルド手順書を参考にしてください。
　

* [dConnectBrowser](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/dConnectBrowser-Build)
* [dConnectBrowserForIOS9](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/dConnectBrowserForIOS9-Build)
* [AllJoyn](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/AllJoyn-Build)
* [ChromeCast](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/ChromeCast-Build)
* [Host](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Host-Build)
* [Hue](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Hue-Build)
* [IRKit](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/IRKit-Build)
* [Linking](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Linking-Build)
* [Pebble](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Pebble-Build)
* [SonyCamera](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/SonyCamera-Build)
* [Sphero](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Sphero-Build)
* [Theta](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Theta-Build)
* [Hitoe](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/Hitoe-Build)
* [AWSIoT](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/AWSIoT-Build)


# <a name="section3">動作確認</a>
 dConnectBrowserのアドレスバーに`http://localhost:4035/gotapi/availability`を入力してください。<br>
以下のようなJSONのレスポンスが返って来れば、DeviceConnectが動作していることを確認することができます。<br>

 <center><a href="./assets/availability.PNG" target="_blank">
<img src="./assets/availability.PNG" border="0"
 width="375" height="667" alt="" /></a></center>

 リクエスト

 ```
 GET http://localhost:4035/gotapi/availability
 ```

 レスポンス

 ```
 {
     "product":"dConnectBrowser",
     "version":"x.x",
     "name":"Manager-0702",
     "uuid":"xxxx-yyyyy-zzz-aaaa",
     "result":0,
}
 ```

  availability以外のAPIには、基本的にはアクセストークンが必要になるためにdConnectBrowserのアドレスでは簡単に確認することができません。
Device Connect の APIを使用してアプリケーションを作成する場合には、[こちら](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/ApplicationManual)のサンプルをご参考にしてください。

# <a name="section4">DeviceConnectアプリの開発</a>
 DeviceConnectを使ったアプリケーションおよび、アプリケーションの開発に関しましては、以下のページを参考にしてください。

* [アプリケーション開発マニュアル](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/ApplicationManual)<br>
 Device Connect Managerを使用したアプリケーションを開発したい場合には、こちらのデバイスプラグイン開発マニュアルをご参照ください。
* [デバイスプラグイン開発マニュアル](https://github.com/DeviceConnect/DeviceConnect-iOS/wiki/DevicePluginManual)<br>
Device Connect Managerに対応するデバイスプラグインを開発したい場合には、こちらのデバイスプラグイン開発マニュアルをご参照ください。

# <a name="section5">サポートするXcodeのバージョン</a>
DeviceConnectのデバイスプラグインは、下記に記すXcode以外でのビルド・実行をサポートしていません。


|デバイスプラグイン名|Xcodeバージョン|
|:--|:--|
|ChromeCast|8.0|
|Host|8.0|
|Hue|8.0|
|IRKit|8.0|
|Pebble|8.0|
|SonyCamera|8.0|
|Sphero|8.0|
|Theta|8.0|
|AllJoyn|8.0|
|Linking|8.0|
|Hitoe|7.2.1以下|
|AWSIoT|8.0|
