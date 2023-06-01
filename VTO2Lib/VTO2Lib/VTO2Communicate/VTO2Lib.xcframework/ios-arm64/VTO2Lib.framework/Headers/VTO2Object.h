//
//  VTO2Object.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTO2Object : NSObject


/// @brief the version of the file
@property (nonatomic, assign) u_char fileVer;

/// @brief the mode of the file    0 : sleep    1 : monitor
@property (nonatomic, assign) u_char mode;

/// @brief the date & time of the file
@property (nonatomic, assign) u_short year;
@property (nonatomic, assign) u_char month;
@property (nonatomic, assign) u_char day;
@property (nonatomic, assign) u_char hour;
@property (nonatomic, assign) u_char minute;
@property (nonatomic, assign) u_char second;

/// @brief the record time of the file
@property (nonatomic, assign) u_short recordTime;

/// @brief average blood oxygen value
@property (nonatomic, assign) u_char averageSpO2;

/// @brief lowest blood oxygen value
@property (nonatomic, assign) u_char lowestSpO2;

/// @brief drops over 3%
@property (nonatomic, assign) u_char dropsL3;

/// @brief drops over 4%
@property (nonatomic, assign) u_char dropsL4;

@property (nonatomic, assign) u_char T90;

/// @brief time of drop
@property (nonatomic, assign) u_short dropTime;

/// @brief number of drop
@property (nonatomic, assign) u_char dropNumber;

/// @brief score for data
@property (nonatomic, assign) float score;

/// @brief steps
@property (nonatomic, assign) u_int steps;

/// @brief wave data.  Parse by `parseO2WaveObjectArrayWithWaveData:`
@property (nonatomic, copy) NSData *waveData;

@end

NS_ASSUME_NONNULL_END
