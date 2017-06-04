//
//  ETRTableViewTracker.h
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+ETRTracker.h"

#define ETRTableViewClickEventTracker(tableView, handler)\
{\
ETRTableViewTracker *traker = [ETRTableViewTracker startTrackWithHostTableView:tableView];\
traker.clickHandler = handler;\
}

#define ETRTableViewViewEventTracker(tableView, time, percent, handler)\
{\
ETRTableViewTracker *traker = [ETRTableViewTracker startTrackWithHostTableView:tableView];\
traker.viewDelayedTimeInterval = time;\
traker.viewAreaPercent = percent;\
traker.viewHandler = handler;\
}


@interface ETRTableViewTracker : NSObject

@property (nonatomic, copy) ETR_viewTrackEventHandler viewHandler;
@property (nonatomic, copy) ETR_clickTrackEventHandler clickHandler;

@property (nonatomic, assign) NSTimeInterval viewDelayedTimeInterval;
@property (nonatomic, assign) CGFloat viewAreaPercent;

+ (ETRTableViewTracker *)startTrackWithHostTableView:(UITableView *)tableView;

@end
