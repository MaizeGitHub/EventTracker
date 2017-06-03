//
//  ETRTableViewTracker.m
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "ETRTableViewTracker.h"
#import "ETRFakeTableViewDelegate.h"
#import "UITableView+ETRTracker.h"
#import <objc/runtime.h>

static ETRTableViewTracker *tableViewTracker;

@interface ETRTableViewTracker ()

@property (nonatomic, strong) ETRFakeTableViewDelegate *fakeDelegate;

@end

@implementation ETRTableViewTracker

+ (ETRTableViewTracker *)startTrackWithHostTableView:(UITableView *)tableView
{
    ETRTableViewTracker *tracker = [[ETRTableViewTracker alloc] init];
    tableView.etr_tracker = tracker;
    
    if (tableView.delegate) {
        object_setClass(tableView.delegate, [ETRFakeTableViewDelegate class]);
    }
    [tableView addObserver:tracker forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    
    return tracker;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"delegate"]) {
        id delegate = change[NSKeyValueChangeNewKey];
        object_setClass(delegate, [ETRFakeTableViewDelegate class]);
    }
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _fakeDelegate = [[ETRFakeTableViewDelegate alloc] init];
    }
    
    return self;
}

@end
