//
//  DConnectKeyEventProfile.h
//  DConnectSDK
//
//  Copyright (c) 2015 NTT DOCOMO,INC.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php
//

/*!
 @file
 @brief Provides functionality to implement the Key Event profile.
 @author NTT DOCOMO
 */
#import <DConnectSDK/DConnectProfile.h>

/*!
 @brief Profile name
 */
extern NSString *const DConnectKeyEventProfileName;

/*!
 @brief Attribute: down.
 */
extern NSString *const DConnectKeyEventProfileAttrOnDown;

/*!
 @brief Attribute: up.
 */
extern NSString *const DConnectKeyEventProfileAttrOnUp;

/*!
 @brief Parameter: keyevent.
 */
extern NSString *const DConnectKeyEvnetProfileParamKeyEvent;

/*!
 @brief Parameter: id.
 */
extern NSString *const DConnectKeyEventProfileParamId;

/*!
 @brief Parameter: config.
 */
extern NSString *const DConnectKeyEventProfileParamConfig;

/*!
 @brief Parameter: Key Type(KEYTYPE_STD_KEY).
 */
extern int const DConnectKeyEventProfileKeyTypeStdKey;

/*!
 @brief Parameter: Key Type(KEYTYPE_MEDIA_CTRL).
 */
extern int const DConnectKeyEventProfileKeyTypeMediaCtrl;

/*!
 @brief Parameter: Key Type(KEYTYPE_DPAD_BUTTON).
 */
extern int const DConnectKeyEventProfileKeyTypeDpadButton;

/*!
 @brief Parameter: Key Type(KEYTYPE_USER).
 */
extern int const DConnectKeyEventProfileKeyTypeUser;


/*!
 @class DConnectKeyEventProfile
 @brief Key Event Profile.
 
 Receive request to the Key Event Profile API.
 The received request is reported to the delegate for each API.
 */
@interface DConnectKeyEventProfile : DConnectProfile

#pragma mark - Setters

/*!
 @brief Set key event information to message.
 @param[in] keyevent key event information.
 @param[in,out] message message for storing key event information.
 */
+ (void) setKeyEvent:(DConnectMessage *)keyevent target:(DConnectMessage *)message;

/*!
 @brief Set the identification number to message.
 @param[in] id identification number.
 @param[in,out] message message for storing identification number.
 */
+ (void) setId:(int)id target:(DConnectMessage *)message;

/*!
 @brief Set key event configure to message.
 @param[in] config button configer.
 @param[in,out] message message for storing button configure.
 */
+ (void) setConfig:(NSString *)config target:(DConnectMessage *)message;

@end
