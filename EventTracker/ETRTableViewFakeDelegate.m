//
//  ETRTableViewFakeDelegate.m
//  EventTracker
//
//  Created by Maize on 2017/6/3.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "ETRTableViewFakeDelegate.h"
#import <objc/runtime.h>

@implementation ETRTableViewFakeDelegate

- (Class)class
{
    return class_getSuperclass(object_getClass(self));
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"fake didSelectRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"fake willDisplayCell");
}

@end
