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

#import "VTDataDetailViewController.h"

@interface VTInfoViewController ()<UITableViewDelegate, UITableViewDataSource, VTO2CommunicateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fileListArray;
@property (nonatomic, strong) NSMutableArray *availableSetParamArray;
@property (nonatomic, strong) VTO2Info *info;
@property (nonatomic, strong) VTO2Object *o2Obj;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VTInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [VTO2Communicate sharedInstance].delegate = self;
    [[VTO2Communicate sharedInstance] beginGetInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readFirstFile:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopReadFile:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [VTO2Communicate sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ---  system notification task

- (void)readFirstFile:(NSNotification *)notification {
    if (_fileListArray.count == 0) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        NSString *fileName = self.fileListArray.firstObject;
        DLog(@"begin read file: %@", fileName);
        [[VTO2Communicate sharedInstance] beginReadFileWithFileName:fileName];
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopReadFile:(NSNotification *)notification {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark ---  tableView delegate & datasource

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
                /*
                 * For BabyO2 80%~96% (step:+2)
                 * For others 80%~95% (step:+1)
                 */
                content = @"82%";
            }
                break;
            case VTParamTypeMotor:
            {
                /*
                 * 0~100 intensity of vibration
                 */
                content = @"40";
            }
                break;
            case VTParamTypePedtar:
            {
                /*
                 * support for O2.
                 */
                content = @"1000";
            }
                break;
            case VTParamTypeLightingMode:
            {
                /*
                 * 0-Standard, 1-Always off, 2-Always on.
                 */
                content = @"0";
            }
                break;
            case VTParamTypeHeartRateSwitch:
            {
                /*
                 @brief For O2M.  bit[0] vibrate; bit[1] sound.
                 0 vibrate & sound close
                 1 vibrate open, sound close
                 2 vibrate close, sound open
                 3 vibrate & sound open
                 @brief For others
                 0 close
                 1 open
                 */
                content = @"1";
            }
                break;
            case VTParamTypeHeartRateLowThr:
            {
                /*
                 For O2Ring&Oxylink     30~70  (step: +5)
                 For Others             40~70  (step: +5)
                 */
                content = @"40";
            }
                break;
            case VTParamTypeHeartRateHighThr:
            {
                /*
                 For O2Ring&Oxylink     70~200  (step: +5)
                 For Oxyfit             100~200 (step: +10)
                 For Others             90~200  (step: +5)
                 */
                content = @"120";
            }
                break;
            case VTParamTypeLightStrength:
            {
                /*
                 * 2-High    1-Medium     0-Low
                 */
                content = @"2";
            }
                break;
            case VTParamTypeOxiSwitch:
            {
                /*
                 /// @brief For O2M.  bit[0] vibrate; bit[1] sound.
                 0 vibrate & sound close
                 1 vibrate open, sound close
                 2 vibrate close, sound open
                 3 vibrate & sound open
                 /// @brief For others
                 0 close
                 1 open
                 */
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
            if ([[VTO2Communicate sharedInstance].peripheral.name hasPrefix:@"O2M "]) {
                NSString *vibrateSwi = [NSString stringWithFormat:@"%d", [_info.hrSwitch intValue]&0x01];
                NSString *soundSwi = [NSString stringWithFormat:@"%d", ([_info.hrSwitch intValue] >> 1)&0x01];
                [_availableSetParamArray addObject:@[@"Pulse rate reminder by vibration", vibrateSwi, @(VTParamTypeHeartRateSwitch)]];
                [_availableSetParamArray addObject:@[@"Pulse rate reminder by sound", soundSwi, @(VTParamTypeHeartRateSwitch)]];
            }else{
                [_availableSetParamArray addObject:@[@"Heart rate switch", _info.hrSwitch, @(VTParamTypeHeartRateSwitch)]];
            }
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
            if ([[VTO2Communicate sharedInstance].peripheral.name hasPrefix:@"O2M "]) {
                NSString *vibrateSwi = [NSString stringWithFormat:@"%d", [_info.oxiSwitch intValue]&0x01];
                NSString *soundSwi = [NSString stringWithFormat:@"%d", ([_info.oxiSwitch intValue] >> 1)&0x01];
                [_availableSetParamArray addObject:@[@"Oxygen reminder by vibration", vibrateSwi, @(VTParamTypeOxiSwitch)]];
                [_availableSetParamArray addObject:@[@"Oxygen reminder by sound", soundSwi, @(VTParamTypeOxiSwitch)]];
            }else{
                [_availableSetParamArray addObject:@[@"Oxygen switch", _info.oxiSwitch, @(VTParamTypeOxiSwitch)]];
            }
            
        }
        [self.tableView reloadData];
    }
}

- (void)postCurrentReadProgress:(double)progress{
    DLog(@"Downloading: %.2f%%", progress*100);
    [SVProgressHUD showProgress:progress];
}

- (void)readCompleteWithData:(VTFileToRead *)fileData{
    if (fileData.enLoadResult == VTFileLoadResultSuccess) {
        DLog(@"Download file success.");
        _o2Obj = [VTO2Parser parseO2ObjectWithData:fileData.fileData];
//        [self performSegueWithIdentifier:@"gotoVTDataDetailViewController" sender:nil];
        
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoVTDataDetailViewController"]) {
        VTDataDetailViewController *vc = segue.destinationViewController;
        vc.o2Obj = _o2Obj;
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
