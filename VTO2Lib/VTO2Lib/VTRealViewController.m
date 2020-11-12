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

@interface VTRealViewController ()<VTO2CommunicateDelegate>

@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, copy) NSArray *array;

@property (nonatomic) VTBLEUtils *deviceCom;

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
    }else{
        self.title = @"Real-PPG data";
        [self readRealPPGData];
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

- (UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _descLab.numberOfLines = 0;
        _descLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_descLab];
    }
    return _descLab;
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

@end
