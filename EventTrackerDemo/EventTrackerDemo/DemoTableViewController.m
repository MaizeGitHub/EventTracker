//
//  DemoTableViewController.m
//  EventTracker
//
//  Created by Maize on 2017/6/2.
//  Copyright © 2017年 maize.com. All rights reserved.
//

#import "DemoTableViewController.h"
#import "ETRTableViewTracker.h"

@interface DemoTableViewController ()

@property (nonatomic, copy) NSArray<NSNumber *> *cellHeightArray;

@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.cellHeightArray = @[@40, @50, @60, @70, @80, @90, @100, @110, @120, @115, @105, @95, @85, @75, @65, @55, @45, @35];
    
    ETRTableViewClickEventTracker(self.tableView, ^(NSIndexPath *indexPath) {
        // 点击埋点代码
        NSLog(@"TrackClickEvent=====%@", indexPath);
    });
    
    __weak typeof(self) weakSelf = self;
    ETRTableViewViewEventTracker(self.tableView, 0.5, 0.7, ^(UITableViewCell *cell, NSIndexPath *indexPath, ETR_viewMarkChecker checker) {
        if (checker(weakSelf.cellHeightArray[indexPath.row])) {
            // 曝光埋点代码
            NSLog(@"TrackViewEvent=====%@", indexPath);
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellHeightArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"index = %@, height = %@", @(indexPath.row), self.cellHeightArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeightArray[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"original didSelectRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
