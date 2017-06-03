//
//  UITableView+ETRTracker.m
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "UITableView+ETRTracker.h"
#import "ETRTableViewTracker.h"

#import <objc/runtime.h>

@implementation UITableView (ETRTracker)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, sel_registerName("dealloc"));
    Method newMethod = class_getInstanceMethod(self, @selector(etr_dealloc));
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)etr_dealloc
{
    if (self.etr_tracker) {
        [self removeObserver:self.etr_tracker forKeyPath:@"delegate"];
    }
    
    [self etr_dealloc];
}

- (void)setEtr_tracker:(ETRTableViewTracker *)etr_tracker
{
    objc_setAssociatedObject(self, @selector(etr_tracker), etr_tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ETRTableViewTracker *)etr_tracker
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
