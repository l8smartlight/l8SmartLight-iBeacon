//
//  MainViewController.h
//  iBeaconTest
//
//  Created by Carlos on 30/05/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "l8_sdk_objc.h"
#import "ColorUtils.h"
#import "TIBLECBKeyfob.h"
#import "BluetoothL8.h"

@interface MainViewController : UIViewController<CLLocationManagerDelegate,TIBLECBKeyfobDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *foundLabel;

@property (weak, nonatomic) IBOutlet UISlider *seek;

@property (weak, nonatomic) IBOutlet UILabel *triggerDistance;
@property (weak, nonatomic) IBOutlet UILabel *accuracy;

@property int distance;

@property (nonatomic,strong) NSArray *l8Array;

@end
