//
//  DCMHealthProfile.h
//  DCMDevicePluginSDK
//
//  Copyright (c) 2016 NTT DOCOMO,INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//

/*!
 @file
 @brief Healthプロファイルを実装するための機能を提供する。
 @author NTT DOCOMO
 */
#import <DConnectSDK/DConnectSDK.h>

/*!
 @brief プロファイル名: health。
 */
extern NSString *const DCMHealthProfileName;

/*!
 @brief アトリビュート: heart。
 */
extern NSString *const DCMHealthProfileAttrHeart;


/*!
 @brief パラメータ: heart。
 */
extern NSString *const DCMHealthProfileParamHeart;


/*!
 @brief パラメータ: rate。
 */
extern NSString *const DCMHealthProfileParamRate;

/*!
 @brief パラメータ: value。
 */
extern NSString *const DCMHealthProfileParamValue;

/*!
 @brief パラメータ: mderFloat。
 */
extern NSString *const DCMHealthProfileParamMDERFloat;

/*!
 @brief パラメータ: type。
 */
extern NSString *const DCMHealthProfileParamType;

/*!
 @brief パラメータ: typeCode。
 */
extern NSString *const DCMHealthProfileParamTypeCode;

/*!
 @brief パラメータ: unit。
 */
extern NSString *const DCMHealthProfileParamUnit;

/*!
 @brief パラメータ: unitCode。
 */
extern NSString *const DCMHealthProfileParamUnitCode;

/*!
 @brief パラメータ: timeStamp。
 */
extern NSString *const DCMHealthProfileParamTimeStamp;

/*!
 @brief パラメータ: timeStampString。
 */
extern NSString *const DCMHealthProfileParamTimeStampString;

/*!
 @brief パラメータ: rr。
 */
extern NSString *const DCMHealthProfileParamRR;

/*!
 @brief パラメータ: energy。
 */
extern NSString *const DCMHealthProfileParamEnergy;

/*!
 @brief パラメータ: device。
 */
extern NSString *const DCMHealthProfileParamDevice;

/*!
 @brief パラメータ: productName。
 */
extern NSString *const DCMHealthProfileParamProductName;

/*!
 @brief パラメータ: manufacturerName。
 */
extern NSString *const DCMHealthProfileParamManufacturerName;

/*!
 @brief パラメータ: modelNumber。
 */
extern NSString *const DCMHealthProfileParamModelNumber;


/*!
 @brief パラメータ: firmwareRevision。
 */
extern NSString *const DCMHealthProfileParamFirmwareRevision;

/*!
 @brief パラメータ: serialNumber。
 */
extern NSString *const DCMHealthProfileParamSerialNumber;

/*!
 @brief パラメータ: softwareRevision。
 */
extern NSString *const DCMHealthProfileParamSoftwareRevision;

/*!
 @brief パラメータ: hardwareRevision。
 */
extern NSString *const DCMHealthProfileParamHardwareRevision;

/*!
 @brief パラメータ: partNumber。
 */
extern NSString *const DCMHealthProfileParamPartNumber;

/*!
 @brief パラメータ: protocolRevision。
 */
extern NSString *const DCMHealthProfileParamProtocolRevision;

/*!
 @brief パラメータ: systemId。
 */
extern NSString *const DCMHealthProfileParamSystemId;
/*!
 @brief パラメータ: batteryLevel。
 */
extern NSString *const DCMHealthProfileParamBatteryLevel;


@class DCMHealthProfile;

/*!
 @protocol DCMHealthProfileDelegate
 @brief HealthProfile各APIリクエスト通知用デリゲート。
 
 Health Profileの各APIへのリクエスト受信通知を受け取るデリゲート。
 */
@protocol DCMHealthProfileDelegate<NSObject>
@optional

#pragma mark - Get Methods

/*!
 @brief heart取得リクエストを受け取ったことをデリゲートに通知する。
 
 profileがheart取得リクエストを受け取ったことをデリゲートに通知する。<br>
 実装されない場合には、Not supportのエラーが返却される。
 
 <p>
 [対応するAPI] Health API [GET]
 </p>
 
 @param[in] profile このイベントを通知するDCMHealthProfileのオブジェクト
 @param[in] request リクエスト
 @param[in,out] response レスポンス
 @param[in] serviceId サービスID
 @retval YES レスポンスパラメータを返却する
 @retval NO レスポンスパラメータを返却しないので、@link DConnectManager::sendResponse: @endlinkで返却すること。
 */
- (BOOL)          profile:(DCMHealthProfile *)profile
didReceiveGetHeartRequest:(DConnectRequestMessage *)request
                 response:(DConnectResponseMessage *)response
                serviceId:(NSString *)serviceId;

#pragma mark - Put Methods
#pragma mark Event Registration

/*!
 @brief heartイベント登録リクエストを受け取ったことをデリゲートに通知する。
 
 profileがheartイベント登録リクエストを受け取ったことをデリゲートに通知する。<br>
 実装されない場合には、Not supportのエラーが返却される。
 
 <p>
 [対応するAPI] Health Event API [Register]
 </p>
 
 @param[in] profile このイベントを通知するDCMHealthProfileのオブジェクト
 @param[in] request リクエスト
 @param[in,out] response レスポンス
 @param[in] serviceId サービスID
 @param[in] sessionKey セッションキー
 @retval YES レスポンスパラメータを返却する
 @retval NO レスポンスパラメータを返却しないので、@link DConnectManager::sendResponse: @endlinkで返却すること。
 */
- (BOOL)           profile:(DCMHealthProfile *)profile
didReceivePutHeartRequest:(DConnectRequestMessage *)request
                  response:(DConnectResponseMessage *)response
                 serviceId:(NSString *)serviceId
                sessionKey:(NSString *)sessionKey;


#pragma mark - Delete Methods
#pragma mark Event Unregistration

/*!
 @brief heartイベント解除リクエストを受け取ったことをデリゲートに通知する。
 
 profileがheartイベント解除リクエストを受け取ったことをデリゲートに通知する。<br>
 実装されない場合には、Not supportのエラーが返却される。
 
 <p>
 [対応するAPI] Heart Event API [Unregister]
 </p>
 
 @param[in] profile このイベントを通知するDCMHealthProfileのオブジェクト
 @param[in] request リクエスト
 @param[in,out] response レスポンス
 @param[in] serviceId サービスID
 @param[in] sessionKey セッションキー
 @retval YES レスポンスパラメータを返却する
 @retval NO レスポンスパラメータを返却しないので、@link DConnectManager::sendResponse: @endlinkで返却すること。
 */
- (BOOL)                           profile:(DCMHealthProfile *)profile
didReceiveDeleteHeartRequest:(DConnectRequestMessage *)request
                                  response:(DConnectResponseMessage *)response
                                 serviceId:(NSString *)serviceId
                                sessionKey:(NSString *)sessionKey;

@end

/*!
 @class DCMHealthProfile
 @brief Healthプロファイル。
 
 Health Profileの各APIへのリクエストを受信する。
 受信したリクエストは各API毎にデリゲートに通知される。
 */
@interface DCMHealthProfile : DConnectProfile
/*!
 @brief DCMHealthProfileのデリゲートオブジェクト。
 
 デリゲートは @link DCMHealthProfileDelegate @endlink を実装しなくてはならない。
 デリゲートはretainされない。
 */
@property (nonatomic, weak) id<DCMHealthProfileDelegate> delegate;


#pragma mark - Setters
/*!
 @brief メッセージにHeartRate情報を設定する。
 @param[in] heart HeartRate情報
 @param[in,out] message HeartRate情報を格納するメッセージ
 */
+ (void) setHeart:(DConnectMessage *)heart target:(DConnectMessage *)message;

/*!
 @brief メッセージにRate情報を設定する。
 @param[in] rate Rate情報
 @param[in,out] message Rate情報を格納するメッセージ
 */
+ (void) setRate:(DConnectMessage *)rate target:(DConnectMessage *)message;


/*!
 @brief メッセージにRRI情報を設定する。
 @param[in] rr RRI情報
 @param[in,out] message RRI情報を格納するメッセージ
 */
+ (void) setRRI:(DConnectMessage *)rr target:(DConnectMessage *)message;


/*!
 @brief メッセージにEnergyExtended情報を設定する。
 @param[in] energy EnergyExtended情報
 @param[in,out] message EnergyExtended情報を格納するメッセージ
 */
+ (void) setEnergyExtended:(DConnectMessage *)energy target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器情報を設定する。
 @param[in] device 健康機器情報
 @param[in,out] message 健康機器情報を格納するメッセージ
 */
+ (void) setDevice:(DConnectMessage *)device target:(DConnectMessage *)message;


/*!
 @brief メッセージに健康機器の計測値を設定する。
 @param[in] value 健康機器の計測値
 @param[in,out] message 健康機器の計測値を格納するメッセージ
 */
+ (void) setValue:(double)value target:(DConnectMessage *)message;

/*!
 @brief メッセージにMDERFloat値を設定する。
 
 @param[in] mderFloat MDERFloat値
 @param[in,out] message MDERFloat値を格納するメッセージ
 */
+ (void) setMDERFloat:(NSString*)mderFloat target:(DConnectMessage *)message;


/*!
 @brief メッセージに健康機器の計測値のタイプを設定する。
 
 @param[in] type 健康機器の計測値のタイプ
 @param[in,out] message 健康機器の計測値のタイプを格納するメッセージ
 */
+ (void) setType:(NSString*)type target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器の計測値のタイプコードを設定する。
 
 @param[in] typeCode 健康機器の計測値のタイプコード
 @param[in,out] message 健康機器の計測値のタイプコードを格納するメッセージ
 */
+ (void) setTypeCode:(NSString*)typeCode target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器の計測値の単位を設定する。
 
 @param[in] unit 健康機器の計測値の単位
 @param[in,out] message 健康機器の計測値の単位を格納するメッセージ
 */
+ (void) setUnit:(NSString*)unit target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器の計測値の単位コードを設定する。
 
 @param[in] unitCode 健康機器の計測値の単位コード
 @param[in,out] message 健康機器の計測値の単位コードを格納するメッセージ
 */
+ (void) setUnitCode:(NSString*)unitCode target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器の計測値のタイムスタンプを設定する。
 
 @param[in] timeStamp 健康機器の計測値のタイムスタンプ
 @param[in,out] message 健康機器の計測値のタイムスタンプを格納するメッセージ
 */
+ (void) setTimeStamp:(long long)timeStamp target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器の計測値のタイムスタンプの文字列を設定する。
 
 @param[in] timeStampString 健康機器の計測値のタイムスタンプの文字列
 @param[in,out] message 健康機器の計測値のタイムスタンプの文字列を格納するメッセージ
 */
+ (void) setTimeStampString:(NSString*)timeStampString target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器のProductNameを設定する。
 
 @param[in] productName 健康機器のProductName
 @param[in,out] message 健康機器のProductNameを格納するメッセージ
 */
+ (void) setProductName:(NSString*)productName target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器のManufacturerNameを設定する。
 
 @param[in] manufacturerName 健康機器のManufacturerName
 @param[in,out] message 健康機器のManufacturerNameを格納するメッセージ
 */
+ (void) setManufacturerName:(NSString*)manufacturerName target:(DConnectMessage *)message;


/*!
 @brief メッセージに健康機器のModelNumberを設定する。
 
 @param[in] modelNumber 健康機器のModelNumber
 @param[in,out] message 健康機器のModelNumberを格納するメッセージ
 */
+ (void) setModelNumber:(NSString*)modelNumber target:(DConnectMessage *)message;


/*!
 @brief メッセージに健康機器のFirmwareRevisionを設定する。
 
 @param[in] firmwareRevision 健康機器のFirmwareRevision
 @param[in,out] message 健康機器のFirmwareRevisionを格納するメッセージ
 */
+ (void) setFirmwareRevision:(NSString*)firmwareRevision target:(DConnectMessage *)message;


/*!
 @brief メッセージに健康機器のSerialNumberを設定する。
 
 @param[in] serialNumber 健康機器のSerialNumber
 @param[in,out] message 健康機器のSerialNumberを格納するメッセージ
 */
+ (void) setSerialNumber:(NSString*)serialNumber target:(DConnectMessage *)message;


/*!
 @brief メッセージに健康機器のSoftwareRevisionを設定する。
 
 @param[in] softwareRevision 健康機器のSoftwareRevision
 @param[in,out] message 健康機器のSoftwareRevisionを格納するメッセージ
 */
+ (void) setSoftwareRevision:(NSString*)softwareRevision target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器のHardwareRevisionを設定する。
 
 @param[in] hardwareRevision 健康機器のHardwareRevision
 @param[in,out] message 健康機器のHardwareRevisionを格納するメッセージ
 */
+ (void) setHardwareRevision:(NSString*)hardwareRevision target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器のPartNumberを設定する。
 
 @param[in] partNumber 健康機器のPartNumber
 @param[in,out] message 健康機器のPartNumberを格納するメッセージ
 */
+ (void) setPartNumber:(NSString*)partNumber target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器のSystemIdを設定する。
 
 @param[in] systemId 健康機器のSystemId
 @param[in,out] message 健康機器のSystemIdを格納するメッセージ
 */
+ (void) setSystemId:(NSString*)systemId target:(DConnectMessage *)message;

/*!
 @brief メッセージに健康機器のBatteryLevelを設定する。
 
 @param[in] batteryLevel 健康機器のBatteryLevel
 @param[in,out] message 健康機器のBatteryLevelを格納するメッセージ
 */
+ (void) setBatteryLevel:(NSString*)batteryLevel target:(DConnectMessage *)message;



@end
