//
//  CountDownManager.h
//  CellCountDown
//
//  Created by ZB on 2021/6/7.
//  Copyright © 2021 XiaoYaoYao.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBCountDownManager : NSObject

/// 时间差(单位:秒)
@property (assign, nonatomic) NSInteger timeInterval;

/// 使用单例
+ (instancetype)manager;

/// 开始倒计时
- (void)startTimer;

/// 停止倒计时
- (void)invalidate;

/// 刷新倒计时
- (void)reload;

@end
