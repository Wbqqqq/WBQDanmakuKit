//
//  NSTimer+WBQBlockSupport.h
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/28.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (WbqBlockSupport)
+ (instancetype)wbq_timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)())timeBlock repeats:(BOOL)repeats;
@end
