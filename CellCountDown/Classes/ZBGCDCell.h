//
//  ZBGCDCell.h
//  CellCountDown
//
//  Created by ZB on 2021/6/22.
//  Copyright © 2021 herobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBGCDCell : UITableViewCell

@property (strong, nonatomic) ZBModel *model;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(ZBModel *);

@end

NS_ASSUME_NONNULL_END
