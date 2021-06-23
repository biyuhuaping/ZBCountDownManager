//
//  ZBTableViewCell.m
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import "ZBTableViewCell.h"
#import "NSObject+SafeObserver.h"

@interface ZBTableViewCell ()

@end

@implementation ZBTableViewCell

// 代码创建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setModel:(ZBModel *)model {
    _model = model;
    
    self.textLabel.text = model.title;
    NSInteger timeInterval = [ZBCountDownManager manager].timeInterval;
    [self updateCountDown:timeInterval];
    
    NSInteger countDown = model.count - timeInterval;
    if (countDown > 0) {
        //添加监听
        [[ZBCountDownManager manager] cc_addObserver:self forKeyPath:@"timeInterval"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"timeInterval"]) {
        NSInteger timeInterval = [change[NSKeyValueChangeNewKey] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 手动刷新数据
            [self updateCountDown:timeInterval];
        });
    }
}

#pragma mark - 倒计时通知回调
- (void)updateCountDown:(NSInteger)timeInterval {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    ZBModel *model = self.model;
    NSInteger countDown = model.count - timeInterval;
    /// 当倒计时到了进行回调
    if (countDown <= 0) {
        self.detailTextLabel.text = @"活动开始";
        // 回调给控制器
        if (self.countDownZero) {
            self.countDownZero(model);
        }
        return;
    }
    /// 重新赋值
    self.detailTextLabel.text = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
}

@end
