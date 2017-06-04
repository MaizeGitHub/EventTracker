//
//  NSObject+ETRTracker.h
//  EventTracker
//
//  Created by Maize on 2017/6/3.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^ETR_viewMarkChecker)(NSObject *markItem);
typedef void(^ETR_viewTrackEventHandler)(UITableViewCell *cell, NSIndexPath *indexPath, ETR_viewMarkChecker checker);
typedef void(^ETR_clickTrackEventHandler)(NSIndexPath *indexPath);

@interface NSObject (ETRTracker)

@property (nonatomic, assign) BOOL etr_viewMark;

@property (nonatomic, copy) ETR_clickTrackEventHandler etr_clickTrackEventHandler;

@end
