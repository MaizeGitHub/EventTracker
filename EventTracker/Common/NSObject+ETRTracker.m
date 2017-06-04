//
//  NSObject+ETRTracker.m
//  EventTracker
//
//  Created by Maize on 2017/6/3.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "NSObject+ETRTracker.h"

#import <objc/runtime.h>

@implementation NSObject (ETRTracker)

- (void)setEtr_viewMark:(BOOL)etr_viewMark
{
    objc_setAssociatedObject(self, @selector(etr_viewMark), @(etr_viewMark), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)etr_viewMark
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEtr_clickTrackEventHandler:(ETR_clickTrackEventHandler)etr_clickTrackEventHandler
{
    objc_setAssociatedObject(self, @selector(etr_clickTrackEventHandler), etr_clickTrackEventHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ETR_clickTrackEventHandler)etr_clickTrackEventHandler
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
