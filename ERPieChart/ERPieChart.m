//
//  ERPieChart.m
//  ERChartDemo
//
//  Created by 王耀杰 on 16/2/17.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import "ERPieChart.h"

@interface ERPieChart (){
    /**
     *  总数据
     */
    CGFloat sum;
    /**
     *  记录起始弧度
     */
    CGFloat startRadian;
    /**
     *  记录终止弧度
     */
    CGFloat endRadian;
    /**
     *  圆心
     */
    CGPoint centerP;
    /**
     *  临时记录颜色
     */
    UIColor *tempColor;
    /**
     *   是否随机色
     */
    BOOL isRandomColor;
    /**
     *  是否部分随机色
     */
    BOOL isRandomHalfColor;
    /**
     *  记录上一次随机色
     */
    UIColor *LastTempColor;
    float add;
    float temp;
    int bounses;
    BOOL isAdd;
}

//创建全局属性
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int colorsCount;

@end

@implementation ERPieChart
ERPieChartStyle PieStyle;


- (ERPieChart *)initWithStyle:(ERPieChartStyle)ERPieStyle {
    ERPieChart *pieChart = [[ERPieChart alloc] init];
    pieChart.backgroundColor = [UIColor whiteColor];
    PieStyle = ERPieStyle;
    
    return pieChart;
}
- (void)refresh {
    [self pieChartAnimation];
}
- (void)drawRect:(CGRect)rect {
    if (PieStyle == ERPieChartBasic) {
        [self pieChartBasic];
    }
}

- (void)pieChartBasic {
    // 圆心
    centerP = CGPointMake(self.radius, self.radius);
    
    // 起始和终止弧度
    startRadian = self.start - M_PI_2;
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 计算总数据
    for (int i = 0; i < self.datas.count; i++) {
        sum += [self.datas[i] floatValue];
    }
    
    // 循环data中的数据, 绘制对应的扇形
    for (int i = 0; i < self.datas.count; i++) {
        
        
        // 计算弧度
        endRadian = [self.datas[i] floatValue] / sum * M_PI * 2 + startRadian;
        
        // 创建一个UIBezierPath对象（表示一个扇形）
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerP radius:self.radius startAngle:startRadian endAngle:endRadian clockwise:YES];
        [path addLineToPoint:CGPointMake(self.radius, self.radius)];
        
        // 把这个UIBezierPaht对象添加到上下文中
        CGContextAddPath(ctx, path.CGPath);
        
        // 设置下一个扇形的起始弧度, 为上一个扇形的终止弧度
        startRadian = endRadian;
        
        // 取出颜色
        tempColor = self.colors[i];
        
        // 设置颜色
        [tempColor set];
        
        // 渲染
        CGContextDrawPath(ctx, kCGPathFill);
    }
    // 还原值
    startRadian = self.start - M_PI_2;
    sum = 0.0;
    bounses = 3;
    // 空心圆
    if (_airCircleRadius) {
        UIBezierPath *airPath = [UIBezierPath bezierPathWithArcCenter:centerP radius:_airCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [_airCircleColor set];
        CGContextAddPath(ctx, airPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
    }
}

- (void)pieChartAnimation {
    // 圆心
    centerP = CGPointMake(self.radius, self.radius);
    
    CAShapeLayer *rootLayer = [CAShapeLayer layer];
    rootLayer.position = centerP;
    rootLayer.bounds = self.bounds;
    [self.layer addSublayer:rootLayer];
    
    // 计算总数据
    for (int i = 0; i < self.datas.count; i++) {
        sum += [self.datas[i] floatValue];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerP radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    for (int i = 0; i<self.datas.count; i++) {
        CAShapeLayer *pieLayer = [CAShapeLayer layer];
        // 计算弧度
        endRadian = [self.datas[i] floatValue] / sum  + startRadian;
        
        pieLayer.fillColor   = [UIColor clearColor].CGColor;
        tempColor = self.colors[i];
        
        pieLayer.strokeColor = tempColor.CGColor;
        pieLayer.strokeStart = startRadian;
        pieLayer.strokeEnd   = endRadian;
        
        
        pieLayer.lineWidth   = self.radius * 2 - self.airCircleRadius * 2;
        pieLayer.path        = path.CGPath;
        [rootLayer addSublayer:pieLayer];
        startRadian = endRadian;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    UIBezierPath *pathM = [UIBezierPath bezierPathWithArcCenter:centerP radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    maskLayer.fillColor   = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.strokeStart = 0;
    maskLayer.strokeEnd   = 1;
    maskLayer.lineWidth   = self.radius * 2;
    maskLayer.path        = pathM.CGPath;
    
    rootLayer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = 1;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [rootLayer.mask addAnimation:animation forKey:@"circleAnimation"];
}

-(NSArray *)colors {
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_colors];
    if (_colors == nil || isRandomColor) {
        for (int i = 0; i<self.datas.count; i++) {
            arrayM[i] = [self randomDifferentColor];
        }
        isRandomColor = YES;
        _colors = arrayM.copy;
    }else {
        // 有值
        for (int i = 0; i<self.colorsCount; i++) {
            ERRORISKINDOFUICOLORCLASS
        }
        // 有值但是不全,用随机色弥补
        if (_colorsCount < self.datas.count || isRandomHalfColor) {
            for (int i = _colorsCount; i < self.datas.count; i++) {
                arrayM[i] =[self randomDifferentColor];
            }
            isRandomHalfColor = YES;
            _colors = arrayM.copy;
        }
        // 有值，但是比data数组多,只取前 self.datas.count
        if (_colors.count > self.colorsCount) {
            for (int i = 0; i < self.datas.count; i++) {
                arrayM[i] = _colors[i];
            }
            _colors = arrayM.copy;
        }
    }
    return _colors;
}
// 绝对随机色
- (UIColor *)randomDifferentColor {
    
    while (YES) {
        tempColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        if (tempColor != LastTempColor) {
            break;
        }
    }
    LastTempColor = tempColor;
    return LastTempColor;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    CGRect bounds = self.bounds;
    bounds.size.width = radius * 2;
    bounds.size.height = radius * 2;
    self.bounds = bounds;
    
    self.layer.cornerRadius = self.radius;
    self.layer.masksToBounds = YES;
    
}

- (int)colorsCount {
    if (_colorsCount == 0) {
        _colorsCount = (int)_colors.count;
    }
    return _colorsCount;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    if (PieStyle == ERPieChartAnimation) {
        [self pieChartAnimation];
    }
}

@end
