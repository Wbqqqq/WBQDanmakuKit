//
//  NSTimer+WBQBlockSupport.m
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/28.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "NSTimer+WbqBlockSupport.h"

@implementation NSTimer (WbqBlockSupport)
+ (instancetype)wbq_timerWithTimeInterval:(NSTimeInterval)timeInterval
                                   block:(void (^)())timeBlock
                                 repeats:(BOOL)repeats{
    return [self timerWithTimeInterval:timeInterval
                                target:self
                              selector:@selector(wbq_blockInvoke:)
                              userInfo:[timeBlock copy]
                               repeats:repeats
            ];
}


+ (void)wbq_blockInvoke:(NSTimer *)timer{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end


