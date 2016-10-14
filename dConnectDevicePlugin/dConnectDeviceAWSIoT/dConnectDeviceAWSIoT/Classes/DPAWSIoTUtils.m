//
//  DPAWSIoTUtils.m
//  dConnectDeviceAWSIoT
//
//  Copyright (c) 2016 NTT DOCOMO, INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//

#import "DPAWSIoTUtils.h"
#import "DPAWSIoTKeychain.h"
#import "DPAWSIoTManager.h"
#import "DPAWSIoTNetworkManager.h"
#import "DConnectManager+Private.h"
#import "DConnectManagerServiceDiscoveryProfile.h"
#import "DConnectMessage+Private.h"
#import "DPAWSIoTController.h"

#define kAccessKeyID @"accessKey"
#define kSecretKey @"secretKey"
#define kRegionKey @"regionKey"
#define kSyncKey @"syncInterval"

#define ERROR_DOMAIN @"DPAWSIoTUtils"

#define kOrigin @"http://localhost:4035"

@implementation DPAWSIoTUtils

// ローディング画面
static UIViewController *loadingHUD;

// アカウントの設定があるか
+ (BOOL)hasAccount {
	NSString *accessKey = [DPAWSIoTKeychain findWithKey:kAccessKeyID];
	NSString *secretKey = [DPAWSIoTKeychain findWithKey:kSecretKey];
	return accessKey!=nil && secretKey!=nil;
}

// アカウントの設定をクリア
+ (void)clearAccount {
	[DPAWSIoTKeychain deleteWithKey:kAccessKeyID];
	[DPAWSIoTKeychain deleteWithKey:kSecretKey];
	[DPAWSIoTKeychain deleteWithKey:kRegionKey];
}

// アカウントを設定
+ (void)setAccount:(NSString*)accessKey secretKey:(NSString*)secretKey region:(NSInteger)region {
	[DPAWSIoTKeychain updateValue:accessKey key:kAccessKeyID];
	[DPAWSIoTKeychain updateValue:secretKey key:kSecretKey];
	[DPAWSIoTKeychain updateValue:[@(region) stringValue] key:kRegionKey];
}

// イベント更新間隔を設定
+ (void)setEventSyncInterval:(NSInteger)interval {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:interval forKey:kSyncKey];
	[defaults synchronize];
}

// イベント更新間隔を取得
+ (NSInteger)eventSyncInterval {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults registerDefaults:@{kSyncKey:@(10)}];
	return [defaults integerForKey:kSyncKey];
}

// AccessTokenを取得
+ (NSString*)accessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"_access_token_"];
}

// AccessTokenを追加
+ (void)addAccessToken:(NSString*)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"_access_token_"];
    [defaults synchronize];
}

// Managerを許可
+ (void)addAllowManager:(NSString*)uuid {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[defaults arrayForKey:@"allowManagers"] mutableCopy];
	if (!array) {
		array = [NSMutableArray array];
	}
	if (![array containsObject:uuid]) {
		[array addObject:uuid];
	}
	[defaults setObject:array forKey:@"allowManagers"];
	[defaults synchronize];
}

// Managerの許可を解除
+ (void)removeAllowManager:(NSString*)uuid {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[defaults arrayForKey:@"allowManagers"] mutableCopy];
	if (!array) {
		return;
	}
	[array removeObject:uuid];
	[defaults setObject:array forKey:@"allowManagers"];
	[defaults synchronize];
}

// Managerが許可されているか
+ (BOOL)hasAllowedManager:(NSString*)uuid {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *array = [defaults arrayForKey:@"allowManagers"];
	if (array) {
		return [array containsObject:uuid];
	} else {
		return NO;
	}
}

// ログイン
+ (void)loginWithHandler:(void (^)(NSError *error))handler {
	NSString *accessKey = [DPAWSIoTKeychain findWithKey:kAccessKeyID];
	NSString *secretKey = [DPAWSIoTKeychain findWithKey:kSecretKey];
	NSInteger region = [[DPAWSIoTKeychain findWithKey:kRegionKey] integerValue];
	[[DPAWSIoTManager sharedManager] connectWithAccessKey:accessKey secretKey:secretKey region:region completionHandler:^(NSError *error) {
        if (error) {
            if (handler) {
                handler(error);
            }
        } else {
            NSString *accessToken = [DPAWSIoTUtils accessToken];
            if (!accessToken) {
                [DPAWSIoTUtils auth:handler];
            } else {
                [[DPAWSIoTController sharedManager] openWebSocket:accessToken];
                if (handler) {
                    handler(nil);
                }
            }
        }
	}];
}

+ (void) auth:(void (^)(NSError *error))handler {
    [self authProfile:nil handler:handler];
}

+ (void) authProfile:(NSString *)profile handler:(void (^)(NSError *error))handler {
    NSMutableArray *requestScopes = [@[@"servicediscovery",
                                       @"serviceinformation",
                                       @"system",
                                       @"battery",
                                       @"connect",
                                       @"deviceorientation",
                                       @"filedescriptor",
                                       @"file",
                                       @"mediaplayer",
                                       @"mediastreamrecording",
                                       @"notification",
                                       @"phone",
                                       @"proximity",
                                       @"settings",
                                       @"vibration",
                                       @"light",
                                       @"remotecontroller",
                                       @"drivecontroller",
                                       @"mhealth",
                                       @"sphero",
                                       @"dice",
                                       @"temperature",
                                       @"camera",
                                       @"canvas",
                                       @"health",
                                       @"touch",
                                       @"humandetect",
                                       @"keyevent",
                                       @"omnidirectionalimage",
                                       @"tv",
                                       @"powermeter",
                                       @"humidity",
                                       @"illuminance",
                                       @"videochat",
                                       @"airconditioner",
                                       @"atmosphericpressure",
                                       @"ecg",
                                       @"poseEstimation",
                                       @"stressEstimation",
                                       @"walkState",
                                       @"gpio"] mutableCopy];
    if (profile && ![requestScopes containsObject:profile]) {
        [requestScopes addObject:profile];
    }
    
    [DConnectUtil asyncAuthorizeWithOrigin:kOrigin
                                   appName:@"AWSIoT"
                                    scopes:requestScopes
                                   success:^(NSString *clientId, NSString *accessToken) {
                                       [DPAWSIoTUtils addAccessToken:accessToken];
                                       [[DPAWSIoTController sharedManager] openWebSocket:accessToken];
                                       if (handler) {
                                           handler(nil);
                                       }
                                   } error:^(DConnectMessageErrorCodeType errorCode) {
                                       if (handler) {
                                           NSError *error = [NSError errorWithDomain:@"Failed to authorization." code:errorCode userInfo:nil];
                                           handler(error);
                                       }
                                   }];
}

// サービス一覧を取得
+ (void)fetchServicesWithHandler:(DConnectResponseBlocks)callback {
    DConnectManager *mgr = [DConnectManager sharedManager];
    DConnectRequestMessage *request = [DConnectRequestMessage new];
    [request setAction: DConnectMessageActionTypeGet];
    [request setProfile:DConnectServiceDiscoveryProfileName];
    [request setAccessToken:[DPAWSIoTUtils accessToken]];
    [request setOrigin:kOrigin];
    [request setString:@"true" forKey:@"_selfOnly"];
    [mgr sendRequest:request callback:callback];
}

// サービス情報を取得
+ (void)fetchServiceInformationWithId:(NSString*)serviceId callback:(DConnectResponseBlocks)callback {
    DConnectManager *mgr = [DConnectManager sharedManager];
    DConnectRequestMessage *request = [DConnectRequestMessage new];
    [request setAction:DConnectMessageActionTypeGet];
    [request setProfile:DConnectServiceInformationProfileName];
    [request setServiceId:serviceId];
    [request setAccessToken:[DPAWSIoTUtils accessToken]];
    [request setOrigin:kOrigin];
    [mgr sendRequest:request callback:callback];
}

// ローディング画面表示
+ (void)showLoadingHUD:(UIStoryboard*)storyboard {
	if (!loadingHUD) {
		loadingHUD = [storyboard instantiateViewControllerWithIdentifier:@"LoadingHUD"];
	}
	[[UIApplication sharedApplication].keyWindow addSubview:loadingHUD.view];
	loadingHUD.view.alpha = 0;
	loadingHUD.view.tag = 0;
	[UIView animateWithDuration:0.4 delay:0 options:0 animations:^{
		loadingHUD.view.alpha = 1.0;
	} completion:^(BOOL finished) {
		loadingHUD.view.tag = 1;
	}];
}

// ローディング画面非表示
+ (void)hideLoadingHUD {
	if (loadingHUD.view.tag == 0) {
		[loadingHUD.view removeFromSuperview];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			loadingHUD.view.alpha = 0;
		} completion:^(BOOL finished) {
			[loadingHUD.view removeFromSuperview];
		}];
	}
}

// メニュー作成
+ (UIAlertController*)createMenu:(NSArray*)items handler:(void (^)(int index))handler {
	UIAlertController *alert =
	[UIAlertController alertControllerWithTitle:nil
										message:nil
								 preferredStyle:UIAlertControllerStyleActionSheet];
 
	// cancel
	UIAlertAction * cancelAction =
	[UIAlertAction actionWithTitle:@"Cancel"
							 style:UIAlertActionStyleCancel
						   handler:nil];
	[alert addAction:cancelAction];

	// メニューアイテム
	for (int i=0; i<items.count; i++) {
		UIAlertAction * action =
		[UIAlertAction actionWithTitle:items[i]
								 style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction * action)
		 {
			 handler(i);
		 }];
		[alert addAction:action];
	}
	return alert;
}

+ (void)sendRequestDictionary:(NSDictionary*)requestDic callback:(DConnectResponseBlocks)callback
{
	if (!requestDic) {
		return;
	}
    
    DConnectRequestMessage *request = [DConnectRequestMessage new];
    [request.internalDictionary addEntriesFromDictionary:requestDic];
    [request setOrigin:kOrigin];
    [request setString:DConnectServiceInnerTypeHttp forKey:DConnectServiceInnerType];
    
    NSString *method = requestDic[@"action"];
    if ([method localizedCaseInsensitiveContainsString:@"get"]) {
        [request setAction:DConnectMessageActionTypeGet];
    } else if ([method localizedCaseInsensitiveContainsString:@"put"]) {
        [request setAction:DConnectMessageActionTypePut];
    } else if ([method localizedCaseInsensitiveContainsString:@"post"]) {
        [request setAction:DConnectMessageActionTypePost];
    } else if ([method localizedCaseInsensitiveContainsString:@"delete"]) {
        [request setAction:DConnectMessageActionTypeDelete];
    }
    
    NSString *token = [DPAWSIoTUtils accessToken];
    if (!token) {
        [DPAWSIoTUtils auth:^(NSError *error) {
            if (error) {
                DConnectResponseMessage *response = [DConnectResponseMessage new];
                [response setErrorToAuthorization];
                callback(response);
            } else {
                [DPAWSIoTUtils sendRequest:request callback:callback];
            }
        }];
    } else {
        [DPAWSIoTUtils sendRequest:request callback:callback];
    }
}

+ (void)sendRequest:(DConnectRequestMessage*)request callback:(DConnectResponseBlocks)callback
{
    [request setOrigin:kOrigin];
    [request setAccessToken:[DPAWSIoTUtils accessToken]];

    DConnectManager *mgr = [DConnectManager sharedManager];
    [mgr sendRequest:request callback:^(DConnectResponseMessage *response) {
        if (response.result == DConnectMessageResultTypeError) {
            DConnectMessageErrorCodeType errorCode = response.errorCode;
            switch (errorCode) {
                default:
                    callback(response);
                    break;
                case DConnectMessageErrorCodeScope: {
                    [DPAWSIoTUtils authProfile:[request profile] handler:^(NSError *error) {
                        if (error) {
                            callback(response);
                        } else {
                            [DPAWSIoTUtils sendRequest:request callback:callback];
                        }
                    }];
                }   break;
                case DConnectMessageErrorCodeAuthorization:
                case DConnectMessageErrorCodeExpiredAccessToken:
                case DConnectMessageErrorCodeEmptyAccessToken:
                case DConnectMessageErrorCodeNotFoundClientId: {
                    [DPAWSIoTUtils auth:^(NSError *error) {
                        if (error) {
                            callback(response);
                        } else {
                            [DPAWSIoTUtils sendRequest:request callback:callback];
                        }
                    }];
                }   break;
            }
        } else {
            callback(response);
        }
    }];
}

// パス追加
+ (NSString*)appendPath:(NSString*)path params:(NSMutableDictionary*)params name:(NSString*)name {
	if (params[name]) {
		path = [path stringByAppendingPathComponent:params[name]];
		[params removeObjectForKey:name];
	}
	return path;
}

// Packege名取得
+ (NSString *)packageName {
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *package = [bundle bundleIdentifier];
	return package;
}

// アラート表示
+ (void)showAlert:(UIViewController*)vc title:(NSString*)title message:(NSString*)message handler:(void (^)())handler {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
																			 message:message
																	  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action =
	[UIAlertAction actionWithTitle:@"OK"
							 style:UIAlertActionStyleCancel
						   handler:^(UIAlertAction *action)
	 {
		 handler();
	 }];
	[alertController addAction:action];
	[vc presentViewController:alertController animated:YES completion:nil];
}

@end
