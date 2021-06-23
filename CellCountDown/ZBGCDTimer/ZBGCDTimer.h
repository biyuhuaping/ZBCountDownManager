//
//  ZBGCDTimer.h
//  CellCountDown
//
//  Created by zb on 2020/4/12.
//  Copyright © 2020 XiaoYaoYao.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBGCDTimer : NSObject

/// 创建GCD定时器
/// @param timerName 定时器名称
/// @param start 开始时间
/// @param interval 间隔
/// @param repeats 是否重复
/// @param async 是否异步线程
/// @param action 操作
+ (void)timerWithName:(NSString *)timerName
                 start:(NSTimeInterval) start
              interval:(NSTimeInterval) interval
               repeats:(BOOL) repeats
                 async:(BOOL)async
               action:(dispatch_block_t)action;


/// 取消定时器
/// @param timerName 定时器名
+ (void)canelTimer:(NSString*)timerName;

@end

NS_ASSUME_NONNULL_END
