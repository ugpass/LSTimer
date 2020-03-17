//
//  LSTimer.h
//  LSTimer
//
//  Created by demo on 2020/3/16.
//  Copyright © 2020 ls. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSTimer : NSObject

+ (NSString *)executeTask:(void(^)(void))task
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async;

+ (NSString *)executeTask:(id)target
                 selector:(SEL)selector
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async;

+ (void)cancelTimer:(NSString *)taskIdentifier;

@end

NS_ASSUME_NONNULL_END
