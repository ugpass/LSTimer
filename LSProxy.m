//
//  LSProxy.m
//  LSTimer
//
//  Created by demo on 2020/3/16.
//  Copyright © 2020 ls. All rights reserved.
//

#import "LSProxy.h"

@implementation LSProxy

+ (instancetype)proxyWithTarget:(id)target {
    LSProxy *proxy = [LSProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
