//
//  ETRDelayedTaskManager.h
//  EventTracker
//
//  Created by Maize on 2017/6/4.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETRDelayedTaskManager : NSObject

- (void)applyTask:(void (^)())task delayed:(NSTimeInterval)timeInterval;

- (void)cancleTask;

@end
