//
//  VTBLEUtils.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/23.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTBLEUtils.h"

@interface VTBLEUtils ()

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) CBPeripheral *selectedPeripheral;

@end


@implementation VTBLEUtils

static VTBLEUtils *_utils = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _utils = [[super allocWithZone:NULL] init];
        [_utils createBleManager];
    });
    return _utils;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [VTBLEUtils sharedInstance];
}
-(id)copyWithZone:(NSZone *)zone{
    return [VTBLEUtils sharedInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [VTBLEUtils sharedInstance];
}

#pragma mark ----------------------------


- (void)setIsAutoReconnect:(BOOL)isAutoReconnect{
    _isAutoReconnect = isAutoReconnect;
}



#pragma mark ---- private methods ----

- (void)createBleManager{
    _isAutoReconnect = YES;
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (NSArray *)retriveConnectedPeriphral{
    NSArray *ps = [_centralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"14839AC4-7D7E-415C-9A42-167340CF2339"]]];
    return ps;
}

- (VTBLEState)bleState{
    NSInteger state = _centralManager.state;
    return state;
}

- (void)startScan{
    if (_centralManager.state != 5) {
        return;
    }
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
}

- (void)stopScan{
    [_centralManager stopScan];
}

- (void)connectToDevice:(VTDevice *)device{
    if (device) {
        _device = device;
        _selectedPeripheral = device.rawPeripheral;
        [_centralManager connectPeripheral:_selectedPeripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
        [self performSelector:@selector(timeOut) withObject:self afterDelay:5.0f];
    }
}

- (void)cancelConnect{
    if (_selectedPeripheral) {
        [_centralManager cancelPeripheralConnection:_selectedPeripheral];
    }
}

- (void)timeOut{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_centralManager cancelPeripheralConnection:_selectedPeripheral];
}


#pragma mark ---- CBCentralManagerDelegate ----
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSInteger state = central.state;
    if (_delegate && [_delegate respondsToSelector:@selector(updateBleState:)]) {
        [_delegate updateBleState:state];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    VTDevice *device = [[VTDevice alloc] initWithPeripheral:peripheral adv:advertisementData RSSI:RSSI];
    if (!device) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didDiscoverDevice:)]) {
        [_delegate didDiscoverDevice:device];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (_delegate && [_delegate respondsToSelector:@selector(didConnectedDevice:)]) {
        [_delegate didConnectedDevice:_device];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectedDevice:andError:)]) {
        [_delegate didDisconnectedDevice:_device andError:error];
    }
    if (error) {
        DLog(@"failed to connect : %@, (%@)", peripheral, error.localizedDescription);
        if (_isAutoReconnect) {
            [self connectToDevice:_device];
        }
    }else{
        _device = nil;
        _selectedPeripheral = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    DLog(@"failed to connect : %@, (%@)", peripheral, error.localizedDescription);
}


@end
