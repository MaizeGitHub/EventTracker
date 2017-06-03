//
//  ETRTableViewTracker.m
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "ETRTableViewTracker.h"
#import "ETRTableViewFakeDelegate.h"
#import "UITableView+ETRTracker.h"
#import <objc/runtime.h>

static NSString *kETRTableViewFakeDelegatePrefix = @"etr_tableViewFakeDelegate";

@interface ETRTableViewTracker ()

@end

@implementation ETRTableViewTracker

+ (ETRTableViewTracker *)startTrackWithHostTableView:(UITableView *)tableView
{
    ETRTableViewTracker *tracker = [[ETRTableViewTracker alloc] init];
    tableView.etr_tracker = tracker;
    
    if (tableView.delegate
        && ![NSStringFromClass([tableView.delegate class]) hasPrefix:kETRTableViewFakeDelegatePrefix]) {
        Class fakeDelegateClass = [self getTableViewFakeDelegateClass:[tableView.delegate class]];
        object_setClass(tableView.delegate, fakeDelegateClass);
    }
    [tableView addObserver:tracker forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    
    return tracker;
}

+ (Class)getTableViewFakeDelegateClass:(Class)originalClass
{
    NSString *fakeDelegateName = [kETRTableViewFakeDelegatePrefix stringByAppendingString:NSStringFromClass([originalClass class])];
    Class fakeDelegateClass = NSClassFromString(fakeDelegateName);
    
    if (!fakeDelegateClass) {
        fakeDelegateClass = objc_allocateClassPair(originalClass, fakeDelegateName.UTF8String, 0);
        
        Method classMethod = class_getInstanceMethod([ETRTableViewFakeDelegate class], @selector(class));
        class_addMethod(fakeDelegateClass, method_getName(classMethod), method_getImplementation(classMethod), method_getTypeEncoding(classMethod));
        
        classMethod = class_getInstanceMethod([ETRTableViewFakeDelegate class], @selector(tableView:didSelectRowAtIndexPath:));
        class_addMethod(fakeDelegateClass, method_getName(classMethod), method_getImplementation(classMethod), method_getTypeEncoding(classMethod));
        
        classMethod = class_getInstanceMethod([ETRTableViewFakeDelegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:));
        class_addMethod(fakeDelegateClass, method_getName(classMethod), method_getImplementation(classMethod), method_getTypeEncoding(classMethod));
        
        objc_registerClassPair(fakeDelegateClass);
    }
    
    return fakeDelegateClass;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[UITableView class]]
        && [keyPath isEqualToString:@"delegate"]) {
        id<UITableViewDelegate> delegate = change[NSKeyValueChangeNewKey];
        if (![NSStringFromClass([delegate class]) hasPrefix:kETRTableViewFakeDelegatePrefix]) {
            Class fakeDelegateClass = [ETRTableViewTracker getTableViewFakeDelegateClass:[delegate class]];
            object_setClass(delegate, fakeDelegateClass);
        }
    }
}

@end
