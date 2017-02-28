//
//  WbqDanmuView.h
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/25.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WbqDanmuConfiguration.h"
#import "WbqDanmuModelProtoco.h"



@class WbqDanmuView;

@protocol WbqDanmuViewDelegate <NSObject>

/**
 *  获取当前的时间
 */
- (NSTimeInterval)danmuViewCurrentTime:(WbqDanmuView *)danmuView;

/**
 *  获取弹幕视图
 */
- (UIView *)danmuCellWithModel:(id<WbqDanmuModelProtocol>)model;



@end


@interface WbqDanmuView : UIView

@property (weak, nonatomic) id<WbqDanmuViewDelegate> delegate;

/**
 *  弹幕开始
 */
-(void)start;

/**
 *  弹幕暂停
 */
-(void)pause;

/**
 *  弹幕继续
 */
-(void)resume;

/**
 *  需要展示的所有弹幕
 */
@property (nonatomic, strong) NSMutableArray <id <WbqDanmuModelProtocol>>* needDisplayModelArr;

/**
 *  配置项
 */
@property (nonatomic,strong) WbqDanmuConfiguration * configuration;


@end
