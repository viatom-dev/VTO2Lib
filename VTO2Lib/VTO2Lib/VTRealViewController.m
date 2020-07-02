//
//  VTRealViewController.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/29.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTRealViewController.h"
#import <VTO2Lib/VTO2Lib.h>

@interface VTRealViewController ()<VTO2CommunicateDelegate>

@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, copy) NSArray *array;

@end

@implementation VTRealViewController
{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [VTO2Communicate sharedInstance].delegate = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(readRealtimeData) userInfo:nil repeats:YES];
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)readRealtimeData{
    [[VTO2Communicate sharedInstance] beginGetRealData];
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
    VTRealObject *rObj = [VTO2Parser parseO2RealObjectWithData:realData];
    self.descLab.text = [rObj description];
}


@end
