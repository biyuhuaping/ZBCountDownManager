//
//  Model.h
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger count;

/// 表示时间已经到了
@property (nonatomic, assign) BOOL isTimeOut;

@end
