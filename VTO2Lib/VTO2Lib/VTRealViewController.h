//
//  VTRealViewController.h
//  VTO2Lib
//
//  Created by viatom on 2020/6/29.
//  Copyright © 2020 viatom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTRealViewController : UIViewController

@property (nonatomic, assign) int type;   // 0 real-data  1  real-ppg 2 real-waveform 3. real-params

@end

NS_ASSUME_NONNULL_END
