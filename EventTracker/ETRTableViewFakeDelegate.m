//
//  ETRTableViewFakeDelegate.m
//  EventTracker
//
//  Created by Maize on 2017/6/3.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "ETRTableViewFakeDelegate.h"
#import "NSObject+ETRTracker.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation ETRTableViewFakeDelegate

- (Class)class
{
    return class_getSuperclass(object_getClass(self));
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = NO;
    
    if (aSelector == @selector(tableView:didSelectRowAtIndexPath:)
        || aSelector == @selector(tableView:didSelectRowAtIndexPath:)) {
        responds = YES;
    } else {
        responds = [super respondsToSelector:aSelector];
    }

    return responds;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.etr_clickTrackEventHandler) {
        self.etr_clickTrackEventHandler(indexPath);
    }
    
    if ([super respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        struct objc_super superInfo = {
            .receiver = self,
            .super_class = class_getSuperclass(object_getClass(self))
        };
        
        void (*msgSend)(struct objc_super *, SEL, UITableView *, NSIndexPath *) = (__typeof__(msgSend))objc_msgSendSuper;
        msgSend(&superInfo, @selector(tableView:didSelectRowAtIndexPath:), tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"fake willDisplayCell");
}

@end
