//
//  ZBGCDTimer.m
//  CellCountDown
//
//  Created by zb on 2020/4/12.
//  Copyright © 2020 XiaoYaoYao.Ltd. All rights reserved.
//

#import "ZBGCDTimer.h"

@implementation ZBGCDTimer

static NSMutableDictionary *timerContainer;
dispatch_semaphore_t semaphore;

+ (void)initialize{
    //GCD一次性函数
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerContainer = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
}

+ (void)timerWithName:(NSString *)timerName start:(NSTimeInterval) start interval:(NSTimeInterval) interval repeats:(BOOL) repeats async:(BOOL)async action:(dispatch_block_t)action{
    if (!action || start < 0 || (interval <= 0 && repeats)) {
        return;
    }
    dispatch_source_t timer = [timerContainer objectForKey:timerName];
    if (!timer) {
        /**
         队列
         async：YES 全局队列 dispatch_get_global_queue(0, 0) 可以简单理解为其他线程(非主线程)
         async：NO 主队列 dispatch_get_main_queue() 可以理解为主线程
         */
        dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
        
        /**
         创建定时器 dispatch_source_t timer
         */
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 定时器的唯一标识
        
        // 存放到字典中
        timerContainer[timerName] = timer;
        dispatch_semaphore_signal(semaphore);
        
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        //启动定时器
        dispatch_resume(timer);
    }
    
    dispatch_source_set_event_handler(timer, ^{
        //定时任务
        action();
        //如果不需要重复，执行一次即可
        if (!repeats) {
            [self canelTimer:timerName];
        }
    });
}

+ (void)canelTimer:(NSString*) timerName{
    if (timerName.length == 0) {
        return;
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timerContainer[timerName];
    if (timer) {
        dispatch_source_cancel(timer);
        [timerContainer removeObjectForKey:timerName];
    }
    dispatch_semaphore_signal(semaphore);
}

@end
