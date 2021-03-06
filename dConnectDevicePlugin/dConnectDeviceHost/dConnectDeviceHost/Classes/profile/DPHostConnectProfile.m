//
//  DPHostConnectProfile.m
//  dConnectDeviceHost
//
//  Copyright (c) 2014 NTT DOCOMO, INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//


#import "DPHostConnectProfile.h"
#import "DPHostDevicePlugin.h"
#import "DPHostService.h"
#import "DPHostUtils.h"
#import "DPHostReachability.h"
/*
 @brief ConnectProfileのステータスを通知するためのブロック。
 */
typedef void (^DPHostConnectStatusBlock)(BOOL status);

@interface DPHostConnectProfile()


@property (nonatomic) DConnectEventManager *eventMgr;

@property (nonatomic) DPHostReachability *wifiReachability;


@property (nonatomic) CBCentralManager *centralManager;

/*
 @brief bluetoothの状態を通知するためのブロック。
 */
@property (nonatomic) NSMutableArray *bluetoothStatusBlocks;
/*
 @brief bleの状態を通知するためのブロック。
 */
@property (nonatomic) NSMutableArray *bleStatusBlocks;

/*
 @brief wifiの状態を通知するためのブロック。
 */
@property (nonatomic) NSMutableArray *wifiStatusBlocks;

/*
 @brief bluetoothの状態をイベント通知するためのブロック。
 */
@property (nonatomic) id bluetoothEventBlock;
/*
 @brief bleの状態をイベント通知するためのブロック。
 */
@property (nonatomic) id bleEventBlock;

/*
 @brief wifiの状態を通知するためのブロック。
 */
@property (nonatomic) id wifiEventBlock;

@end

@implementation DPHostConnectProfile

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _eventMgr = [DConnectEventManager sharedManagerForClass:[DPHostDevicePlugin class]];
        
        _bluetoothStatusBlocks = [NSMutableArray array];
        _bleStatusBlocks = [NSMutableArray array];
        _wifiStatusBlocks = [NSMutableArray array];
        
        _bluetoothEventBlock = nil;
        _wifiEventBlock = nil;
        __weak typeof(self) _self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
                    addObserver:_self
                       selector:@selector(reachabilityChanged:)
                           name:kReachabilityChangedNotification
                         object:nil];
        });

        // API登録(didReceiveGetWifiRequest相当)
        NSString *getWifiRequestApiPath = [self apiPath: nil
                                          attributeName: DConnectConnectProfileAttrWifi];
        [self addGetPath: getWifiRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            [_self scanForWifi];
            NetworkStatus netStatus = [[_self wifiReachability] currentReachabilityStatus];
            if (netStatus == NotReachable) {
                [DConnectConnectProfile setEnable:NO target:response];
            } else {
                [DConnectConnectProfile setEnable:YES target:response];
            }
            [response setResult:DConnectMessageResultTypeOk];
            return YES;
        }];
        
        // API登録(didReceiveGetBluetoothRequest相当)
        NSString *getBluetoothRequestApiPath = [self apiPath: nil
                                               attributeName: DConnectConnectProfileAttrBluetooth];
        [self addGetPath: getBluetoothRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            DPHostConnectStatusBlock block = ^(BOOL isStatus) {
                [DConnectConnectProfile setEnable:isStatus target:response];
                [response setResult:DConnectMessageResultTypeOk];
                if (![_self checkBluetoothBlocks]) {
                    [[_self centralManager] stopScan];
                }
                [[DConnectManager sharedManager] sendResponse:response];
            };
            [[_self bluetoothStatusBlocks] addObject:block];
            [_self scanForPeripherals];
            
            return NO;
        }];
        
        
        // API登録(didReceiveGetBLERequest相当)
        NSString *getBLERequestApiPath = [self apiPath: nil
                                         attributeName: DConnectConnectProfileAttrBLE];
        [self addGetPath: getBLERequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            DPHostConnectStatusBlock block = ^(BOOL isStatus) {
                [DConnectConnectProfile setEnable:isStatus target:response];
                [response setResult:DConnectMessageResultTypeOk];
                if (![_self checkBluetoothBlocks]) {
                    [[_self centralManager] stopScan];
                }
                [[DConnectManager sharedManager] sendResponse:response];
            };
            [[_self bleStatusBlocks] addObject:block];
            [_self scanForPeripherals];
            
            return NO;
        }];
        
        // API登録(didReceivePutOnWifiChangeRequest相当)
        NSString *putOnWifiChangeRequestApiPath = [self apiPath: nil
                                                  attributeName: DConnectConnectProfileAttrOnWifiChange];
        [self addPutPath: putOnWifiChangeRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            BOOL result = [_self registerEventWithRequest:request response:response];
            if (result) {
                __block DConnectDevicePlugin *plugin = (DConnectDevicePlugin *)_self.plugin;
                _wifiEventBlock = ^(BOOL isStatus) {
                    NSArray *evts = [_self.eventMgr eventListForServiceId:DPHostDevicePluginServiceId
                                                                  profile:DConnectConnectProfileName
                                                                attribute:DConnectConnectProfileAttrOnWifiChange];
                    // イベント送信
                    for (DConnectEvent *evt in evts) {
                        DConnectMessage *eventMsg = [DConnectEventManager createEventMessageWithEvent:evt];
                        DConnectMessage *wifi = [DConnectMessage message];
                        [DConnectConnectProfile setEnable:isStatus target:wifi];
                        [DConnectConnectProfile setConnectStatus:wifi target:eventMsg];
                        
                        [plugin sendEvent:eventMsg];
                    }
                    
                };
                [_self scanForWifi];
            }
            return YES;
        }];
        
        // API登録(didReceivePutOnBluetoothChangeRequest相当)
        NSString *putOnBluetoothChangeRequestApiPath = [self apiPath: nil
                                                       attributeName: DConnectConnectProfileAttrOnBluetoothChange];
        [self addPutPath: putOnBluetoothChangeRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            BOOL result = [_self registerEventWithRequest:request response:response];
            if (result) {
                __block DConnectDevicePlugin *plugin = (DConnectDevicePlugin *)_self.plugin;
                _bluetoothEventBlock = ^(BOOL isStatus) {
                    NSArray *evts = [_self.eventMgr eventListForServiceId:DPHostDevicePluginServiceId
                                                                  profile:DConnectConnectProfileName
                                                                attribute:DConnectConnectProfileAttrOnBluetoothChange];
                    // イベント送信
                    for (DConnectEvent *evt in evts) {
                        DConnectMessage *eventMsg = [DConnectEventManager createEventMessageWithEvent:evt];
                        DConnectMessage *bluetooth = [DConnectMessage message];
                        [DConnectConnectProfile setEnable:isStatus target:bluetooth];
                        [DConnectConnectProfile setConnectStatus:bluetooth target:eventMsg];
                        [plugin sendEvent:eventMsg];
                    }
                };
                [_self scanForPeripherals];
            }
            return YES;
        }];
        
        // API登録(didReceivePutOnBLEChangeRequest相当)
        NSString *putOnBLEChangeRequestApiPath = [self apiPath: nil
                                                 attributeName: DConnectConnectProfileAttrOnBLEChange];
        [self addPutPath: putOnBLEChangeRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            BOOL result = [_self registerEventWithRequest:request response:response];
            if (result) {
                __block DConnectDevicePlugin *plugin = (DConnectDevicePlugin *)_self.plugin;
                _bleEventBlock = ^(BOOL isStatus) {
                    NSArray *evts = [_self.eventMgr eventListForServiceId:DPHostDevicePluginServiceId
                                                                  profile:DConnectConnectProfileName
                                                                attribute:DConnectConnectProfileAttrOnBLEChange];
                    // イベント送信
                    for (DConnectEvent *evt in evts) {
                        DConnectMessage *eventMsg = [DConnectEventManager createEventMessageWithEvent:evt];
                        DConnectMessage *ble = [DConnectMessage message];
                        [DConnectConnectProfile setEnable:isStatus target:ble];
                        [DConnectConnectProfile setConnectStatus:ble target:eventMsg];
                        
                        [plugin sendEvent:eventMsg];
                    }
                    
                };
                [_self scanForPeripherals];
            }
            return YES;
        }];
        
        // API登録(didReceiveDeleteOnWifiChangeRequest相当)
        NSString *deleteOnWifiChangeRequestApiPath = [self apiPath: nil
                                                     attributeName: DConnectConnectProfileAttrOnWifiChange];
        [self addDeletePath: deleteOnWifiChangeRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            BOOL result = [_self unregisterEventWithRequest:request response:response];
            if (result) {
                _wifiEventBlock = nil;
                [[_self wifiReachability] stopNotifier];
            }
            return YES;
        }];
        
        // API登録(didReceiveDeleteOnBluetoothChangeRequest相当)
        NSString *deleteOnBluetoothChangeRequestApiPath = [self apiPath: nil
                                                          attributeName: DConnectConnectProfileAttrOnBluetoothChange];
        [self addDeletePath: deleteOnBluetoothChangeRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            BOOL result = [_self unregisterEventWithRequest:request response:response];
            if (result) {
                _bluetoothEventBlock = nil;
                [[_self centralManager] stopScan];
            }
            return YES;
        }];
        
        // API登録(didReceiveDeleteOnBLEChangeRequest相当)
        NSString *deleteOnBLEChangeRequestApiPath = [self apiPath: nil
                                                    attributeName: DConnectConnectProfileAttrOnBLEChange];
        [self addDeletePath: deleteOnBLEChangeRequestApiPath api: ^BOOL(DConnectRequestMessage *request, DConnectResponseMessage *response) {
            BOOL result = [_self unregisterEventWithRequest:request response:response];
            if (result) {
                _bleEventBlock = nil;
                [[_self centralManager] stopScan];
            }
            return YES;
        }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - CoreBluetooth Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    BOOL isStatus = (central.state == CBCentralManagerStatePoweredOn);

    NSArray *bluetoothBlocks = _bluetoothStatusBlocks;
    if (bluetoothBlocks) {
        for (DPHostConnectStatusBlock bluetoothBlock in bluetoothBlocks) {
            bluetoothBlock(isStatus);
        }
        [_bluetoothStatusBlocks removeAllObjects];
    }
    NSArray *bleBlocks = _bleStatusBlocks;
    if (bleBlocks) {
        for (DPHostConnectStatusBlock bleBlock in bleBlocks) {
            bleBlock(isStatus);
        }
        [_bleStatusBlocks removeAllObjects];
    }
    DPHostConnectStatusBlock bluetoothBlock = _bluetoothEventBlock;
    if (bluetoothBlock) {
        bluetoothBlock(isStatus);
    }
    DPHostConnectStatusBlock bleBlock = _bleEventBlock;
    if (bleBlock) {
        bleBlock(isStatus);
    }
    if (![self checkBluetoothBlocks]) {
        [_centralManager stopScan];
    }
}

#pragma mark - Wifi Delegate

- (void) reachabilityChanged:(NSNotification *)note
{
    DPHostReachability* curReach = [note object];
    BOOL isStatus = ([curReach currentReachabilityStatus] != NotReachable);
    NSArray *wifiBlocks = _wifiStatusBlocks;
    if (wifiBlocks) {

        for (DPHostConnectStatusBlock wifiBlock in wifiBlocks) {
            wifiBlock(isStatus);
        }
        [_wifiStatusBlocks removeAllObjects];
    }
    DPHostConnectStatusBlock wifiBlock = _wifiEventBlock;
    if (wifiBlock) {
        wifiBlock(isStatus);
    }
    if (![self checkWifiBlocks]) {
        [_wifiReachability stopNotifier];
    }
    
}
#pragma mark - Private Method

- (void)scanForPeripherals
{
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _centralManager.delegate = self;

    NSArray *services = @[];
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)};
    [_centralManager scanForPeripheralsWithServices:services options:options];
}

- (void)scanForWifi
{

    _wifiReachability = [DPHostReachability reachabilityForInternetConnection];
    [_wifiReachability startNotifier];

}


                   
                   
- (BOOL) checkBluetoothBlocks {
    return _bluetoothStatusBlocks.count > 0 || _bluetoothStatusBlocks || _bleStatusBlocks.count > 0 || _bleEventBlock;
}

- (BOOL) checkWifiBlocks {
    return _wifiStatusBlocks.count > 0 || _wifiStatusBlocks;
}

- (BOOL)registerEventWithRequest:(DConnectRequestMessage *)request response:(DConnectResponseMessage *)response {
    switch ([_eventMgr addEventForRequest:request]) {
        case DConnectEventErrorNone:             // エラー無し.
            [response setResult:DConnectMessageResultTypeOk];
            return YES;
        case DConnectEventErrorInvalidParameter: // 不正なパラメータ.
            [response setErrorToInvalidRequestParameter];
            return NO;
        case DConnectEventErrorNotFound:         // マッチするイベント無し.
        case DConnectEventErrorFailed:           // 処理失敗.
            [response setErrorToUnknown];
            return NO;
    }
}

- (BOOL)unregisterEventWithRequest:(DConnectRequestMessage *)request response:(DConnectResponseMessage *)response {
    switch ([_eventMgr removeEventForRequest:request]) {
        case DConnectEventErrorNone:             // エラー無し.
            [response setResult:DConnectMessageResultTypeOk];
            return YES;
        case DConnectEventErrorInvalidParameter: // 不正なパラメータ.
            [response setErrorToInvalidRequestParameter];
            return NO;
        case DConnectEventErrorNotFound:         // マッチするイベント無し.
        case DConnectEventErrorFailed:           // 処理失敗.
            [response setErrorToUnknown];
            return NO;
    }
    return YES;
}
@end
