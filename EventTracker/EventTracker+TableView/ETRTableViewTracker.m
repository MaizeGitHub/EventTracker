//
//  ETRTableViewTracker.m
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "ETRTableViewTracker.h"
#import "ETRDelayedTaskManager.h"
#import "ETRTableViewFakeDelegate.h"
#import "UITableView+ETRTracker.h"

#import <objc/runtime.h>

static NSString *kETRTableViewFakeDelegatePrefix = @"etr_tableViewFakeDelegate";

@interface ETRTableViewTracker ()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) ETRDelayedTaskManager *taskManager;

@end

@implementation ETRTableViewTracker

+ (ETRTableViewTracker *)startTrackWithHostTableView:(UITableView *)tableView
{
    ETRTableViewTracker *tracker = tableView.etr_tracker;
    
    if (!tracker) {
        tracker = [[ETRTableViewTracker alloc] init];
        tracker.tableView = tableView;
        tableView.etr_tracker = tracker;
        
        id<UITableViewDelegate> delegate = tableView.delegate;
        if (delegate
            && ![NSStringFromClass([delegate class]) hasPrefix:kETRTableViewFakeDelegatePrefix]) {
            Class fakeDelegateClass = [self getTableViewFakeDelegateClass:[delegate class]];
            object_setClass(delegate, fakeDelegateClass);
            
            tableView.delegate = delegate;
        }
        [tableView addObserver:tracker forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
        [tableView addObserver:tracker forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
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
        
        classMethod = class_getInstanceMethod([ETRTableViewFakeDelegate class], @selector(respondsToSelector:));
        class_addMethod(fakeDelegateClass, method_getName(classMethod), method_getImplementation(classMethod), method_getTypeEncoding(classMethod));
        
        classMethod = class_getInstanceMethod([ETRTableViewFakeDelegate class], @selector(tableView:didSelectRowAtIndexPath:));
        class_addMethod(fakeDelegateClass, method_getName(classMethod), method_getImplementation(classMethod), method_getTypeEncoding(classMethod));
        
        objc_registerClassPair(fakeDelegateClass);
    }
    
    return fakeDelegateClass;
}

#pragma mark instance method

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _taskManager = [[ETRDelayedTaskManager alloc] init];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[UITableView class]]) {
        if ([keyPath isEqualToString:@"delegate"]) {
            id<UITableViewDelegate> delegate = change[NSKeyValueChangeNewKey];
            if (delegate
                && ![delegate isKindOfClass:[NSNull class]]
                && ![NSStringFromClass([delegate class]) hasPrefix:kETRTableViewFakeDelegatePrefix]) {
                Class fakeDelegateClass = [ETRTableViewTracker getTableViewFakeDelegateClass:[delegate class]];
                object_setClass(delegate, fakeDelegateClass);
            }
            
            if ([delegate isKindOfClass:[NSObject class]]
                && [NSStringFromClass([delegate class]) hasPrefix:kETRTableViewFakeDelegatePrefix]) {
                ((NSObject *)delegate).etr_clickTrackEventHandler = self.clickHandler;
                
                [object addObserver:delegate forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            }
        } else if ([keyPath isEqualToString:@"contentOffset"]) {
            __weak typeof(self) weakSelf = self;
            [self.taskManager applyTask:^{
                [weakSelf trackTableViewViewEvent];
            } delayed:self.viewDelayedTimeInterval];
        }
    }
}

- (void)setClickHandler:(ETR_clickTrackEventHandler)clickHandler
{
    _clickHandler = clickHandler;
    
    if ([self.tableView.delegate isKindOfClass:[NSObject class]]) {
        ((NSObject *)self.tableView.delegate).etr_clickTrackEventHandler = clickHandler;
    }
}

- (void)trackTableViewViewEvent
{
    NSArray<UITableViewCell *> *visibleCells = self.tableView.visibleCells;
    for (UITableViewCell *visibleCell in visibleCells) {
        if ([self shouleTriggerViewEvents:visibleCell]) {
            if (self.viewHandler) {
                self.viewHandler(visibleCell, [self.tableView indexPathForCell:visibleCell], ^BOOL(NSObject *markItem) {
                    if (markItem.etr_viewMark) {
                        return NO;
                    } else {
                        markItem.etr_viewMark = YES;
                        return YES;
                    }
                });
            }
        }
    }
}

- (BOOL)shouleTriggerViewEvents:(UITableViewCell *)cell
{
    BOOL shouldTrigger = YES;
    
    CGRect viewRect = {
        .origin = CGPointMake(0, self.tableView.contentOffset.y),
        .size = self.tableView.frame.size
    };
    CGRect cellRect = cell.frame;
    
    CGFloat viewAreaPercent = (MIN(CGRectGetMaxY(cellRect), CGRectGetMaxY(viewRect)) - MAX(CGRectGetMinY(cellRect), CGRectGetMinY(viewRect))) / CGRectGetHeight(cellRect);
    if (CGRectGetMaxY(cellRect) <= CGRectGetMinY(viewRect)
        || CGRectGetMinY(cellRect) >= CGRectGetMaxY(viewRect)
        || viewAreaPercent <= self.viewAreaPercent) {
        shouldTrigger = NO;
    }
    
    return shouldTrigger;
}

- (void)dealloc
{
    [self.taskManager cancleTask];
}

@end
