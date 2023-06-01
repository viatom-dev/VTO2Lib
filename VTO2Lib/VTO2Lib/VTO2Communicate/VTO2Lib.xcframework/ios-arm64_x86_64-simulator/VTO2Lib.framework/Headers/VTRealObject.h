//
//  VTRealObject.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTRealObject : NSObject

/// @brief blood oxygen value
@property (nonatomic, assign) u_char spo2;

/// @brief heart rate
@property (nonatomic, assign) u_short hr;

/// @brief battery value
@property (nonatomic, assign) u_char battery;

/// @brief battery status
@property (nonatomic, assign) u_char batState;

/// @brief Perfusion Index value
@property (nonatomic, assign) u_char pi;

/// @brief lead status . for BabyO2:    0: Probe off   1: Lead normal    2: Lead off
@property (nonatomic, assign) u_char leadState;

/// @brief motion value
@property (nonatomic, assign) u_char vector; 

@end

@interface VTRealWave : VTRealObject

@property (nonatomic, copy) NSArray *points;

@end

@interface VTRealPPG : NSObject

/// @brief Infrared
@property (nonatomic, assign) int ir;

/// @brief RLED
@property (nonatomic, assign) int red;

/// @brief motion
@property (nonatomic, assign) u_char motion;

@end




NS_ASSUME_NONNULL_END
