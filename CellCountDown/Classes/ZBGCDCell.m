//
//  ZBGCDCell.m
//  CellCountDown
//
//  Created by ZB on 2021/6/22.
//  Copyright © 2021 herobin. All rights reserved.
//  GCD 倒计时


#import "ZBGCDCell.h"
#import "ZBGCDTimer.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface ZBGCDCell ()

@property (copy, nonatomic) NSString *countdownIdenfier;
@property (assign, nonatomic) NSInteger countDown;

@end

@implementation ZBGCDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZBModel *)model {
    _model = model;
    
    self.textLabel.text = model.title;
    
    //以cell的内存地址做为唯一标识符
    self.countdownIdenfier = [NSString stringWithFormat:@"%@%p",NSStringFromClass(self.class), self];
    //取消原来的定时器
    [ZBGCDTimer canelTimer:self.countdownIdenfier];
    
    self.countDown = model.count;
    WEAKSELF
    [ZBGCDTimer timerWithName:self.countdownIdenfier start:0 interval:1 repeats:YES async:NO action:^{
        [weakSelf updateCountDown:1];
    }];
}

#pragma mark - 倒计时通知回调
- (void)updateCountDown:(NSInteger)timeInterval {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }

    /// 当倒计时到了进行回调
    if (self.countDown <= 0) {
        self.detailTextLabel.text = @"活动开始";
        // 回调给控制器
        if (self.countDownZero) {
            self.countDownZero(self.model);
        }
        return;
    }
    /// 重新赋值
    self.detailTextLabel.text = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", self.countDown/3600, (self.countDown/60)%60, self.countDown%60];
}

- (void)dealloc{
    [ZBGCDTimer canelTimer:self.countdownIdenfier];
}

@end
