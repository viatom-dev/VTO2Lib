//
//  VTO2Parser.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTO2Info.h"
#import "VTO2Object.h"
#import "VTO2WaveObject.h"
#import "VTRealObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface VTO2Parser : NSObject

/// @brief parse O2 information
/// @param infoData infoData from peripheral
+ (VTO2Info *)parseO2InfoWithData:(NSData * _Nonnull)infoData;

/// @brief parse O2 object
/// @param fileData fileData from peripheral
+ (VTO2Object *)parseO2ObjectWithData:(NSData * _Nonnull)fileData;

/// @brief parse O2 Wave array .
/// @param waveData waveData from  VTO2Object
+ (NSArray <VTO2WaveObject *>*)parseO2WaveObjectArrayWithWaveData:(NSData * _Nonnull)waveData;

/// @brief parse O2 Real-time data
/// @param realData realData from peripheral
+ (VTRealObject *)parseO2RealObjectWithData:(NSData *)realData;

/// @brief parse O2 Real-time waveform data
/// @param realWave real-time waveform data from peripheral
+ (VTRealWave *)parseO2RealWaveWithData:(NSData *)realWave;

/// @brief parse O2 Real PPG data
/// @param realPPG real PPG data from peripheral
+ (NSArray <VTRealPPG *>*)parseO2RealPPGWithData:(NSData *)realPPG;

@end

NS_ASSUME_NONNULL_END
