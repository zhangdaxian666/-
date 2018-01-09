//
//  LocationController.h
//  ScrollerView
//
//  Created by slcf888 on 2017/12/19.
//  Copyright © 2017年 slcf888. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LocationController : UIViewController <CLLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationmanager;
@end
