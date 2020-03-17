//
//  LSTimer.m
//  LSTimer
//
//  Created by demo on 2020/3/16.
//  Copyright © 2020 ls. All rights reserved.
//

#import "LSTimer.h"

@implementation LSTimer

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphore_;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)executeTask:(void (^)(void))task
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async {
    if (!task || start < 0 || (repeats && interval <= 0)) return nil;
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_WALLTIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *taskIdentifier = [NSString stringWithFormat:@"%zd", timers_.count];
    timers_[taskIdentifier] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTimer:taskIdentifier];
        }
    });
    
    dispatch_resume(timer);
    return taskIdentifier;
}

+ (NSString *)executeTask:(id)target
                 selector:(SEL)selector
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async {
    if (!target || !selector) return nil;
    return [self executeTask:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
         [target performSelector:selector];
        
#pragma clang diagnostic pop
    } start:start interval:interval repeats:repeats async:async];
}

+ (void)cancelTimer:(NSString *)taskIdentifier {
    if (taskIdentifier.length == 0) {
        return;
    }
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[taskIdentifier];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:taskIdentifier];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end
