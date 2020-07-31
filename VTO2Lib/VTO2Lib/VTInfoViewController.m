//
//  VTInfoViewController.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/29.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTInfoViewController.h"
#import <VTO2Lib/VTO2Lib.h>
#import "SVProgressHUD.h"

@interface VTInfoViewController ()<UITableViewDelegate, UITableViewDataSource, VTO2CommunicateDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fileListArray;
@property (nonatomic, strong) NSMutableArray *availableSetParamArray;
@property (nonatomic, strong) VTO2Info *info;

@end

@implementation VTInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [VTO2Communicate sharedInstance].delegate = self;
    [[VTO2Communicate sharedInstance] beginGetInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [VTO2Communicate sharedInstance].delegate = nil;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.fileListArray.count;
    }else{
        return self.availableSetParamArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"fileListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        NSString *fileName = _fileListArray[indexPath.row];
        cell.textLabel.text = fileName;
    }else{
        NSArray *subArray = _availableSetParamArray[indexPath.row];
        cell.textLabel.text = subArray.firstObject;
        cell.detailTextLabel.text = subArray[1];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"File list that can be download";
    }else{
        return @"Parameters that can be set";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *fileName = _fileListArray[indexPath.row];
        [SVProgressHUD showProgress:0];
        [[VTO2Communicate sharedInstance] beginReadFileWithFileName:fileName];
    }else{
        NSArray *subArray = _availableSetParamArray[indexPath.row];
        VTParamType type = [subArray.lastObject intValue];
        NSString * content = @"";
        /*
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
         */
        switch (type) {
            case VTParamTypeDate:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd,HH:mm:ss"];
                [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                [dateFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
                content = [dateFormatter stringFromDate:[NSDate date]];
            }
                break;
            case VTParamTypeOxiThr:
            {
                content = @"82%";
            }
                break;
            case VTParamTypeMotor:
            {
                if ([[VTO2Communicate sharedInstance].peripheral.name hasPrefix:@"WearO2"]) {
                    content = @"35";
                }else{
                    content = @"40";
                }
            }
                break;
            case VTParamTypePedtar:
            {
                content = @"1000";
            }
                break;
            case VTParamTypeLightingMode:
            {
                content = @"0";
            }
                break;
            case VTParamTypeHeartRateSwitch:
            {
                content = @"1";  // open
            }
                break;
            case VTParamTypeHeartRateLowThr:
            {
                content = @"40";
            }
                break;
            case VTParamTypeHeartRateHighThr:
            {
                content = @"120";
            }
                break;
            case VTParamTypeLightStrength:
            {
                content = @"2";
            }
                break;
            case VTParamTypeOxiSwitch:
            {
                content = @"1";
            }
                break;
            default:
                break;
        }
        [SVProgressHUD show];
        [[VTO2Communicate sharedInstance] beginToParamType:type content:content];
    }
}


#pragma mark -- vt

- (void)getInfoWithResultData:(NSData *)infoData{
    if (infoData) {
        _fileListArray = [NSMutableArray arrayWithCapacity:10];
        _availableSetParamArray = [NSMutableArray arrayWithCapacity:10];
        [SVProgressHUD dismiss];
        _info = [VTO2Parser parseO2InfoWithData:infoData];
        DLog(@"%@",_info.description);
        /*
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
         } VTParamType;
         */
        NSArray *fileList = [_info.fileList componentsSeparatedByString:@","];
        [_fileListArray addObjectsFromArray:fileList];
        [_fileListArray removeObject:fileList.lastObject];
        
        if (_info.curDate != nil) {
            [_availableSetParamArray addObject:@[@"Date", _info.curDate, @(VTParamTypeDate)]];
        }
        if (_info.curOxiThr != nil) {
            [_availableSetParamArray addObject:@[@"Oxygen threshold", _info.curOxiThr, @(VTParamTypeOxiThr)]];
        }
        if (_info.curMotor != nil) {
            [_availableSetParamArray addObject:@[@"Motor", _info.curMotor, @(VTParamTypeMotor)]];
        }
        if (_info.curPedThr != nil) {
            [_availableSetParamArray addObject:@[@"Pedometer goal", _info.curPedThr, @(VTParamTypePedtar)]];
        }
        if (_info.lightingMode != nil) {
            [_availableSetParamArray addObject:@[@"Lighting mode", _info.lightingMode, @(VTParamTypeLightingMode)]];
        }
        if (_info.hrSwitch != nil) {
            [_availableSetParamArray addObject:@[@"Heart rate switch", _info.hrSwitch, @(VTParamTypeHeartRateSwitch)]];
        }
        if (_info.hrLowThr != nil) {
            [_availableSetParamArray addObject:@[@"Low heart rate threshold", _info.hrLowThr, @(VTParamTypeHeartRateLowThr)]];
        }
        if (_info.hrHighThr != nil) {
            [_availableSetParamArray addObject:@[@"High heart rate threshold", _info.hrHighThr, @(VTParamTypeHeartRateHighThr)]];
        }
        if (_info.lightStrength != nil) {
            [_availableSetParamArray addObject:@[@"Light strength", _info.lightStrength, @(VTParamTypeLightStrength)]];
        }
        if (_info.oxiSwitch != nil) {
            [_availableSetParamArray addObject:@[@"Oxygen switch", _info.oxiSwitch, @(VTParamTypeOxiSwitch)]];
        }
        [self.tableView reloadData];
    }
}

- (void)postCurrentReadProgress:(double)progress{
    [SVProgressHUD showProgress:progress];
}

- (void)readCompleteWithData:(VTFileToRead *)fileData{
    if (fileData.enLoadResult == VTFileLoadResultSuccess) {
        DLog(@"Download file success.");
        NSArray *array = [VTO2Parser parseO2WaveObjectArrayWithWaveData:fileData.fileData];
        DLog(@"wave points : %lu", (unsigned long)array.count);
    }else{
        DLog(@"Download file error : %lu", (unsigned long)fileData.enLoadResult);
    }
    [SVProgressHUD dismiss];
}

- (void)commonResponse:(VTCmdType)cmdType andResult:(VTCommonResult)result{
    if (cmdType == VTCmdTypeSyncParam) {
        if (result == VTCommonResultSuccess) {
            [self showAlertWithTitle:@"Sync success" message:nil handler:^(UIAlertAction *action) {
                [[VTO2Communicate sharedInstance] beginGetInfo];
            }];
        }else{
            [self showAlertWithTitle:@"Sync error" message:nil handler:nil];
            [SVProgressHUD dismiss];
        }
    }
}

#pragma mark --

- (void)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
                   handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handler];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
