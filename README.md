l8iBeacon
=========

This is a proof of concept to use your L8 device like an iBeacon.

## 0. Introduction:
This repository has a firmware version with iBeacon support for L8 device and an application demo developed for iPad devices. This application can be used like a base for your own developments. The iBeacon mode only works in bluetooth 4.0 and changes to normal L8 every 10 seconds, in other words 10 seconds normal L8 mode and 10 seconds in iBeacon mode.

The demo application search an iBeacon and when it is found, the app try to connect to L8 device. 

## 1. Installation:
1. Download the project and import in to your Xcode.

2. Install the  L8R47_iB.dfu file in your L8 device. This file is available in this repository. To install a new firmware version, please visit our web site (http://www.l8smartlight.com/using-your-l8/l8-and-windows/update-light-os/)

**Note** This is only a proof of concept project, it isn´t a complete application.

## 2. Quick start:
The project use the libraries L8SDK and location API to detect iBeacon. Of course you are free to use any other tutorial to create your own iBeacon detector. 

- The first thing that we need to know is the iBeacon ID 



In this way, in our MainViewController.h we have:

```objective-c

#import <UIKit/UIKit.h>

#import "TIBLECBKeyfob.h"


```
