//
//  VTBLEUtils.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/23.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTDevice.h"

#ifdef DEBUG
    #define DLog( s, ... ) NSLog( @"<%@,(line=%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
    #define DLog( s, ... )
#endif

typedef NS_ENUM(NSInteger, VTBLEState) {
    VTBLEStateUnknown = 0,
    VTBLEStateResetting,
    VTBLEStateUnsupported,
    VTBLEStateUnauthorized,
    VTBLEStatePoweredOff,
    VTBLEStatePoweredOn,
};

NS_ASSUME_NONNULL_BEGIN

@protocol VTBLEUtilsDelegate <NSObject>

@optional
- (void)updateBleState:(VTBLEState)state;

- (void)didDiscoverDevice:(VTDevice *)device;

- (void)didConnectedDevice:(VTDevice *)device;

/// @brief This device has been disconnected. Note: If error == nil ，user manually disconnect.
- (void)didDisconnectedDevice:(VTDevice *)device andError:(NSError *)error;

@end


@interface VTBLEUtils : NSObject<CBCentralManagerDelegate>

@property (nonatomic, strong) VTDevice *device;

/// @brief Whether to enable the automatic reconnection function.   default YES.
@property (nonatomic, assign) BOOL isAutoReconnect;

@property (nonatomic, assign) id <VTBLEUtilsDelegate> delegate; 


+ (instancetype)sharedInstance;

- (VTBLEState)bleState;

- (void)startScan;

- (void)stopScan;

- (void)connectToDevice:(VTDevice *)device;

- (void)cancelConnect;

@end

NS_ASSUME_NONNULL_END
