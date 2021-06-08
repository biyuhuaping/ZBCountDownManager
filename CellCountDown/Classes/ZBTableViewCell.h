//
//  ZBTableViewCell.h
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBModel.h"
#import "ZBCountDownManager.h"


@interface ZBTableViewCell : UITableViewCell

@property (nonatomic, strong) ZBModel *model;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(ZBModel *);

@end
