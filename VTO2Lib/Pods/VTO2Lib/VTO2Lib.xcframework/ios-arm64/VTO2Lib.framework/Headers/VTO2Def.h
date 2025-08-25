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

typedef enum : u_char {
    VTA5CmdMakeSend = 0x10,
    VTA5CmdRealParams = 0x11,
    VTA5CmdRealWave = 0x12,
    VTA5CmdRealPPG = 0x13,
    VTA5CmdRealACC = 0x14,
    VTA5CmdOpenupEncryption = 0xFF,
} VTA5Cmd;

typedef enum : u_char {
    VTBabyS3CmdRunParams = 0x02,
} VTBabyS3Cmd;

typedef enum : u_char {
    VTA5RespRequest = 0x00,            ///< request
    VTA5RespNormal = 0x01,             ///< normal
    VTA5RespNotFound = 0xE0,           ///< not found file
    VTA5RespOpenFailed = 0xE1,         ///< open file failed
    VTA5RespReadFailed = 0xE2,         ///< read file failed
    VTA5RespWriteFailed = 0xE3,        ///< write file failed
    VTA5RespReadFileListFailed = 0xF1, ///< read file's list failed
    VTA5RespDeviceOccupied = 0xFB,     ///< device occupied, e.g. use occupied
    VTA5RespFormatError = 0xFC,
    VTA5RespFormatUnsupport = 0xFD,
    VTA5RespCommonError = 0xFF,
    VTA5RespHeadError = 0xCC,
    VTA5RespCRCError = 0xCD,
} VTA5RespRes;


typedef enum : u_char{
    CHANNAL_SPO2_PR = 0,                //SpO2 + PR
    CHANNEL_SPO2_PR_MOTION,             //SpO2 + PR + Motion
} VTSleepO2Channel_t;


#pragma mark - peripheral information's params
// Supported parameters refer to protocol documentation
typedef enum : NSUInteger {
    VTParamTypeDate,                // Date
    VTParamTypeOxiThr,              // threshold of spo2
    VTParamTypeMotor,               // vibrate motor. View Readme.md
    VTParamTypePedtar,              // pedter,
    VTParamTypeLightingMode,        // 0：normal，1：always off，2：always on
    VTParamTypeHeartRateSwitch,     // switch 0 - off 1 - on
    VTParamTypeHeartRateLowThr,     // threshold. View Readme.md
    VTParamTypeHeartRateHighThr,    // threshold. View Readme.md
    VTParamTypeLightStrength,       // lightness. 0-2
    VTParamTypeOxiSwitch,           // switch 0 - off 1 - on
    VTParamTypeBuzzer,              // Buzzer. 0、20、40、80、100
    VTParamTypeMtSw,                // switch 0 - off 1 - on
    VTParamTypeMtThr,               // Motion thershold.  0-255
    VTParamTypeIvSw,                // switch 0 - off 1 - on
    VTParamTypeIvThr,               // invalid value threshold.
    VTParamTypeSpO2Sw,              // switch 0 - off 1 - on
} VTParamType;


#pragma mark - station babyo2 s2

typedef struct {
    u_char len;                     // serial numbers length  e.g. 10
    u_char serial_num[18];          // serial numbers
} VTO2StationSN;

typedef struct{
    u_char hw_version;              // hardware version    e.g. ‘A’ : A
    u_int  fw_version;              // firmware version    e.g. 0x010100 : V1.1.0
    u_int  bl_version;              // bootloader version    e.g. 0x010100 : V1.1.0
    u_char branch_code[8];          // branchcode e.g. “40020000” : Ezcardio Plus
    u_char reserved0[3];            // reserved
    u_short device_type;            // device type   e.g. 0x8611
    u_short protocol_version;       // protocal version   e.g.0x0100:V1.0
    u_char cur_time[7];             // current time    e.g.0xE1070301090000:2017-03-01 09:00:00
    u_short protocol_data_max_len;  // max length
    u_char reserved1[4];            // reserved
    VTO2StationSN sn;
    u_char reserved2[1];            // reserved
} VTO2StationInfo;


#pragma pack (1)
typedef struct{
    uint32_t    record_time;        ///< duration    unit: second    暂无使用
    uint8_t     run_state;          ///< run state  0: prepare 1: prepare to measure  2: measuring 3: end
    uint8_t     sensor_state;       ///< sensor state 0: normal 1: finger out 2: SENSOR_STA_PROBE_OUT 3:  error
    uint8_t     spo2;
    uint8_t     pi;                 ///< PI *10 e.g.  15 : PI = 1.5
    uint16_t    pr;
    uint8_t     flag;               ///< bit0: Pulse mark
    uint8_t     motion;
    uint8_t     battery_state;      ///< battery state    0: normal  1: charging  2: charge full 3: low
    uint8_t     battery_percent;    ///< battery percent
    uint8_t     reserved[6];
} VTParameters;

typedef struct {
    uint32_t index;            //波形数据第一个点相对于起始点的编号 暂无使用
    uint16_t sampling_num;                //波形数据采样点
    uint8_t *waveform_data;    //125Hz波形数据
} VTA5Wave;


typedef struct {
    short ir;
    short red;
} VTA5PPG;

typedef struct {
    uint16_t sampling_num;
    VTA5PPG *raw_data;
} VTA5Raw;

typedef struct {
    int16_t x;
    int16_t y;
    int16_t z;
} VTA5Axis;


typedef struct {
    uint16_t sampling_num;
    VTA5Axis *data;
} VTA5Acc;


typedef struct {
    uint8_t quiet;
    uint8_t state;
    uint8_t reserved[10];
} VTO2SleepState;

typedef struct {
    uint32_t start_timestamp;       // 首次入睡时间，若未入睡为0
    uint32_t end_timestamp;         // 最后一次出睡时间，睡眠时为当前时间
    uint32_t awake_duration;        // 清醒时长
    uint32_t deep_duration;         // 深睡时长
    uint32_t light_duration;        // 浅睡时长
    uint32_t total_duration;        // 总睡眠时长
    uint8_t wake_count;             // 清醒次数，大于250不再做统计
    uint8_t reserved[15];
} VTO2SleepReport;

typedef struct {
    VTO2SleepReport report;         // 当前报告
    VTO2SleepState  state;          // 当前状态
} VTO2SleepRTInfo;

typedef struct {
    uint32_t record_time;           // 已记录时长    单位:second    暂无使用
    uint8_t run_status;             // 运行状态 0:准备阶段 1:测量准备阶段 2:测量中 3:测量结束
    uint8_t sensor_state;           // 传感器状态 0:脱落或者拔出或者故障 1:正常测量状态
    uint8_t spo2;
    uint8_t pi;                     // PI值*10 e.g.  15 : PI = 1.5
    uint16_t pr;
    uint8_t flag;                   // 标志参数 bit0:脉搏音标志
    uint8_t motion;                 // 体动
    uint8_t battery_state;          // 电池状态 e.g.   0:正常使用 1:充电中 2:充满 3:低电量
    uint8_t battery_percent;        // 电池状态 e.g.    电池电量百分比
    uint8_t alram_state;
    uint8_t reserved[13];
    VTO2SleepRTInfo sleep_info;
} VTO2SleepRunParams;



typedef struct {
    unsigned char file_version;        //文件版本 e.g.  0x01 :  V1
    unsigned char operation_mode;            //血氧数据文件 0x03
    unsigned short year;
    unsigned char month;
    unsigned char day;
    unsigned char hour;
    unsigned char minute;
    unsigned char second;
    unsigned int size;
} VTO2FileHead_t;

typedef struct {
    unsigned char spo2;
    unsigned char pr;
    unsigned char motion:6;            //16 = 1g
    unsigned char remind_hr:1;
    unsigned char remind_spo2:1;
    unsigned char quiet:4;        //安静值
    unsigned char sleep_state:4;    //睡眠状态
} VTO2SleepPointData_t;


typedef struct {        //16字节
    unsigned short record_time;             // 记录时长
    unsigned short asleep_time;                //睡着时间
    unsigned char average_spo2;                //平均血氧
    unsigned char lowest_spo2;                //最低血氧
    unsigned char _3percent_drops;            //3%drops
    unsigned char _4percent_drops;            //4%drops
    unsigned short _90percent_duration;        // 90%持续时间
    unsigned char _90percent_drops;            // 90%跌落次数
    unsigned char  T90;                        //T90        <90%占总时间百分比
    unsigned char O2_score;                //O2得分
    unsigned int step_counter;                //计步结果
    unsigned short average_hr;                //平均心率
    unsigned char reserved[8];
 } VTO2SleepAnalysisResult;

typedef struct {        // 8个字节
    VTO2SleepAnalysisResult result; // 16 bytes
    VTO2SleepReport sleep; // 40 bytes
} VTO2SleepFileTail_t;


#pragma pack()


#endif /* VTO2Def_h */
