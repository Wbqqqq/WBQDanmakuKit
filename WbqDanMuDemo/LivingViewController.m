//
//  LivingViewController.m
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/28.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "LivingViewController.h"
#import "WbqDanmuConfiguration.h"
#import "WbqDanmuView.h"
#import "TestModel.h"
#import "YYFPSLabel.h"
/** 随机色 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define DBRandomColor_RGB RGBCOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface LivingViewController ()<WbqDanmuViewDelegate>

@property (strong, nonatomic) IBOutlet WbqDanmuView *xibView;

@end

@implementation LivingViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestModel *model1 = [[TestModel alloc] init];
    model1.beginTime = 0;
    model1.liveTime = 5;
    model1.positionType = DanmuTypeNormal;
    
    
    TestModel *model2 = [[TestModel alloc] init];
    model2.beginTime = 0;
    model2.liveTime = 8;
    model2.positionType = DanmuTypeNormal;
    
    TestModel *model3 = [[TestModel alloc] init];
    model3.beginTime = 0;
    model3.liveTime = 6;
    model3.positionType = DanmuTypeNormal;
    
    TestModel *model4 = [[TestModel alloc] init];
    model4.beginTime = 0;
    model4.liveTime = 3;
    model4.positionType = DanmuTypeNormal;
    
    
    
    [self.xibView.needDisplayModelArr addObject:model1];
    [self.xibView.needDisplayModelArr addObject:model2];
    [self.xibView.needDisplayModelArr addObject:model3];
    [self.xibView.needDisplayModelArr addObject:model4];
    [self.xibView.needDisplayModelArr addObject:model1];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    YYFPSLabel * lb = [[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 300,60, 30)];
    [self.view addSubview:lb];
    //用xib 和 init 都可以创建
    //   self.xibView = [[WbqDanmuView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    
    self.xibView.delegate = self;
    self.xibView.ConfigDanmuType = LiveStream;
    
    //你可以在开始之前设定一系列的配置
//    self.xibView.configuration.normalTrackNumber = 10;
    
    
    
    [self.xibView start];
    
}

- (IBAction)pause:(id)sender {
    
    [self.xibView pause];

}


- (IBAction)resume:(id)sender {
    
    [self.xibView resume];
    
}

- (IBAction)topDisplay:(id)sender {
    
    //上方下方显示 我这里用起始轨道和结束轨道来控制，但是两个值都不能大于最大的轨道数
    self.xibView.NormalStartIndex = 0;
    self.xibView.NormalEndIndex = 4;
    
    
    
    
    
}
- (IBAction)bottomDisPlay:(id)sender{
    
    self.xibView.NormalStartIndex = 4;
    self.xibView.NormalEndIndex = 8;
    
}
- (IBAction)allDisPlay:(id)sender {
    
    self.xibView.NormalStartIndex = 0;
    self.xibView.NormalEndIndex = 8;
    
}

-(NSTimeInterval)danmuViewCurrentTime:(WbqDanmuView *)danmuView
{
    return 0;
}


-(UIView *)danmuCellWithModel:(id<WbqDanmuModelProtocol>)model
{
    
    UILabel * v = [[UILabel alloc]init];
    v.text = [NSString stringWithFormat:@"你好啊啊啊啊啊%d",arc4random_uniform(100)];
    [v sizeToFit];
    v.textColor = DBRandomColor_RGB;
    return v;
}


@end
