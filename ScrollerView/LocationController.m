//
//  LocationController.m
//  ScrollerView
//   https://github.com/LeeYouth 库
//  Created by slcf888 on 2017/12/19.
//  Copyright © 2017年 slcf888. All rights reserved.
//   http://www.jianshu.com/p/f58be9373b6a 定位
//   https://www.cnblogs.com/qinrui/p/4734292.html

#import "LocationController.h"

@interface LocationController ()
{
    NSString * currentCity;
}
@end

@implementation LocationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =[UIColor whiteColor];
    [self locate];
    // Do any additional setup after loading the view.
}
- (void)locate{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationmanager =[[CLLocationManager alloc]init];
        self.locationmanager.delegate =self;
        [self.locationmanager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationmanager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            NSLog(@"%@",currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
