//
//  VTO2Def.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#ifndef VTO2Def_h
#define VTO2Def_h

#ifdef DEBUG
    #define DLog( s, ... ) NSLog( @"<%@,(line=%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
    #define DLog( s, ... )
#endif

typedef enum : NSUInteger {
    VTFileLoadResultSuccess,
    VTFileLoadResultTimeOut,
    VTFileLoadResultFailed,
    VTFileLoadResultNotExist,
} VTFileLoadResult;  /// @brief result of download file from peripheral

typedef enum : NSUInteger {
    VTCommonResultSuccess,
    VTCommonResultTimeOut,
    VTCommonResultFailed,
} VTCommonResult; /// @brief result of normal command

typedef enum : NSUInteger {
    VTCmdTypeNone,
    VTCmdTypeStartRead,
    VTCmdTypeReading,
    VTCmdTypeEndRead,
    VTCmdTypeGetInfo,
    VTCmdTypeSyncParam,
    VTCmdTypeGetRealData,
    VTCmdTypeGetRealPPG,
    VTCmdTypeSetFactory,
} VTCmdType;


typedef enum : NSUInteger {
    VTParamTypeDate,
    VTParamTypeOxiThr,
    VTParamTypeMotor,
    VTParamTypePedtar,
    VTParamTypeLightingMode,
    VTParamTypeHeartRateSwitch,
    VTParamTypeHeartRateLowThr,
    VTParamTypeHeartRateHighThr,
    VTParamTypeLightStrength,
    VTParamTypeOxiSwitch,
    VTParamTypeBuzzer,
} VTParamType;


#endif /* VTO2Def_h */
