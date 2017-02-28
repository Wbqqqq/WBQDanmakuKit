//
//  MP4ViewController.m
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/28.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "MP4ViewController.h"
#import "WbqDanmuView.h"
#import "TestModel.h"
#import "XMLDictionary.h"
#import "TestLabel.h"
/** 随机色 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define DBRandomColor_RGB RGBCOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface MP4ViewController ()<WbqDanmuViewDelegate>

@property (strong, nonatomic) IBOutlet WbqDanmuView *danmuView;


@end

@implementation MP4ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    _danmuView.delegate = self;
    _danmuView.ConfigDanmuType = MP4;
    _danmuView.DanmuNomalTrackNumber = 12;
    _danmuView.DanmuTopAndBottomTrackNumber = 12;
    _danmuView.needDisplayModelArr = [self getData];
    [_danmuView start];

}

//***************************************
/**
 * 两个必须实现的代理方法
 */
-(NSTimeInterval)danmuViewCurrentTime:(WbqDanmuView *)danmuView
{
    static double time = 0;
    time += _danmuView.DanmuTimeInterval;
    return time;
}


-(UIView *)danmuCellWithModel:(id<WbqDanmuModelProtocol>)model
{
    TestModel * m = (TestModel *)model;
    TestLabel * v = [[TestLabel alloc]init];
    v.text = m.text;
    v.font = m.font;
    v.textColor = m.color;
    [v sizeToFit];
    
    return v;
}

//***************************************


-(NSMutableArray * )getData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"danmu.xml" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary * dic = [NSDictionary dictionaryWithXMLData:data];
    
    NSArray *array = [dic objectForKey:@"d"];
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for (NSInteger i=0; i<array.count; i++) {
        TestModel * model = [[TestModel alloc] initWithDict:array[i]];
        if (model) {
            [mutableArray addObject:model];
        }
    }
    return mutableArray;

}





-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
