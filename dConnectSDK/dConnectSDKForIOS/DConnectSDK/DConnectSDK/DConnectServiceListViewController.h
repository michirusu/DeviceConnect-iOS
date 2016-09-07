//
//  DConnectServiceListViewController.h
//  DConnectSDK
//
//  Copyright (c) 2016 NTT DOCOMO,INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//

#import <UIKit/UIKit.h>
#import <DConnectSDK/DConnectSystemProfile.h>
#import <DConnectSDK/DConnectServiceListener.h>

@interface DConnectServiceListViewController : UITableViewController<DConnectServiceListener>

@property (nonatomic, weak) id<DConnectSystemProfileDelegate> delegate;

@end
