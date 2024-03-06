//
//  Pulsewave.m
//
//
//  Created by chaos_yang on 2020/7/6.
//  Copyright © 2020 chao. All rights reserved.
//

#import "Pulsewave.h"
@interface Pulsewave (){
    float pointX;
    float pointY;
    int indexX;
    float unitHight;
    float unitWidth;
    int fullScreenPts;
    int refreshPoint;
}
@property (nonatomic, strong) UIView *pulseWaveView;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) NSMutableArray *pointArr;

@property (nonatomic, strong) NSMutableArray *fliterPool;

@property (nonatomic, strong) CAShapeLayer *refreshLayer;

@property (nonatomic, strong) CAShapeLayer *pulseLayer;

@property (nonatomic, assign) CGFloat chartWidth;

@property (nonatomic, assign) BOOL isInitParams;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int dataRate;

@property (nonatomic, assign) BOOL delayIng;



@end
@implementation Pulsewave

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_isInitParams) {
        [self waveInitParams];
        _isInitParams = YES;
    }
    
}

- (void)dealloc {
    _delayIng = NO;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)waveInitParams {
    self.maxValue  = 150;
    self.minValue = 30;
    self.dataRate = 125;
    
    indexX = 0;
    pointX = 0.0;
    self.chartWidth = self.width - 36;
    unitHight = self.height /(self.maxValue-self.minValue);
    // 按照一页6个波计算
    fullScreenPts =  self.dataRate * 6;
    unitWidth = self.chartWidth*1.0/fullScreenPts;
    
    _fliterPool = [NSMutableArray array];
    _pointArr = [NSMutableArray array];

}



- (void)setReceiveArray:(NSArray *)receiveArray {
    [receiveArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.charValue == -100 && idx > 0) {
//            [self.fliterPool addObject:receiveArray[idx-1]];
//        } else if (obj.charValue == -100) {
//
//        } else {
            [self.fliterPool addObject:obj];
//        }
    }];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF != -100"];
    
    
//    _allowAddPoints = NO;
//    NSArray *tempArr = [receiveArray filteredArrayUsingPredicate:pred];
//    [_fliterPool addObjectsFromArray:tempArr];
//    [self startGCDTimer];
    if (!_delayIng) {
        _delayIng = YES;
        [self delayToRefresh];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (!newSuperview) {
        _delayIng = NO;
        [self stopGCDTimer];
    }
    
    [super willMoveToSuperview:newSuperview];
}


- (void)startGCDTimer {
    if (_timer) return;
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0/30 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf refreshWave];
        });
    });
    dispatch_resume(_timer);//启动/恢复计时器
}

- (void)stopGCDTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}



- (int)handleRefreshPoint:(NSInteger)fliterPoolCount {
    if (fliterPoolCount > self.dataRate) {
        return self.dataRate / 30 + (fliterPoolCount - self.dataRate);
    } else if (fliterPoolCount > self.dataRate * 0.5) {
        return self.dataRate / 28;
    }
    return self.dataRate / 30;
}

- (void)delayToRefresh {
    if (!_delayIng) return;
    CGFloat sec = 0;
    if (_fliterPool.count > 250) {
        sec = 0.03;
    } else if (_fliterPool.count > 150) {
        sec = 0.035;
    } else if (_fliterPool.count > 75) {
        sec = 0.04;
    } else {
        sec = 0.045;
    }
    [self refreshWave];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delayToRefresh];
    });
}

- (void)refreshWave{
    NSMutableArray *tempArr = [NSMutableArray array];
//    refreshPoint = [self handleRefreshPoint:_fliterPool.count];
    refreshPoint = 5;
//    NSLog(@"%@", _fliterPool);
    if (_fliterPool.count >= refreshPoint) {
        [tempArr addObjectsFromArray:[_fliterPool subarrayWithRange:NSMakeRange(0, refreshPoint)]];
        [_fliterPool removeObjectsInRange:NSMakeRange(0, refreshPoint)];
    } else if (_fliterPool.count != 0) {
        refreshPoint = _fliterPool.count;
        [tempArr addObjectsFromArray:_fliterPool];
        [_fliterPool removeAllObjects];
    }
   
    // 正常状态下， 过滤池点数不能清0， 否则会造成尖刺
//   NSLog(@"刷新点数为:%d,剩余脉搏波点数:%d", refreshPoint, _fliterPool.count);
    
    
    if (tempArr.count >= refreshPoint) {
        NSInteger diff = _pointArr.count + refreshPoint - fullScreenPts;
        if (diff > 0) {
            NSInteger k = fullScreenPts - _pointArr.count;
            [_pointArr addObjectsFromArray:[tempArr subarrayWithRange:NSMakeRange(0, k)]];
            for (int i = 0; i < diff; i ++) {
                NSNumber *num = [tempArr objectAtIndex:i + k];
                [_pointArr replaceObjectAtIndex:indexX withObject:num];
                indexX ++ ;
                if (indexX >= fullScreenPts) {
                    indexX = 0;
                }
            }
        } else {
            
            indexX = 0;
            [_pointArr addObjectsFromArray:tempArr];
            
        }
    }
    [self drawRealWaveRefresh];    //取到*个点 重绘一次
}


- (void)drawRealWaveRefresh{
    CGMutablePathRef pathA = CGPathCreateMutable();
    CGMutablePathRef pathB = CGPathCreateMutable();
    BOOL isVailed = YES;
    BOOL isFirst = YES;
    BOOL isFull = _pointArr.count == fullScreenPts;
    float verticalGird = self.height;
    float preY = verticalGird*0.5;
    for (int i = 0; i < _pointArr.count; i ++) {
        if (isFull && (i < indexX + 10 && i >= indexX)) {
            isVailed = NO; continue;
        }
        CGFloat x = i * unitWidth;
        NSNumber *val = _pointArr[i];
        if (val.charValue == -100) { // pulse beat
            
            CGPathMoveToPoint(pathB, nil, x, preY + verticalGird*0.2);
            CGPathAddLineToPoint(pathB , nil, x, preY - verticalGird*0.2);
            
            
        } else {
            
            CGFloat y = verticalGird -  ((200 - val.unsignedCharValue) - self.minValue)*unitHight;
            if (isFirst || !isVailed) {
                isFirst = NO;
                if (!isVailed) isVailed = YES;
                CGPathMoveToPoint(pathA, nil, x, y);
            } else {
                CGPathAddLineToPoint(pathA, nil, x, y);
            }
            preY = y;
            if (indexX >= 1 && i == indexX -1) {
                self.pulseWaveView.frame = CGRectMake(self.chartWidth+20, y, 16, self.height-y);
            } else if (indexX == 0 && i == _pointArr.count - 1) {
                self.pulseWaveView.frame = CGRectMake(self.chartWidth+20, y, 16, self.height-y);
            }
            
        }
        
    }
    
    self.refreshLayer.path = pathA;
    self.pulseLayer.path = pathB;
    CGPathRelease(pathA);
    CGPathRelease(pathB);
}

- (CGPoint)transferOriginalPointToNewPointWith:(CGPoint)point {
    CGPoint newPoint;
    newPoint.x = point.x;
    float verticalGird = self.height;
    newPoint.y = verticalGird - (point.y-self.minValue)*unitHight;    // point.y  mV值
    return newPoint;
}

-(void)resetWave{
    _delayIng = NO;
    indexX = 0;
    [_fliterPool removeAllObjects];
    [_pointArr removeAllObjects];
    [self stopGCDTimer];
    [_refreshLayer removeFromSuperlayer];
    _refreshLayer = nil;
    _pulseWaveView.frame = CGRectMake(self.chartWidth+20, 0, 16, 0);
    [_pulseLayer removeFromSuperlayer];
    _pulseLayer = nil;
   
}

- (CAShapeLayer *)refreshLayer{
    if (!_refreshLayer && self.height > 0) {
        _refreshLayer = [CAShapeLayer layer];
        _refreshLayer.strokeColor = [UIColor grayColor].CGColor;
        _refreshLayer.fillColor = [UIColor clearColor].CGColor;
        _refreshLayer.frame = CGRectMake(0, 0, self.width, self.height);
        _refreshLayer.lineWidth = 0.8;
        _refreshLayer.masksToBounds = YES;
        [self.layer addSublayer:_refreshLayer];
    }
    return _refreshLayer;
}

- (CAShapeLayer *)pulseLayer {
    if (!_pulseLayer && self.height > 0) {
        _pulseLayer = [CAShapeLayer layer];
        _pulseLayer.strokeColor = [UIColor greenColor].CGColor;
        _pulseLayer.fillColor = [UIColor clearColor].CGColor;
        _pulseLayer.frame = CGRectMake(0, 0, self.width, self.height);
        _pulseLayer.lineWidth = 0.8;
        _pulseLayer.masksToBounds = YES;
        [self.layer addSublayer:_pulseLayer];
    }
    return _pulseLayer;
}

- (UIView *)pulseWaveView{
    if (!_pulseWaveView) {
        _pulseWaveView = [[UIView alloc]initWithFrame:CGRectMake(self.chartWidth+ 20, 0, 16, 0)];
        _pulseWaveView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:1.0];
        [self addSubview:_pulseWaveView];
    }
    return _pulseWaveView;
}
@end
