//
//  CountDownManager.h
//  CellCountDown
//
//  Created by ZB on 2021/6/7.
//  Copyright © 2021 XiaoYaoYao.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBTimeInterval : NSObject

@end





@interface ZBCountDownManager : NSObject

/// 时间间隔(单位:秒)
@property (assign, nonatomic) NSInteger timeInterval;

/// 使用单例
+ (instancetype)manager;


// ===  identifier标识符，用于区分不同的倒计时源 ===

/// 添加倒计时
/// @param identifier 标识符
- (void)addTimerWithIdentifier:(NSString *)identifier;

/// 获取时间间隔
/// @param identifier 标识符
- (NSInteger)getTimeIntervalWithIdentifier:(NSString *)identifier;

/// 刷新指定的倒计时
/// @param identifier 标识符
- (void)reloadTimerWithIdentifier:(NSString *)identifier;

/// 刷新所有倒计时
- (void)reloadAll;

/// 移除指定的倒计时
/// @param identifier 标识符
- (void)removeTimerWithIdentifier:(NSString *)identifier;

/// 清除所有倒计时
- (void)removeAll;

@end
