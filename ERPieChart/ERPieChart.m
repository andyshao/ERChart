//
//  ERPieChart.m
//  ERChartDemo
//
//  Created by 王耀杰 on 16/2/17.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import "ERPieChart.h"

@interface ERPieChart ()
/**
 *  记录上一次随机色
 */
@property (nonatomic, strong) UIColor *LastTempColor;
/**
 *  颜色数量
 */
@property (nonatomic, assign) int colorsCount;
/**
 *  是否部分随机色
 */
@property (nonatomic, assign) BOOL isRandomHalfColor;
/**
 *   是否随机色
 */
@property (nonatomic, assign) BOOL isRandomColor;
/**
 *  临时记录颜色
 */
@property (nonatomic, strong) UIColor *tempColor;
/**
 *  圆心
 */
@property (nonatomic, assign) CGPoint centerP;
/**
 *  总数据
 */
@property (nonatomic, assign) CGFloat sum;
/**
 *  记录起始弧度
 */
@property (nonatomic, assign) CGFloat startRadian;
/**
 *  记录终止弧度
 */
@property (nonatomic, assign) CGFloat endRadian;
/**
 *  记录title的center属性的数组
 */
@property (nonatomic, strong) NSArray *titlesCenter;

@end

@implementation ERPieChart
ERPieChartStyle PieStyle;

- (ERPieChart *)initWithStyle:(ERPieChartStyle)ERPieStyle {
    ERPieChart *pieChart = [[ERPieChart alloc] init];
    pieChart.backgroundColor = [UIColor whiteColor];
    PieStyle = ERPieStyle;
    return pieChart;
}


- (void)drawRect:(CGRect)rect {
    if (PieStyle == ERPieChartBasic) {
        [self pieChartBasic];
    }
    if (PieStyle == ERPieChartAnimation) {
        [self pieChartAnimation];
    }
}

- (void)pieChartBasic {
    // 圆心
    _centerP = CGPointMake(self.radius, self.radius);
    // 起始和终止弧度
    _startRadian = self.start - M_PI_2;
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 循环data中的数据, 绘制对应的扇形
    for (int i = 0; i < self.datas.count; i++) {
        // 计算弧度
        _endRadian = [self.datas[i] floatValue] / self.sum * M_PI * 2 + _startRadian;
        // 创建一个UIBezierPath对象（表示一个扇形）
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_centerP radius:self.radius startAngle:_startRadian endAngle:_endRadian clockwise:YES];
        [path addLineToPoint:CGPointMake(self.radius, self.radius)];
        // 把这个UIBezierPaht对象添加到上下文中
        CGContextAddPath(ctx, path.CGPath);
        // 设置下一个扇形的起始弧度, 为上一个扇形的终止弧度
        _startRadian = _endRadian;
        // 取出颜色
        _tempColor = self.colors[i];
        // 设置颜色
        [_tempColor set];
        // 渲染
        CGContextDrawPath(ctx, kCGPathFill);
    }
    // 还原值
    _startRadian = self.start - M_PI_2;
    self.sum = 0.0;
    // 空心圆
    if (_airCircleRadius) {
        UIBezierPath *airPath = [UIBezierPath bezierPathWithArcCenter:_centerP radius:_airCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [_airCircleColor set];
        CGContextAddPath(ctx, airPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
    }
    [self loadTitles];
}

- (void)pieChartAnimation {
    // 圆心
    _centerP = CGPointMake(self.radius, self.radius);
    CAShapeLayer *rootLayer = [CAShapeLayer layer];
    rootLayer.position = _centerP;
    rootLayer.bounds = self.bounds;
    [self.layer addSublayer:rootLayer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_centerP radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    for (int i = 0; i<self.datas.count; i++) {
        CAShapeLayer *pieLayer = [CAShapeLayer layer];
        // 计算弧度
        _endRadian = [self.datas[i] floatValue] / self.sum+ _startRadian;
        pieLayer.fillColor   = [UIColor clearColor].CGColor;
        _tempColor = self.colors[i];
        pieLayer.strokeColor = _tempColor.CGColor;
        pieLayer.strokeStart = _startRadian;
        pieLayer.strokeEnd   = _endRadian;
        pieLayer.lineWidth   = self.radius * 2 - self.airCircleRadius * 2;
        pieLayer.path        = path.CGPath;
        [rootLayer addSublayer:pieLayer];
        _startRadian = _endRadian;
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *pathM = [UIBezierPath bezierPathWithArcCenter:_centerP radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
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
    if (_colors == nil || self.isRandomColor) {
        for (int i = 0; i<self.datas.count; i++) {
            arrayM[i] = [self randomDifferentColor];
        }
        self.isRandomColor = YES;
        _colors = arrayM.copy;
    }else {
        // 有值
        for (int i = 0; i<self.colorsCount; i++) {
            ERRORISKINDOFUICOLORCLASS
        }
        // 有值但是不全,用随机色弥补
        if (_colorsCount < self.datas.count || self.isRandomHalfColor) {
            for (int i = _colorsCount; i < self.datas.count; i++) {
                arrayM[i] =[self randomDifferentColor];
            }
            self.isRandomHalfColor = YES;
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

- (void)loadTitles {
    [self calculateTitleLabelCenter];
    for (int i = 0; i < self.titlesCenter.count; i++) {
        UILabel *title = [[UILabel alloc] init];
        title.text = self.titles[i];
        title.textColor = self.titleColor;
        title.font = [UIFont systemFontOfSize:self.titleSize];
        title.textAlignment = NSTextAlignmentCenter;
//>>>>>>>>>>>>>>  这两句代码交换会造成文字不能居中问题
        [title sizeToFit];
        title.center = [self.titlesCenter[i] CGPointValue];
//<<<<<<<<<<<<<<<<
        [self addSubview:title];
        
        
    }
    
    
    
}

- (void)calculateTitleLabelCenter {
    // 开始的度数为北方为正方向0°
    // 记录开始度数
    CGFloat star = self.start;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (int i = 0 ; i< self.titles.count; i++) {
        
        CGFloat alp =([self.datas[i] floatValue] / self.sum) * M_PI * 2 / 2+ star;
        
        // 算出起始的半径的中点的坐标
        CGFloat titleX = self.radius + sin(alp) * self.radius / 2 ;
        CGFloat titleY = self.radius - cos(alp) * self.radius / 2;
        
        CGPoint center = CGPointMake(titleX, titleY);
        [arrayM addObject:[NSValue valueWithCGPoint:center]];
        
        
        star = ([self.datas[i] floatValue] / self.sum) * M_PI * 2 + star;
        NSLog(@"start -- %f",star);
}
    self.titlesCenter = arrayM.copy;
    
}

// 绝对随机色
- (UIColor *)randomDifferentColor {
    while (YES) {
        _tempColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        if (_tempColor != self.LastTempColor) {
            break;
        }
    }
    self.LastTempColor = _tempColor;
    return self.LastTempColor;
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
//chartclu
- (CGFloat)sum {
    // 计算总数据
    _sum = 0;
    for (int i = 0; i < self.datas.count; i++) {
        _sum += [self.datas[i] floatValue];
    }
    return _sum;
}

- (int)colorsCount {
    if (_colorsCount == 0) {
        _colorsCount = (int)_colors.count;
    }
    return _colorsCount;
}

- (NSArray *)titlesCenter {
    if (_titlesCenter == nil) {
        _titlesCenter = [NSArray array];
    }
    return _titlesCenter;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
