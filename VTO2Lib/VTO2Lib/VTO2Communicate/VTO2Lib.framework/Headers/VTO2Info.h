//
//  VTO2Info.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTO2Info : NSObject

/// @brief region
@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, copy) NSString *hardware;

@property (nonatomic, copy) NSString *software;

@property (nonatomic, copy) NSString *languageVer;

@property (nonatomic, copy) NSString *curLanguage;

@property (nonatomic, copy) NSString *sn;

/// @brief version for bluetooth communicate
@property (nonatomic, copy) NSString *spcpVer;

/// @brief parse files according to the version
@property (nonatomic, copy) NSString *fileVer;

/// @brief bootloader version
@property (nonatomic, copy) NSString *blVer;

/// @brief current date of the peripheral
@property (nonatomic, copy) NSString *curDate;

/// @brief current battery of the peripheral
@property (nonatomic, copy) NSString *curBattery;

/// @brief current battery status of the peripheral
@property (nonatomic, copy) NSString *curBatState;

/// @brief oxygen threshold that vibrate peripheral. for BabyO2: all even numbers in 80-96.   for others: all numbers in 80 - 95
@property (nonatomic, copy) NSString *curOxiThr;

/// @brief oxygen vibration intensity.  for KidsO2&Oxylink&BabyO2: lowest: 5  low:10 medium:17 high:22 highest:35.  for others: lowest:20 low:40 medium:60 high:80 highest:100
@property (nonatomic, copy) NSString *curMotor;

/// @brief current pedometer target
@property (nonatomic, copy) NSString *curPedThr;

/// @brief current mode of the peripheral
@property (nonatomic, copy) NSString *curMode;

/// @brief current measure status of the peripheral
@property (nonatomic, copy) NSString *curState;

/// @brief switch of vibration caused by heart rate value above hrHighThr or  below hrLowThr
@property (nonatomic, copy) NSString *hrSwitch;

/// @brief vibrate when the heart rate value is below the threshold
@property (nonatomic, copy) NSString *hrLowThr;

/// @brief vibrate when the heart rate value is above the threshold
@property (nonatomic, copy) NSString *hrHighThr;

/// @brief screen brightness.    0 : low  1 : medium  2 : high
@property (nonatomic, copy) NSString *lightStrength;

/// @brief swith of vibration caused by oxygen value is below the curOxiThr
@property (nonatomic, copy) NSString *oxiSwitch;

@property (nonatomic, copy) NSString *branchCode;

/// @brief screen mode.  0 : standart    1 : always off   2 : always on
@property (nonatomic, copy) NSString *lightingMode;

/// @brief file list  in the peripheral
@property (nonatomic, copy) NSString *fileList;

/// @brief volume of reminder sound.  For O2 max 20 - 100 interval :20
@property (nonatomic, copy) NSString *curBuzzer;

// for New BabyO2
@property (nonatomic, copy) NSString *MtSW;
@property (nonatomic, copy) NSString *MtThr;
@property (nonatomic, copy) NSString *IvSW;
@property (nonatomic, copy) NSString *IvThr;

@end

NS_ASSUME_NONNULL_END
