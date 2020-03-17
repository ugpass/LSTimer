//
//  LSProxy.h
//  LSTimer
//
//  Created by demo on 2020/3/16.
//  Copyright © 2020 ls. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSProxy : NSProxy

@property (nonatomic, weak)id target;
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
