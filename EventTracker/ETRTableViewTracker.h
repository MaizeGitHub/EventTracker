//
//  ETRTableViewTracker.h
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETRTableViewTracker : NSObject

+ (ETRTableViewTracker *)startTrackWithHostTableView:(UITableView *)tableView;

@end
