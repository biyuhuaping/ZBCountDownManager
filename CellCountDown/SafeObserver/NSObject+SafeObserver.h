//
//  NSObject+SafeObserver.h
//  Qian
//
//  Created by ZB on 2021/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SafeObserver)

- (void)cc_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
