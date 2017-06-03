//
//  UITableView+ETRTracker.m
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "UITableView+ETRTracker.h"
#import <objc/runtime.h>

@implementation UITableView (ETRTracker)

- (void)setEtr_tracker:(ETRTableViewTracker *)etr_tracker
{
    objc_setAssociatedObject(self, @selector(etr_tracker), etr_tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ETRTableViewTracker *)etr_tracker
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
