//
//  VTO2Communicate.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/28.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "VTO2Def.h"

@class VTFileToRead;
NS_ASSUME_NONNULL_BEGIN

@protocol VTO2CommunicateDelegate <NSObject>

@optional

- (void)serviceDeployed:(BOOL)completed;

/// 300 Disconnected 301 txCharacteristic is nil
- (void)writeDataErrorCode:(int)errorCode;

/// @brief Common command send to peripheral,   callback
/// @param cmdType command for VTCmdSyncTime/VTCmdSetFactory
/// @param result view the enum VTProCommonResult
- (void)commonResponse:(VTCmd)cmdType andResult:(VTCommonResult)result;

/// @brief Send the current progress of reading
/// @param progress progress value
- (void)postCurrentReadProgress:(double)progress;

/// @brief Read file complete
/// @param fileData view model --- VTFileToRead
- (void)readCompleteWithData:(VTFileToRead *)fileData;

/// @brief get information complete . if infoData == nil , an error occurred
/// @param infoData information data nullable
- (void)getInfoWithResultData:(NSData * _Nullable)infoData;

/// @brief use  `parseO2RealObjectWithData` to parse realData.  if realData == nil , an error occurred.
/// @param realData  real data
- (void)realDataCallBackWithData:(NSData * _Nullable)realData;

///
- (void)realDataCallBackWithData:(NSData * _Nullable)realData originalData:(NSData * _Nullable)originalData;

- (void)realWaveCallBackWithData:(NSData * _Nullable)realWave;

- (void)realWaveCallBackWithData:(NSData * _Nullable)realWave originalData:(NSData * _Nullable)originalData;

/// @brief use `` to parse realPPG.  if realPPG == nil , an error occurred.
/// @param realPPG real PPG data
- (void)realPPGCallBackWithData:(NSData * _Nullable)realPPG;

/// @brief read current peripheral's rssi
/// @param RSSI rssi
- (void)updatePeripheralRSSI:(NSNumber *)RSSI;

@end

@interface VTO2Communicate : NSObject

/// @brief This peripheral is currently connected. Need to be set after connection
@property (nonatomic, strong) CBPeripheral *peripheral;

/// @brief current file been read or written
@property (nonatomic, strong) VTFileToRead *curReadFile;

/// @brief time out       ms
@property (nonatomic, assign) u_int timeout;

@property (nonatomic, assign) id<VTO2CommunicateDelegate> _Nullable delegate;

+ (VTO2Communicate *)sharedInstance;

- (void)readRSSI;

/// @brief Get information of peripheral. callback `getInfoWithResultData:`
- (void)beginGetInfo;

/// @brief Get real-time data. callback `realDataCallBackWithData:`
- (void)beginGetRealData;

/// @brief Restore factory. callback `commonResponse: andResult:`
- (void)beginFactory;

/// @brief get real-time waveform data. callback `realWaveCallBackWithData:`
- (void)beginGetRealWave;

/// @brief get PPG data.
- (void)beginGetRealPPG;

/// @brief set params .  all type view struct  `VTParamType`  .  callback `commonResponse: andResult:`
/// @param paramType param type
/// @param paramValue param content/value
- (void)beginToParamType:(VTParamType)paramType content:(NSString *)paramValue;
 
/// @brief Download file from peripheral.   callback `readCompleteWithData:`  & `postCurrentReadProgress:`
/// @param fileName file's name
- (void)beginReadFileWithFileName:(NSString *)fileName;

@end


/// @brief this is a class to describe the completeed current loading or writing file
@interface VTFileToRead : NSObject

@property (nonatomic, assign) NSString *fileName;

@property (nonatomic, assign) u_int fileSize;

@property (nonatomic, assign) u_int totalPkgNum;

@property (nonatomic, assign) u_int curPkgNum;

@property (nonatomic, assign) u_int lastPkgSize;

/// @brief download completed response data .
@property (nonatomic, strong) NSMutableData *fileData;

/// @brief read file result
@property (nonatomic, assign) VTFileLoadResult enLoadResult;



@end


NS_ASSUME_NONNULL_END
