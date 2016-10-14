//
//  ArrayDataSpecBuilder.m
//  DConnectSDK
//
//  Copyright (c) 2016 NTT DOCOMO,INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//

#import "ArrayDataSpecBuilder.h"
#import "ArrayDataSpec.h"

@implementation ArrayDataSpecBuilder

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setItemsSpec: nil];
        [self setMaxLength: nil];
        [self setMinLength: nil];
    }
    return self;
}

- (ArrayDataSpec *) build {
    ArrayDataSpec *spec = [[ArrayDataSpec alloc] initWithItemsSpec: [self itemsSpec]];
    [spec setMaxLength: [self maxLength]];
    [spec setMinLength: [self minLength]];
    return spec;
}

@end
