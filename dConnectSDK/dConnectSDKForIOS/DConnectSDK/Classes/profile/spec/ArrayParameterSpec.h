//
//  ArrayParameterSpec.h
//  DConnectSDK
//
//  Copyright (c) 2016 NTT DOCOMO,INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//

#import "DConnectParameterSpec.h"
#import "ArrayDataSpec.h"
#import "DConnectDataSpec.h"

@interface ArrayParameterSpec : DConnectParameterSpec

- (instancetype) initWithDataSpec: (DConnectDataSpec *) itemSpec;

- (DConnectDataSpec *) itemSpec;

-(NSNumber *) maxLength;

- (void) setMinLength: (NSNumber *) minLength;

- (NSNumber *) minLength;

- (void) setMaxLength: (NSNumber *) maxLength;

@end
