//
//  testModel.m
//  WbqDanMuDemo
//
//  Created by wbq on 17/2/26.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "TestModel.h"

#define HexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Font(fontSize) [UIFont fontWithName:@"ArialMT" size:fontSize]
@implementation TestModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _text = [dict objectForKey:@"__text"];
        NSArray *parameters = [[dict objectForKey:@"_p"] componentsSeparatedByString:@","];
        if ([parameters count] != 8) {
            return nil;
        }
        
        
        _beginTime = [parameters[0] doubleValue];
        NSInteger colorHex = [parameters[3] integerValue];
        _color = HexColor(colorHex);
        
        NSInteger type = [parameters[1] integerValue];
        if (type == 1) {
            _positionType = DanmuTypeNormal;
        }
        else if (type == 5) {
            _positionType = DanmuTypeTop;
        }
        else if (type == 4) {
            _positionType = DanmuTypeBottom;
        }
        else {
            return nil;
        }
        
        _liveTime = 6;
        
        _font = Font(round([parameters[2] integerValue] / 2.0));
        
    }
    return self;
}


@end
