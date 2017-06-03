//
//  ETRTableViewTracker.h
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+ETRTracker.h"

@interface ETRTableViewTracker : NSObject

@property (nonatomic, copy) ETR_viewTrackEventHandler viewHandler;
@property (nonatomic, copy) ETR_clickTrackEventHandler clickHandler;

+ (ETRTableViewTracker *)startTrackWithHostTableView:(UITableView *)tableView;

@end
