//
//  ViewController.m
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import "ZBTableVC.h"
#import "ZBModel.h"
#import "ZBTableViewCell.h"

@interface ZBTableVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZBTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列表倒计时";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZBTableViewCell *cell = (ZBTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ZBTableViewCell"];
    ZBModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    [cell setCountDownZero:^(ZBModel *timeOutModel){
        if (!timeOutModel.isTimeOut) {
            NSLog(@"ZBTableVC- %@ -时间到了", timeOutModel.title);
        }
        timeOutModel.isTimeOut = YES;
    }];
    return cell;
}

#pragma mark - 刷新数据
// 模拟网络请求
- (void)reloadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataArray = nil;
        // 调用reload
        [[ZBCountDownManager manager] reload];
        // 刷新
        [self.tableView reloadData];
        // 停止刷新
        [self.tableView.refreshControl endRefreshing];
    });
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.refreshControl = [[UIRefreshControl alloc] init];
        [_tableView.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
        [_tableView registerClass:ZBTableViewCell.class forCellReuseIdentifier:@"ZBTableViewCell"];
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i=0; i<50; i++) {
            // 模拟从服务器取得数据 -- 例如:服务器返回的数据为剩余时间数
            NSInteger count = arc4random_uniform(50); //生成0-100之间的随机正整数
            ZBModel *model = [[ZBModel alloc]init];
            model.count = count;
            model.title = [NSString stringWithFormat:@"第%zd条数据", i];
            model.ID = [NSString stringWithFormat:@"%zd", i];
            [arrM addObject:model];
        }
        _dataArray = arrM.copy;
    }
    return _dataArray;
}

@end
