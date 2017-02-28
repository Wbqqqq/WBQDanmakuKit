//
//  WbqDanmuModelProtoco.h
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/26.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

@protocol WbqDanmuModelProtocol <NSObject>

typedef NS_ENUM(NSInteger, DanmuPositionType) {
    DanmuTypeNormal,  // 普通弹幕
    DanmuTypeTop,     // 顶部弹幕
    DanmuTypeBottom,  // 底部弹幕
};


@required
/** 弹幕的开始时间 */
@property (nonatomic, readonly) NSTimeInterval beginTime;
/** 弹幕的存活时间 */
@property (nonatomic, readonly) NSTimeInterval liveTime;
/** 弹幕的类型 */
@property (nonatomic) DanmuPositionType positionType;

@end
