l8iBeacon
=========

This is a proof of concept to use your L8 device like an iBeacon.

## 0. Introduction:
This repository has a firmware version with iBeacon support for L8 device and an application demo developed for iPad devices. This application can be used like a base for your own developments. The iBeacon mode only works in bluetooth 4.0 and changes to normal L8 every 10 seconds, in other words 10 seconds normal L8 mode and 10 seconds in iBeacon mode.

The demo application search an iBeacon and when it is found, the app try to connect to L8 device. 

## 1. Installation:
1. Download the project and import in to your Xcode.

2. Install the  L8R47_iB.dfu file in your L8 device. This file is available in this repository. To install a new firmware version, please visit our web site http://www.l8smartlight.com/using-your-l8/l8-and-windows/update-light-os/

**Note** This is only a proof of concept project, it isn´t a complete application.

## 2. Quick start:
The project use the libraries L8SDK and location API to detect iBeacon. Of course you are free to use any other tutorial to create your own iBeacon detector. 

- The first thing that we need to know is the iBeacon UUID 

    86A8B69C-8792-49C9-B5D7-D579AD9A4982
    
- Once that we know the UUID, we can create and monitor a region:
  
```objective-c

    //Creates an instance of CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Sets delegate, we will show you the delegate methods below.
    self.locationManager.delegate = self;
    
    //Creates an NSUUID
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"86A8B69C-8792-49C9-B5D7-D579AD9A4982"];
    
    //Creates a region with UUID 
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"region1"];
    
    //Configs region notification to work in background
    self.myBeaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Configs accurcy
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //Starts ranging
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    
    //Starts updating location, this instruction is essential to work in background
    [self.locationManager startUpdatingLocation];

  
```

We need to implement all necessary delegate methods, in this way, in our MainViewController.h we have:

```objective-c

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



```
