//
//  WbqDanmuConfiguration.h
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/26.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ConfigDanmuType   configuration.danmuType

#define NormalStartIndex   configuration.normalStartTrackIndex

#define NormalEndIndex   configuration.normalEndTrackIndex

#define TopStartIndex   configuration.topStartTrackIndex

#define TopEndIndex   configuration.topEndTrackIndex

#define BottomStartIndex   configuration.bottomStartTrackIndex

#define BottomEndIndex   configuration.bottomEndTrackIndex

#define DanmuNomalTrackNumber  configuration.normalTrackNumber

#define DanmuTopAndBottomTrackNumber  configuration.topAndBottomTrackNumber

#define DanmuTimeInterval  configuration.timeInterval

#define DanmuMaxDisplayNumber   configuration.maxDisplayNumber

//（因为考虑到直播socket加载的弹幕，会让缓存的弹幕数组越来越大，所以进行区分，如果是直播socket获取的弹幕，展示完之后会移除）
typedef NS_ENUM(NSInteger, DanmuType) {
    LiveStream,  // 直播视频，通过socket获取弹幕
    MP4,   // 普通视频，一次性获取全部的弹幕
};



@interface WbqDanmuConfiguration : NSObject

/**
 *  弹幕播放类型,为什么会有这个枚举呢，额...看枚举注释。
 */
@property (nonatomic) DanmuType  danmuType;

/**
 *  最大显示数量,默认100
 */
@property (assign, nonatomic) NSInteger maxDisplayNumber;

/**
 *  普通轨道数，默认8
 */
@property (assign, nonatomic) NSInteger normalTrackNumber;

/**
 *  上下轨道数，默认8
 */
@property (assign, nonatomic) NSInteger topAndBottomTrackNumber;

/**
 *  定时器遍历时间间隔
 */
@property (assign, nonatomic) NSTimeInterval timeInterval;

/**
 *  普通轨道起始遍历轨道下标，默认0
 */
@property (assign, nonatomic) NSInteger normalStartTrackIndex;

/**
 *  普通轨道结束遍历轨道下标，默认轨道数减1
 */
@property (assign, nonatomic) NSInteger normalEndTrackIndex;

/**
 *  上方弹幕起始遍历轨道下标，默认0
 */
@property (assign, nonatomic) NSInteger topStartTrackIndex;

/**
 *  上方弹幕结束遍历轨道下标，默认轨道数减1
 */
@property (assign, nonatomic) NSInteger topEndTrackIndex;


/**
 *  下方弹幕起始遍历轨道下标，默认0
 */
@property (assign, nonatomic) NSInteger bottomStartTrackIndex;

/**
 *  下方弹幕结束遍历轨道下标，默认轨道数减1
 */
@property (assign, nonatomic) NSInteger bottomEndTrackIndex;



@end
