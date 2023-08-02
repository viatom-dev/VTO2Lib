//
//  VTO2WaveObject.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTO2WaveObject : NSObject

/// @brief blood oxygen value
@property (nonatomic, assign) u_char spo2;

/// @brief heart rate value
@property (nonatomic, assign) u_short hr;

/// @brief acceleration vector sum
@property (nonatomic, assign) u_char ac_v_s;

/// @brief vibration mark of blood oxygen    0 : NO  other : YES
@property (nonatomic, assign) u_char spo2Mark;

/// @brief vibration mark of heart rate   0 : NO other : YES
@property (nonatomic, assign) u_char hrMark;

@end

NS_ASSUME_NONNULL_END
