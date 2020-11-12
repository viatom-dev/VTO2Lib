//
//  VTDevice.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/23.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTDevice.h"

@implementation VTDevice

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral adv:(NSDictionary *)advDic RSSI:(NSNumber *)RSSI{
    self = [super init];
    if (self) {
        self.RSSI = RSSI;
        self.advName = [advDic objectForKey:@"kCBAdvDataLocalName"];
        if (![self.advName isKindOfClass:[NSNull class]] &&
            ![self.advName isEqualToString:@""] &&
            self.advName != nil && 
            ![peripheral.name isEqualToString:self.advName]) {
            [peripheral setValue:self.advName forKey:@"name"];
        }
        self.rawPeripheral = peripheral;
        if (![peripheral.name hasPrefix:@"O2 "] &&
            ![peripheral.name hasPrefix:@"O2BAND "] &&
            ![peripheral.name hasPrefix:@"SleepO2 "] &&
            ![peripheral.name hasPrefix:@"O2Ring "] &&
            ![peripheral.name hasPrefix:@"WearO2 "] &&
            ![peripheral.name hasPrefix:@"SleepU "] &&
            ![peripheral.name hasPrefix:@"Oxylink "] &&
            ![peripheral.name hasPrefix:@"KidsO2 "] &&
            ![peripheral.name hasPrefix:@"BabyO2 "] &&
            ![peripheral.name hasPrefix:@"Oxyfit "] &&
            ![peripheral.name hasPrefix:@"O2M "]) {
            return nil;
        }
    }
    return self;
}

@end
