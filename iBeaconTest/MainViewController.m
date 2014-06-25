//
//  MainViewController.m
//  iBeaconTest
//
//  Created by Carlos on 30/05/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "l8_sdk_objc.h"
#import "ColorUtils.h"
#import "TIBLECBKeyfob.h"
#import "BluetoothL8.h"

@interface MainViewController ()

@property (nonatomic,strong) TIBLECBKeyfob *t;

@property bool connected;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [self.t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    self.t.delegate = self;
    
    [super viewDidLoad];
   

    self.distance = roundl(self.seek.value);
    self.triggerDistance.text = [NSString stringWithFormat:@"%i m",self.distance];
    self.connected = false;
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
   
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"86A8B69C-8792-49C9-B5D7-D579AD9A4982"];
    
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"region1"];
    
    self.myBeaconRegion.notifyEntryStateOnDisplay = YES;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
   // [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
  //  [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    NSLog(@"Enter region");
    // Beacon found!

}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
  //  [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
 //   self.statusLabel.text = @"Out of range";
    NSLog(@"Exit region");
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
  //  self.statusLabel.text = @"Beacon found!";
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
    // You can retrieve the beacon data from its properties
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
    
    if(uuid !=nil && major!=nil && minor!=nil){
         self.statusLabel.text = @"Beacon found!";
    }else{
        self.statusLabel.text = @"Out of range!";
    }
    
    if(foundBeacon.accuracy>=0){
    self.accuracy.text = [NSString stringWithFormat:@"%f",foundBeacon.accuracy];
    }else{
        self.accuracy.text = @"----";
    }
    CLProximity proximity = foundBeacon.proximity;
    NSString* prox = nil;
    if(proximity == CLProximityFar){
        prox = @"beacon is far";
        NSLog(@"beacon is far");
    }else if(proximity == CLProximityNear){
        if(!self.connected){
            self.connected = true;
             [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
            [self.locationManager stopMonitoringForRegion:self.myBeaconRegion];
            [self connectToL8];
        }
        prox = @"beacon is near";
        NSLog(@"beacon is near");
    }else if(proximity == CLProximityUnknown){
        prox = @"beacon is unkown";
        NSLog(@"beacon is unkown");
    }else if(proximity == CLProximityImmediate){
        if(!self.connected){
            self.connected = true;
            [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
            [self.locationManager stopMonitoringForRegion:self.myBeaconRegion];
            [self connectToL8];
        }
        prox = @"beacon is Immediate";
        NSLog(@"beacon is Immediate");
    }
    self.foundLabel.text = prox;
    NSLog(@"%@",prox);
    
    NSLog(@"UUID: %@:",uuid);
    NSLog(@"MAJOR: %@:",major);
    NSLog(@"MINOR: %@:",minor);
}


- (IBAction)reset:(id)sender {
    if(self.connected){
    self.connected = false;
        [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}
- (IBAction)changeSeekBar:(id)sender {
    
    self.distance = roundl(self.seek.value);
    
    self.triggerDistance.text = [NSString stringWithFormat:@"%i m",self.distance];
    
}

-(void)connectToL8{
    NSLog(@"Connecting with l8...");
    [self.t findBLEPeripherals:10];
    BluetoothL8 *l8Bluetooth=[[BluetoothL8 alloc]init];
    l8Bluetooth.t=self.t;
    self.l8Array=[[NSMutableArray alloc] initWithObjects:l8Bluetooth, nil];
}

-(TIBLECBKeyfob*)getBLE{
    return self.t;
}

-(NSArray*)getL8Array{
    return self.l8Array;
}

-(void)configUpdated:(NSData *)config{
    
}


-(void)TXPwrLevelUpdated:(char)TXPwr{
    
}

-(void)notificationRcvd:(Byte)not1{
    
}

-(void)keyValuesUpdated:(char)sw{
    
}

-(void)accelerometerValuesUpdated:(char)x y:(char)y z:(char)z{
    
}

-(void)batteryLevelRcvd:(Byte)batLvl{
    
}

-(void)processDataFromPeripheral:(NSData *)data{
    NSLog(@"data l8: %@",data);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:data forKey:@"inputData"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"l8inputData" object:nil userInfo:userInfo];
}



-(void) keyfobReadyPeriferal:(CBPeripheral*)periferal{
    NSLog(@"bt ready");
    id<L8> l8=[self.l8Array lastObject];
    //TODO: Clear not found in this method
    [l8 clearMatrixWithSuccess:^{NSLog(@"matrix cleared");} failure:^(NSMutableDictionary *result) {
        NSLog(@"Error matrix cleared");
    }];
    
    [self.t L8SL_PrepareForReceiveDataFromL8SL:periferal];
    
    NSString *prubeString = @"#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff";
    NSArray *subStrings = [prubeString componentsSeparatedByString:@"-#"];
    
    [l8  setMatrix:subStrings withSuccess:^{NSLog(@"send Ok");} failure:^(NSMutableDictionary *result) {
        NSLog(@"setLED ERROR");
    }];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [l8 clearMatrixWithSuccess:^{
            
        } failure:^(NSMutableDictionary *result) {
            
        }];
        
        [l8 clearSuperLEDWithSuccess:^(NSArray *result) {
            
        } failure:^(NSMutableDictionary *result) {
            
        }];
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeviceList" object:self];
}

-(void) keyfobReady{
    NSLog(@"bt ready");
    id<L8> l8=[self.l8Array lastObject];
    //TODO: Clear not found in this method
    [l8 clearMatrixWithSuccess:^{NSLog(@"matrix cleared");} failure:^(NSMutableDictionary *result) {
        NSLog(@"Error matrix cleared");
    }];
    for(int i=0;i<[[self.t userPeripherals] count];i++){
        
        
        if([[[[self.t userPeripherals] objectAtIndex:i] valueForKey:@"isUserChecked"] isEqualToString:@"YES"]){
            CBPeripheral * activePeripheralUser = [[[self.t userPeripherals] objectAtIndex:i] valueForKey:@"peripheral"];
            [self.t L8SL_PrepareForReceiveDataFromL8SL:activePeripheralUser];
            
            usleep(800);
        }
        
    }
    
    NSString *prubeString = @"#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff-#ffffff";
    NSArray *subStrings = [prubeString componentsSeparatedByString:@"-#"];
    
    [l8  setMatrix:subStrings withSuccess:^{NSLog(@"send Ok");} failure:^(NSMutableDictionary *result) {
        NSLog(@"setLED ERROR");
    }];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [l8 clearMatrixWithSuccess:^{
            
        } failure:^(NSMutableDictionary *result) {
            
        }];
        
        [l8 clearSuperLEDWithSuccess:^(NSArray *result) {
            
        } failure:^(NSMutableDictionary *result) {
            
        }];
    });
    self.t.delegate=self;
}

-(void) disconnectL8{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeviceList" object:self];
}




@end
