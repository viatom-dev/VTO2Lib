//
//  VTMenuViewController.m
//  VTO2Lib
//
//  Created by viatom on 2020/6/29.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTMenuViewController.h"
#import <VTO2Lib/VTO2Lib.h>
#import "VTBLEUtils.h"
#import "VTRealViewController.h"

@interface VTMenuViewController ()<UITableViewDelegate, UITableViewDataSource, VTO2CommunicateDelegate, VTBLEUtilsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSArray *funcArray;
@property (nonatomic, assign) NSInteger funcRow;
@end

@implementation VTMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _funcArray = @[@"Get info",@"Real-time data",@"Real-PPG data",@"Real-Waveform data",@"Reset"];
    [_myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [VTBLEUtils sharedInstance].delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoVTRealViewController"]) {
        VTRealViewController *vc = segue.destinationViewController;
        vc.type = (int)_funcRow;
    }
}

#pragma mark -- tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _funcArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"funcCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _funcArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"gotoVTInfoViewController" sender:nil];
            break;
        case 1:
        {
            _funcRow = 0;
            [self performSegueWithIdentifier:@"gotoVTRealViewController" sender:nil];
            break;
        }
        case 2:
        {
            _funcRow = 1;
            [self performSegueWithIdentifier:@"gotoVTRealViewController" sender:nil];
            break;
        }
        case 3:
        {
            _funcRow = 2;
            [self performSegueWithIdentifier:@"gotoVTRealViewController" sender:nil];
            break;
        }
        case 4:
        {
            [self showAlertWithTitle:@"It will erase all files" message:@"" handler:^(UIAlertAction *action) {
                [VTO2Communicate sharedInstance].delegate = self;
                [[VTO2Communicate sharedInstance] beginFactory];
            }];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- vt communicate

- (void)commonResponse:(VTCmd)cmdType andResult:(VTCommonResult)result{
    if (cmdType == VTCmdSetFactory) {
        // restore factory completed.
    }
}


- (void)serviceDeployed:(BOOL)completed{
    if (completed) {
        [self showAlertWithTitle:@"Good !!!" message:@"Start work" handler:^(UIAlertAction *action) {
          
        }];
    }
}

#pragma mark -- vt ble

- (void)didConnectedDevice:(VTDevice *)device{
    self.title = [NSString stringWithFormat:@"%@ connected", device.rawPeripheral.name];
    [VTO2Communicate sharedInstance].peripheral = device.rawPeripheral;
    [VTO2Communicate sharedInstance].delegate = self;
}

- (void)didDisconnectedDevice:(VTDevice *)device andError:(NSError *)error{
    self.title = [NSString stringWithFormat:@"%@ disconnected", device.rawPeripheral.name];
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
