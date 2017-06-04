//
//  ETRDelayedTaskManager.m
//  EventTracker
//
//  Created by Maize on 2017/6/4.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "ETRDelayedTaskManager.h"

@interface ETRDelayedTaskManager ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ETRDelayedTaskManager

- (void)applyTask:(void (^)())task delayed:(NSTimeInterval)timeInterval
{
    [self.timer invalidate];
    
    if (timeInterval) {
        NSTimer *timer = [self timerWithTimeInterval:timeInterval callBack:task];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        self.timer = timer;
    } else {
        if (task) {
            task();
        }
    }
}

- (NSTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval callBack:(void (^)())callBack
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval repeats:NO block:^(NSTimer * _Nonnull timer) {
        if (callBack) {
            callBack();
        }
    }];
    
    return timer;
}

- (void)cancleTask
{
    [self.timer invalidate];
}

@end
