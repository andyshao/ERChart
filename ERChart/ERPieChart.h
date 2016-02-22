//
//  ERPieChart.h
//  ERChartDemo
//
//  Created by 王耀杰 on 16/2/17.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ERRORISKINDOFUICOLORCLASS NSAssert([_colors[i] isKindOfClass:[UIColor class]], @"颜色数组里有非UIColor对象！");



typedef NS_ENUM(NSInteger, ERPieChartStyle) {
    ERPieChartBasic,
    ERPieChartAnimation
};

@interface ERPieChart : UIView
/**
 *  Pie Chart 数据数组，按照数组顺序有序排列
 */
@property (nonatomic, strong) NSArray *datas;
/**
 *  Pie Chart 半径
 */
@property (nonatomic, assign) CGFloat radius;
/**
 *  Pie Chart 起点度数，12点方向为0°
 */
@property (nonatomic, assign) CGFloat start;
/**
 *  Pie Chart 颜色数组,默认为随机色
 */
@property (nonatomic, strong) NSArray *colors;
/**
 *  Pie Chart 空心圆的半径
 */
@property (nonatomic, assign) CGFloat airCircleRadius;
/**
 *  Pie Chart 空心圆的颜色
 */
@property (nonatomic, strong) UIColor *airCircleColor;
/**
 *  Pie Chart Title标题数组
 */
@property (nonatomic, strong) NSArray *titles;
/**
 *  Pie Chart Title标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  Pie Chart Title标题大小
 */
@property (nonatomic, assign) CGFloat titleSize;
/**
 *  Pie Chart 隐藏标题的属性
 */
@property (nonatomic, assign) BOOL isHideTitle;
/**
 *  Pie Chart 隐藏百分比
 */
@property (nonatomic, assign) BOOL isHidePercentage;

- (ERPieChart *)initWithStyle:(ERPieChartStyle)ERPieStyle;

@end
