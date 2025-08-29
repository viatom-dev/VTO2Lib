//
//  VTRealViewController.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/29.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTRealViewController.h"
#import <VTO2Lib/VTO2Lib.h>
#import "VTBLEUtils.h"
#import "Pulsewave.h"

@interface VTRealViewController ()<VTO2CommunicateDelegate, VTO2A5RespDelegate>

@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, copy) NSArray *array;

@property (nonatomic) VTBLEUtils *deviceCom;

@property (nonatomic, weak) Pulsewave *wave;

@end

@implementation VTRealViewController
{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [VTO2Communicate sharedInstance].delegate = self;
    _deviceCom = [[VTBLEUtils alloc] init];
    if (_type == 0) {
        self.title = @"Real-time data";
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(readRealtimeData) userInfo:nil repeats:YES];
    } else if (_type == 1) {
        self.title = @"Real-PPG data";
        [self readRealPPGData];
    }  else if (_type == 2) {
        self.title = @"Real-Wave data";
        self.descLab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.5);
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(readRealWaveData) userInfo:nil repeats:YES];
    }  else if (_type == 3) {
        self.title = @"Real-Params data";
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [VTO2Communicate sharedInstance].a5Delegate = self;
//            [[VTO2Communicate sharedInstance] babyo2s3_requestRunParams];
//        }];
        self.descLab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.5);
        [VTO2Communicate sharedInstance].a5Delegate = self;
        [[VTO2Communicate sharedInstance] observeParameters:YES waveform:NO rawdata:NO accdata:NO];
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [VTO2Communicate sharedInstance].delegate = nil;
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)setType:(int)type{
    _type = type;
}

- (void)readRealtimeData{
    [[VTO2Communicate sharedInstance] beginGetRealData];
}

- (void)readRealPPGData{
    [[VTO2Communicate sharedInstance] beginGetRealPPG];
}

- (void)readRealWaveData{
    [[VTO2Communicate sharedInstance] beginGetRealWave];
}

- (UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _descLab.numberOfLines = 0;
        _descLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_descLab];
    }
    return _descLab;
}

- (Pulsewave *)wave {
    if (!_wave) {
        Pulsewave *wave = [[Pulsewave alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.descLab.frame), CGRectGetWidth(self.descLab.frame), CGRectGetHeight(self.descLab.frame) - 80)];
        [self.view addSubview:wave];
        _wave = wave;
    }
    return _wave;
}

#pragma mark -- vt

- (void)realDataCallBackWithData:(NSData *)realData{
    if (realData == nil) {
        DLog(@"error");
        return;
    }
    VTRealObject *rObj = [VTO2Parser parseO2RealObjectWithData:realData];
    self.descLab.text = [rObj description];
}


- (void)realPPGCallBackWithData:(NSData *)realPPG{
    [self readRealPPGData];
    if (realPPG == nil) {
        DLog(@"error");
        return;
    }
    NSArray *ppgArr = [VTO2Parser parseO2RealPPGWithData:realPPG];
    
    
    
}


- (void)realWaveCallBackWithData:(NSData *)realWave {
    if (realWave == nil) {
        DLog(@"error");
        return;
    }
    VTRealWave *rObj = [VTO2Parser parseO2RealWaveWithData:realWave];
    self.descLab.text = [rObj description];
    
    DLog(@"points: %@", rObj.points);
    DLog(@"filter points: %@", [rObj filterPointsWithPulseMark:PulseMarkOther]);
    
    self.wave.receiveArray = rObj.points;
}


- (void)a5_realRunParams:(VTO2SleepRunParams)params {
//    NSLog(@"current spo2 : %d ~ %d ~ %d", params.spo2, params.pr, params.pi);
    self.descLab.text = [NSString stringWithFormat:@"spo2: %d ~ pr: %d ~ pi: %d", params.spo2, params.pr, params.pi];
}

-  (void)a5_realWave:(VTA5Wave)wave {
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:wave.sampling_num];
    for (int i = 0; i < wave.sampling_num; i++) {
        uint8_t point = wave.waveform_data[i];
        [arrM addObject:@(point)];
    }
    
    self.wave.receiveArray = arrM;
}


@end
