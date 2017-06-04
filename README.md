# EventTracker
`为侵入式埋点服务, 旨在优雅的管理埋点代码和提供便捷的埋点入口.`

## 支持场景

### UITableView

#### 点击埋点:

    ETRTableViewClickEventTracker(self.tableView, ^(NSIndexPath *indexPath) {
      // 点击埋点代码
    });

#### 曝光埋点:

    // 0.5, 0.7: 滚动停止 500ms, cell 露出 70% 记为一次曝光
    ETRTableViewViewEventTracker(self.tableView, 0.5, 0.7, ^(UITableViewCell *cell, NSIndexPath *indexPath, ETR_viewMarkChecker checker) {
        // checker: 用于标记曝光, 对于同一入参只返回一次 YES
        if (checker(self.itemArray[indexPath.row])) {
            // 曝光埋点代码
        }
    });
