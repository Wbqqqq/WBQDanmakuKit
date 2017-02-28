//
//  WbqDanmuView.m
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/25.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "WbqDanmuView.h"
#import "CALayer+Aimate.h"
#import "NSTimer+WbqBlockSupport.h"

#define NSLog(...) NSLog(__VA_ARGS__)

@interface WbqDanmuView()
{
    NSInteger _index;
    
    NSTimeInterval _lastTime;
}


/**
 *  定时器
 */
@property(nonatomic,strong)NSTimer * timer;

/**
 *  当前展示弹幕的数组
 */
@property(nonatomic,strong)NSMutableArray * currenDisplaytDanmuArr;

/**
 *  普通轨道等待时间数组
 */
@property(nonatomic,strong)NSMutableArray * normalTrackWaitTimeArr;

/**
 *  普通轨道剩余时间数组
 */
@property(nonatomic,strong)NSMutableArray * normalTrackLeftTimeArr;


/**
 *  上下弹幕展示的轨道数组
 */
@property(nonatomic,strong)NSMutableArray * topAndBottomTrackLeftTimeArr;



@end

@implementation WbqDanmuView

-(void)dealloc
{
    NSLog(@"弹幕释放了哟");
    [self.timer invalidate];
    self.timer = nil;

}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.configuration = [[WbqDanmuConfiguration alloc]init];
    self.needDisplayModelArr = [NSMutableArray new];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.userInteractionEnabled = NO;
    self.clipsToBounds = YES;

}

-(instancetype)init
{
    if (self = [super init])
    {
        self.configuration = [[WbqDanmuConfiguration alloc]init];
        self.needDisplayModelArr = [NSMutableArray new];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.configuration = [[WbqDanmuConfiguration alloc]init];
        self.needDisplayModelArr = [NSMutableArray new];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)start {
    
    if (self.timer) {
        return;
    }
    
    if (!self.currenDisplaytDanmuArr.count) {
        //当前没有展示的数组
        [self layoutIfNeeded];
        __weak typeof(self)  weakSelf = self;
        self.timer = [NSTimer wbq_timerWithTimeInterval:self.DanmuTimeInterval block:^{
            [weakSelf checkAndBiuBiuBiu];
        } repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
    else {
        //当前有展示数组
        [self resume];
    }

}

-(void)pause
{
    [[self.currenDisplaytDanmuArr valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(pauseAnimate)];
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)resume
{
    if(self.timer)
    {
        return;
    }
    
    [[self.currenDisplaytDanmuArr valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(resumeAnimate)];
    
    __weak typeof(self)  weakSelf = self;
    self.timer = [NSTimer wbq_timerWithTimeInterval:self.DanmuTimeInterval block:^{
        [weakSelf checkAndBiuBiuBiu];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


-(void)checkAndBiuBiuBiu
{
    // 实时更新弹道记录的时间信息
    for (int i = 0; i < self.DanmuNomalTrackNumber; i++) {
        
        double normalwaitValue = [self.normalTrackWaitTimeArr[i] doubleValue] - self.DanmuTimeInterval;
        if (normalwaitValue <= 0.0) {
            normalwaitValue = 0.0;
        }
        self.normalTrackWaitTimeArr[i] = @(normalwaitValue);
        
        double normalleftValue = [self.normalTrackLeftTimeArr[i] doubleValue] - self.DanmuTimeInterval;
        if (normalleftValue <= 0.0) {
            normalleftValue = 0.0;
        }
        self.normalTrackLeftTimeArr[i] = @(normalleftValue);

    }
    
    for (int i = 0; i < self.DanmuTopAndBottomTrackNumber; i++) {
        
        double topbottomleftValue = [self.topAndBottomTrackLeftTimeArr[i] doubleValue] - self.DanmuTimeInterval;
        if (topbottomleftValue <= 0.0) {
            topbottomleftValue = 0.0;
        }
        self.topAndBottomTrackLeftTimeArr[i] = @(topbottomleftValue);
        
    }
    
   

    
    //将要展示的弹幕
    NSArray * danmuArr;
    if(self.configuration.danmuType == MP4)
    {
        NSTimeInterval time = [self.delegate danmuViewCurrentTime:self];
        danmuArr = [self getMp4DisplayDanmuWithTime:time];
    }
    else
    {
        danmuArr = [self getLiveStreamDisplayDanmu];
    }
    
    NSInteger index = 0;
    
    //如果将要展示的弹幕数超过最大展示的弹幕数，摒弃一些弹幕。
    
    if ([danmuArr count] + self.currenDisplaytDanmuArr.count > self.DanmuMaxDisplayNumber) {
        
        index = [danmuArr count] - ( self.DanmuMaxDisplayNumber - self.currenDisplaytDanmuArr.count);
        
        NSLog(@"太多啦爆炸了。。/(ㄒoㄒ)/~~");
        
    }
    
    //去发射。
    for (NSInteger i=index; i< danmuArr.count; i++) {
        [self displayDanmu:danmuArr[i]];
    }

}




/**
 *  核心代码
 @param model 协议model
 */
-(void)displayDanmu:(id<WbqDanmuModelProtocol>)model
{
   
    UIView * danmuCell = [self.delegate danmuCellWithModel:model];
    
    [self addSubview:danmuCell];
    
    [self.currenDisplaytDanmuArr addObject:danmuCell];
    
    NSUInteger index;
    if (model.positionType == DanmuTypeNormal) {
        
        index = [self NormalDanmuDisplayTrackIndexWithModel:model];
        [self startNomalDanmuWith:model TrackPosition:index Cell:danmuCell];
        
    }
    else if (model.positionType == DanmuTypeTop) {
        index = [self TopDanmuDisplayTrackIndexWithModel:model];
        [self startTopBottomDanmuWith:model TrackPosition:index Cell:danmuCell];

    }
    else if (model.positionType == DanmuTypeBottom) {
        
        index = [self BottomDanmuDisplayTrackIndexWithModel:model];
        [self startTopBottomDanmuWith:model TrackPosition:index Cell:danmuCell];
        
    }

}


-(NSUInteger)NormalDanmuDisplayTrackIndexWithModel:(id<WbqDanmuModelProtocol>)model
{
    UIView *danmuCell = [self.delegate danmuCellWithModel:model];
    
    
    for (NSInteger index = self.NormalStartIndex; index < self.NormalEndIndex; index++) {
        
        NSTimeInterval waitTime = [self.normalTrackWaitTimeArr[index] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }
        
        NSTimeInterval leftTime = [self.normalTrackLeftTimeArr[index] doubleValue];
        
        double speed = (danmuCell.frame.size.width + self.frame.size.width) / model.liveTime;
        
        double distance = leftTime * speed;
        
        //加20防止紧贴显示。
        if (distance > self.frame.size.width + 20) {
            continue;
        }
        
        self.normalTrackWaitTimeArr[index] = @(danmuCell.frame.size.width / speed);
        self.normalTrackLeftTimeArr[index] = @(model.liveTime);
        
        return index;
        
    }
    
    NSInteger index = self.NormalStartIndex;
    
    NSTimeInterval minTime = [self.normalTrackLeftTimeArr[self.NormalStartIndex] doubleValue];
    //没有遍历到轨道位置，没办法，碰撞输出。
    for (NSInteger idx = self.NormalStartIndex ; idx < self.NormalEndIndex; idx++) {
        NSTimeInterval animateDuration = [self.normalTrackLeftTimeArr[idx] doubleValue];
        //取出剩余展示时间最小的轨道。
        if (animateDuration < minTime) {
            index = idx;
            minTime = animateDuration;
        }
    }
    
    // 重置数据
    double speed = (danmuCell.frame.size.width + self.frame.size.width) / model.liveTime;
    self.normalTrackWaitTimeArr[index] = @(danmuCell.frame.size.width / speed);
    self.normalTrackLeftTimeArr[index] = @(model.liveTime);
    
    return index;
    
}


-(NSUInteger)TopDanmuDisplayTrackIndexWithModel:(id<WbqDanmuModelProtocol>)model
{
    for (NSInteger index = self.TopStartIndex; index < self.TopEndIndex; index++)
    {
        
        NSTimeInterval waitTime = [self.topAndBottomTrackLeftTimeArr[index] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }
        
        self.topAndBottomTrackLeftTimeArr[index] = @(model.liveTime);
        return index;
        
    }
    
    NSInteger index = self.TopStartIndex;
    
    NSTimeInterval minTime = [self.topAndBottomTrackLeftTimeArr[self.TopStartIndex] doubleValue];
    //没有遍历到轨道位置，没办法，碰撞输出。
    for (NSInteger idx = self.TopStartIndex; idx < self.TopEndIndex; idx++) {
        NSTimeInterval animateDuration = [self.topAndBottomTrackLeftTimeArr[idx] doubleValue];
        //取出剩余展示时间最小的轨道。
        if (animateDuration < minTime) {
            index = idx;
            minTime = animateDuration;
        }
    }
    // 重置数据
    self.topAndBottomTrackLeftTimeArr[index] = @(model.liveTime);
    return index;
    
}

- (NSInteger)BottomDanmuDisplayTrackIndexWithModel:(id<WbqDanmuModelProtocol>)model
{
    for (NSInteger index = self.BottomStartIndex - 1; index > 0 ; index--)
    {
        
        NSTimeInterval waitTime = [self.topAndBottomTrackLeftTimeArr[index] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }
        
        self.topAndBottomTrackLeftTimeArr[index] = @(model.liveTime);
        
        return index;
        
    }
    
    NSInteger index = self.BottomStartIndex - 1;
    
    NSTimeInterval minTime = [self.topAndBottomTrackLeftTimeArr[index] doubleValue];
    //没有遍历到轨道位置，没办法，碰撞输出。
    for (NSInteger idx = self.BottomStartIndex - 1 ; idx > 0; idx--) {
        NSTimeInterval animateDuration = [self.topAndBottomTrackLeftTimeArr[idx] doubleValue];
        //取出剩余展示时间最小的轨道。
        if (animateDuration < minTime) {
            index = idx;
            minTime = animateDuration;
        }
    }
    // 重置数据
    self.topAndBottomTrackLeftTimeArr[index] = @(model.liveTime);
    return index;
}

/**
 *  普通弹幕动画
 */
-(void)startNomalDanmuWith:(id<WbqDanmuModelProtocol>)model TrackPosition:(NSUInteger)index Cell:(UIView *)cell
{
    cell.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat position = (CGFloat)((CGFloat)index/(CGFloat)self.DanmuNomalTrackNumber);
    if(position == 0.0)
    {
        //代码约束的比例不能是0，只能是无穷小，这步比较重要。
        position =  CGFLOAT_MIN;
    }
    NSLayoutConstraint *topcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:position constant:0];
    [self addConstraint:topcons];
  
    NSLayoutConstraint *leftcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self addConstraint:leftcons];

    NSLayoutConstraint *widthcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:cell.frame.size.width];
    [cell addConstraint:widthcons];
    
    
    NSLayoutConstraint *heightcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:cell.frame.size.height];
    [cell addConstraint:heightcons];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:model.liveTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        NSLayoutConstraint *rightcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        [self removeConstraint:leftcons];
        [self addConstraint:rightcons];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [cell removeFromSuperview];
        [self.currenDisplaytDanmuArr removeObject:cell];
        
    }];
}


/**
 *  上下方弹幕动画
 */
-(void)startTopBottomDanmuWith:(id<WbqDanmuModelProtocol>)model TrackPosition:(NSUInteger)index Cell:(UIView *)cell
{
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat f = cell.alpha;
    
    CGFloat position = (CGFloat)((CGFloat)index/(CGFloat)self.DanmuTopAndBottomTrackNumber);
    if(position == 0.0)
    {
        //代码约束的比例不能是0，只能是无穷小，这步比较重要。
        position =  CGFLOAT_MIN;
    }
    NSLayoutConstraint *topcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:position constant:0];
    [self addConstraint:topcons];
    
    NSLayoutConstraint *centertcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:centertcons];
    
    NSLayoutConstraint *widthcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:cell.frame.size.width];
    [cell addConstraint:widthcons];
    
    
    NSLayoutConstraint *heightcons = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:cell.frame.size.height];
    [cell addConstraint:heightcons];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:model.liveTime animations:^{
        
        //好像这个地方必须写点什么  否则会不执行跳到结果。
        cell.alpha = f + 0.01;
        
    } completion:^(BOOL finished) {
        
        [cell removeFromSuperview];
        [self.currenDisplaytDanmuArr removeObject:cell];
        
    }];
    
}







- (NSArray<id<WbqDanmuModelProtocol>> *)getMp4DisplayDanmuWithTime:(NSTimeInterval)time {
    
    if ([self.needDisplayModelArr count] == 0) {
        return NULL;
    }
    
    if (fabs(time - _lastTime) > 5) {
        //拖拉时间间隔大于5秒时，第一次获取返回空，定位到当前的时间的弹幕位置。
        for (NSInteger i=0; i<self.needDisplayModelArr.count; i++) {

            if (self.needDisplayModelArr[i].beginTime > time) {
                
                _index = i;
                
                break;
            }
        }
        
        _lastTime = time;
        
        return @[];
    }
    
    _lastTime = time;
    
    NSInteger idx = _index;
    
    for (NSInteger i=_index; i<self.needDisplayModelArr.count; i++) {
        
        idx = i;
        
        if (self.needDisplayModelArr[i].beginTime  >  time ) {
            
            break;
        }
    }
    
    NSMutableArray *danmuArr = [NSMutableArray new];
    
    for (NSInteger i=_index; i<idx; i++) {
        
        [danmuArr addObject:self.needDisplayModelArr[i]];
        
    }
    
    _index = idx;

    return danmuArr;
}

- (NSArray<id<WbqDanmuModelProtocol>> *)getLiveStreamDisplayDanmu
{
    NSMutableArray *danmuArr = [NSMutableArray new];
    
    danmuArr = [self.needDisplayModelArr copy];
    
    [self.needDisplayModelArr removeAllObjects];
    
    return danmuArr;
}




-(void)setNeedDisplayModelArr:(NSMutableArray<id<WbqDanmuModelProtocol>> *)needDisplayModelArr
{
    _needDisplayModelArr = needDisplayModelArr;
    [_needDisplayModelArr sortUsingComparator:^NSComparisonResult(id <WbqDanmuModelProtocol> _Nonnull obj1, id <WbqDanmuModelProtocol> _Nonnull obj2) {
    
        //升序排列
         return obj1.beginTime > obj2.beginTime;
        
    }];
}


#pragma mark - 懒加载


-(NSMutableArray *)normalTrackWaitTimeArr
{
    if(!_normalTrackWaitTimeArr)
    {
        _normalTrackWaitTimeArr =[NSMutableArray arrayWithCapacity:self.DanmuNomalTrackNumber];
        for (NSInteger i=0; i<self.DanmuNomalTrackNumber; i++) {
            _normalTrackWaitTimeArr[i] = @0.0;
        }
    }
    return _normalTrackWaitTimeArr;
}

-(NSMutableArray *)normalTrackLeftTimeArr
{
    if(!_normalTrackLeftTimeArr)
    {
        _normalTrackLeftTimeArr =[NSMutableArray arrayWithCapacity:self.DanmuNomalTrackNumber];
        for (NSInteger i=0; i<self.DanmuNomalTrackNumber; i++) {
            _normalTrackLeftTimeArr[i] = @0.0;
        }
    }
    return _normalTrackLeftTimeArr;
}



-(NSMutableArray *)topAndBottomTrackLeftTimeArr
{
    if(!_topAndBottomTrackLeftTimeArr)
    {
        _topAndBottomTrackLeftTimeArr =[NSMutableArray arrayWithCapacity:self.DanmuTopAndBottomTrackNumber];
        for (NSInteger i=0; i<self.DanmuTopAndBottomTrackNumber; i++) {
            _topAndBottomTrackLeftTimeArr[i] = @0.0;
        }
    }
    return _topAndBottomTrackLeftTimeArr;
}


-(NSMutableArray *)currenDisplaytDanmuArr
{
    if(!_currenDisplaytDanmuArr)
    {
        _currenDisplaytDanmuArr = [NSMutableArray new];
    }
    return _currenDisplaytDanmuArr;
}



@end
