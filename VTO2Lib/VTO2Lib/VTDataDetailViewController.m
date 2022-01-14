//
//  VTDataDetailViewController.m
//  VTO2Lib
//
//  Created by yangweichao on 2022/1/14.
//  Copyright © 2022 viatom. All rights reserved.
//

#import "VTDataDetailViewController.h"
#import <VTO2Lib/VTO2Lib.h>

@interface VTDataDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation VTDataDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d%02d", _o2Obj.year, _o2Obj.month, _o2Obj.day, _o2Obj.hour, _o2Obj.minute, _o2Obj.second];
    _contentLabel.text = _o2Obj.description;
    NSArray *array = [VTO2Parser parseO2WaveObjectArrayWithWaveData:_o2Obj.waveData];
    DLog(@"wave points : %lu", (unsigned long)array.count);
    
}


- (void)setO2Obj:(VTO2Object *)o2Obj{
    _o2Obj = o2Obj;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
