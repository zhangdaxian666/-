//
//  NSTimer+KNTimer.h
//  ScrollerView
//
//  Created by slcf888 on 2017/12/15.
//  Copyright © 2017年 slcf888. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (KNTimer)

+ (NSTimer *)kn_TimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSTimer *))block;

@end
