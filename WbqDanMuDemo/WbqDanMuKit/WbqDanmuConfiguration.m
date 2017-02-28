//
//  WbqDanmuConfiguration.m
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/26.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "WbqDanmuConfiguration.h"

@implementation WbqDanmuConfiguration


- (instancetype)init {
    if (self = [super init]) {
        
        _danmuType = LiveStream;
        
        _maxDisplayNumber = 100;
        _timeInterval = 0.3;
        _normalTrackNumber = 8;
        _topAndBottomTrackNumber = 8;
        _normalStartTrackIndex = 0;
        _normalEndTrackIndex = _normalTrackNumber ;
        
        _topStartTrackIndex = 0;
        _topEndTrackIndex = _topAndBottomTrackNumber;
        
        _bottomStartTrackIndex = _topAndBottomTrackNumber;
        _bottomEndTrackIndex = 0;
        
    }
    return self;
}

-(void)setNormalTrackNumber:(NSInteger)normalTrackNumber
{
    _normalTrackNumber = normalTrackNumber;
    _normalEndTrackIndex = _normalTrackNumber;
}

-(void)setTopAndBottomTrackNumber:(NSInteger)topAndBottomTrackNumber
{
    _topAndBottomTrackNumber = topAndBottomTrackNumber;
    _topEndTrackIndex = _topAndBottomTrackNumber;
    _bottomEndTrackIndex = _topAndBottomTrackNumber;

}

-(void)setNormalStartTrackIndex:(NSInteger)normalStartTrackIndex
{
    if(normalStartTrackIndex < 0 || normalStartTrackIndex > _normalTrackNumber)
    {
        return;
    }
    _normalStartTrackIndex = normalStartTrackIndex;
}

-(void)setNormalEndTrackIndex:(NSInteger)normalEndTrackIndex
{
    if(normalEndTrackIndex < _normalStartTrackIndex || normalEndTrackIndex > _normalTrackNumber)
    {
        return;
    }
    _normalEndTrackIndex = normalEndTrackIndex;
}

-(void)setTopStartTrackIndex:(NSInteger)topStartTrackIndex
{
    if(topStartTrackIndex < 0 || topStartTrackIndex > _topAndBottomTrackNumber)
    {
        return;
    }
    _topStartTrackIndex = topStartTrackIndex;
}


-(void)setTopEndTrackIndex:(NSInteger)topEndTrackIndex
{
    if(topEndTrackIndex < _topStartTrackIndex || topEndTrackIndex > _topAndBottomTrackNumber)
    {
        return;
    }
    _topEndTrackIndex = topEndTrackIndex;
}


-(void)setBottomStartTrackIndex:(NSInteger)bottomStartTrackIndex
{
    if(bottomStartTrackIndex < 0 || bottomStartTrackIndex > _topAndBottomTrackNumber)
    {
        return;
    }
    _bottomStartTrackIndex = bottomStartTrackIndex;
}

-(void)setBottomEndTrackIndex:(NSInteger)bottomEndTrackIndex
{
    if(bottomEndTrackIndex < _bottomStartTrackIndex || bottomEndTrackIndex > _topAndBottomTrackNumber)
    {
        return;
    }
    _bottomEndTrackIndex = bottomEndTrackIndex;

}


@end
