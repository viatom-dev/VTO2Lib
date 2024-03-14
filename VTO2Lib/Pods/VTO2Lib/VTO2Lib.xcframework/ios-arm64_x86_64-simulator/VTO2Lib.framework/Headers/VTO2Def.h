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
    VTCmdGetStationInfo = 0x1D,
} VTCmd;


#pragma mark - peripheral information's params
// Supported parameters refer to protocol documentation
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
    VTParamTypeSpO2Sw,
} VTParamType;


#pragma mark - station babyo2 s2

typedef struct {
    u_char len; //SN长度(小于18)  e.g. 10
    u_char serial_num[18]; //SN号
} VTO2StationSN;

typedef struct{
    u_char hw_version;  //硬件版本    e.g. ‘A’ : A版
    u_int  fw_version;   //固件版本    e.g. 0x010100 : V1.1.0
    u_int  bl_version; //引导版本    e.g. 0x010100 : V1.1.0
    u_char branch_code[8]; //Branch编码 e.g. “40020000” : Ezcardio Plus
    u_char reserved0[3]; //预留
    u_short device_type; //设备类型    e.g. 0x8611: 血压计
    u_short protocol_version; //协议版本    e.g.0x0100:V1.0
    u_char cur_time[7]; //时间    e.g.0xE1070301090000:2017-03-01 09:00:00
    u_short protocol_data_max_len; //通信协议支持的最大数据长度
    u_char reserved1[4]; //预留
    VTO2StationSN sn;
    u_char reserved2[1]; //预留
} VTO2StationInfo;


#endif /* VTO2Def_h */
