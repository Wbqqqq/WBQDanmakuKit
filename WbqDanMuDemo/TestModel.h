//
//  testModel.h
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/26.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WbqDanmuModelProtoco.h"
#import <UIKit/UIKit.h>
@interface TestModel : NSObject<WbqDanmuModelProtocol>

/** 弹幕的开始时间 */
@property (nonatomic, assign) NSTimeInterval beginTime;
/** 弹幕的存活时间 */
@property (nonatomic, assign) NSTimeInterval liveTime;
/** 弹幕的类型 */
@property (nonatomic, assign) DanmuPositionType positionType;

//ps : 前三个必须实现哦。


/** 弹幕颜色 */
@property (strong, nonatomic) UIColor *color;
/** 字体 */
@property (strong, nonatomic) UIFont *font;
/** 内容 */
@property (strong, nonatomic) NSString *text;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
