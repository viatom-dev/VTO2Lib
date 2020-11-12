//
//  VTConnectViewController.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/22.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTConnectViewController.h"
#import "VTBLEUtils.h"
#import <VTO2Lib/VTO2Lib.h>

@interface VTConnectViewController ()<UITableViewDelegate, UITableViewDataSource, VTBLEUtilsDelegate, VTO2CommunicateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong) NSMutableArray *deviceIDArray;

@end

@implementation VTConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [VTBLEUtils sharedInstance].delegate = self;
    
}

- (NSMutableArray *)deviceListArray{
    if (!_deviceListArray) {
        _deviceListArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _deviceListArray;
}


#pragma mark --  tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"deviceList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    VTDevice *device = self.deviceListArray[indexPath.row];
    cell.textLabel.text = device.rawPeripheral.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",device.RSSI];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VTDevice *device = self.deviceListArray[indexPath.row];
    [[VTBLEUtils sharedInstance] stopScan];
    [[VTBLEUtils sharedInstance] connectToDevice:device];
}


#pragma mark --  ble

- (void)updateBleState:(VTBLEState)state{
    if (state == VTBLEStatePoweredOn) {
        [[VTBLEUtils sharedInstance] startScan];
    }
}

- (void)didDiscoverDevice:(VTDevice *)device{
    NSUUID *identifier = [device.rawPeripheral identifier];
    if ([_deviceIDArray containsObject:identifier]) {
        NSUInteger index = [_deviceIDArray indexOfObject:identifier];
        [_deviceListArray replaceObjectAtIndex:index withObject:device];
        [_myTableView beginUpdates];
        [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [_myTableView endUpdates];
    }else{
        [_deviceListArray addObject:device];
        [_deviceIDArray addObject:identifier];
        [_myTableView reloadData];
    }
}

- (void)didConnectedDevice:(VTDevice *)device{
    [VTO2Communicate sharedInstance].peripheral = device.rawPeripheral;
    [VTO2Communicate sharedInstance].delegate = self;
}

/// @brief This device has been disconnected. Note: If error == nil ，user manually disconnect.
- (void)didDisconnectedDevice:(VTDevice *)device andError:(NSError *)error{
    
}



- (void)serviceDeployed:(BOOL)completed{
    if (completed) {
        [self showAlertWithTitle:@"Good !!!" message:@"Start work" handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"presentViewController" sender:nil];
        }];
    }else{
        [self showAlertWithTitle:@"The peripheral is not supported !!!" message:@"" handler:^(UIAlertAction *action) {
            [self.deviceListArray removeAllObjects];
            [[VTBLEUtils sharedInstance] startScan];
        }];
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
