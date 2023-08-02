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

typedef enum : u_char {
    VTCmdStartWrite = 0x0,
    VTCmdWriteContent = 0x01,
    VTCmdEndWrite = 0x02,
    VTCmdStartRead = 0x03,
    VTCmdReadContent = 0x04,
    VTCmdEndRead = 0x05,
    VTCmdLangStartUpdate = 0x0A,
    VTCmdLangUpdateData = 0x0B,
    VTCmdLangEndUpdate = 0x0C,
    VTCmdAppStartUpdate = 0x0D,
    VTCmdAppUpdateData = 0x0E,
    VTCmdAppEndUpdate = 0x0F,
    VTCmdGetInfo = 0x14,
    VTCmdPing = 0x15,
    VTCmdSyncTime = 0x16,
    VTCmdGetRealData = 0x17,
    VTCmdSetFactory = 0x18,
    VTCmdGetRealWave = 0x1B,
    VTCmdGetPPG = 0x1C,
} VTCmd;


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
    VTParamTypeMtSw,
    VTParamTypeMtThr,
    VTParamTypeIvSw,
    VTParamTypeIvThr,
} VTParamType;


#endif /* VTO2Def_h */
