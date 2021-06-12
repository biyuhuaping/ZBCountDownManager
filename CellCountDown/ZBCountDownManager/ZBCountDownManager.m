//
//  CountDownManager.m
//  CellCountDown
//
//  Created by ZB on 2021/6/7.
//  Copyright © 2021 XiaoYaoYao.Ltd. All rights reserved.
//

#import "ZBCountDownManager.h"
#import <UIKit/UIKit.h>


@interface ZBTimeInterval ()

@property (assign, nonatomic) NSInteger timeInterval;

+ (instancetype)timeInterval:(NSInteger)timeInterval;

@end


@implementation ZBTimeInterval

+ (instancetype)timeInterval:(NSInteger)timeInterval {
    ZBTimeInterval *object = [[ZBTimeInterval alloc] init];
    object.timeInterval = timeInterval;
    return object;
}

@end








@interface ZBCountDownManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ZBTimeInterval *> *timeIntervalDict;

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

/// 停止倒计时
- (void)invalidate {
    if (_timer) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

// 定时器每次加1
- (void)timerAction {
    [self timerActionWithTimeInterval:1];
}

- (void)timerActionWithTimeInterval:(NSInteger)timeInterval {
    // 时间差+
    self.timeInterval += timeInterval;
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, ZBTimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval += timeInterval;
    }];
}

//添加倒计时源
- (void)addTimerWithIdentifier:(NSString *)identifier {
    [self timer];//如果没启动定时器，会自动启动定时器
    ZBTimeInterval *timeInterval = self.timeIntervalDict[identifier];
    if (timeInterval) {//已经有，就从0开始
        timeInterval.timeInterval = 0;
        self.timeInterval = 0;
    }else {//没有就加入字典，从0开始
        [self.timeIntervalDict setObject:[ZBTimeInterval timeInterval:0] forKey:identifier];
    }
}

// 获取时间间隔
- (NSInteger)getTimeIntervalWithIdentifier:(NSString *)identifier {
    return self.timeIntervalDict[identifier].timeInterval;
}

// 刷新指定的倒计时
- (void)reloadTimerWithIdentifier:(NSString *)identifier {
    self.timeIntervalDict[identifier].timeInterval = 0;
}

// 刷新所有倒计时
- (void)reloadAll {
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, ZBTimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}

// 移除指定的倒计时
- (void)removeTimerWithIdentifier:(NSString *)identifier {
    [self.timeIntervalDict removeObjectForKey:identifier];
    if (self.timeIntervalDict.count == 0) {
        [self invalidate];
    }
}

// 清除所有倒计时
- (void)removeAll {
    [self.timeIntervalDict removeAllObjects];
    [self invalidate];
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
        [self timer];
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

- (NSMutableDictionary *)timeIntervalDict {
    if (!_timeIntervalDict) {
        _timeIntervalDict = [NSMutableDictionary dictionary];
    }
    return _timeIntervalDict;
}

@end
