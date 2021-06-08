//
//  CountDownManager.m
//  CellCountDown
//
//  Created by ZB on 2021/6/7.
//  Copyright © 2021 XiaoYaoYao.Ltd. All rights reserved.
//

#import "ZBCountDownManager.h"
#import <UIKit/UIKit.h>


@interface ZBCountDownManager ()

@property (nonatomic, strong) NSTimer *timer;

/// 后台模式使用, 记录进入后台的绝对时间
@property (nonatomic, assign) BOOL backgroudRecord;
@property (nonatomic, assign) CFAbsoluteTime lastTime;

@end

@implementation ZBCountDownManager

+ (instancetype)manager {
    static ZBCountDownManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZBCountDownManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 监听进入前台与进入后台的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)startTimer {
    // 启动定时器
    [self timer];
}

- (void)reload {
    // 刷新只要让时间差为0即可
    _timeInterval = 0;
}

/// 停止倒计时
- (void)invalidate {
    if (_timer) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timerAction {
    // 定时器每次加1
    // 时间差+
    self.timeInterval += 1;
}

//MARK: -
- (void)applicationDidEnterBackgroundNotification {
    self.backgroudRecord = (_timer != nil);
    if (self.backgroudRecord) {
        self.lastTime = CFAbsoluteTimeGetCurrent();
        [self invalidate];
    }
}

- (void)applicationWillEnterForegroundNotification {
    if (self.backgroudRecord) {
        CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lastTime;
        // 时间差+  取整
        self.timeInterval += (NSInteger)timeInterval;
        [self startTimer];
    }
}

//MARK: - lazy
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

@end
