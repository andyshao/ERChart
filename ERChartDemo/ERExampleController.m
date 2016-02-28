//
//  ERExampleController.m
//  ERPieChartDemo
//
//  Created by 王耀杰 on 16/2/21.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import "ERExampleController.h"
#import "ERPieChart.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define MARGIN 12

@interface ERExampleController ()

@property (nonatomic, weak) ERPieChart *pieChart;

@property (nonatomic, weak) UISlider *AirRadiuSlider;
@property (nonatomic, weak) UISlider *radiuSlider;

@end

@implementation ERExampleController

// >>>>>>>>>>>>>>>> Demo 示例参数 <<<<<<<<<<<<<<<<<<<<<
CGFloat radiu = 100;
CGFloat AirRadius = 50;
BOOL isHideTitle = NO;
BOOL isHidePercent = NO;
#define DATAS @[@20,@30,@40,@50,@60]
#define CENTER CGPointMake(SCREENW * .5, SCREENH * .3)
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    if ([self.navigationItem.title isEqualToString:@"Basic Pie Chart"]) {
        [self basicPieChartDemo];
        [self loadBasicPieChartUI];
    }
    if ([self.navigationItem.title isEqualToString:@"Animation Pie Chart"]) {
        [self animationPieChartDemo];
        [self loadBasicPieChartUI];
    }

}

- (void)basicPieChartDemo {
    ERPieChart *pieChart = [[ERPieChart alloc] init];
    _pieChart = pieChart;
    pieChart.datas = DATAS;
    pieChart.center = CENTER;
    pieChart.radius = radiu;
    pieChart.airCircleRadius = AirRadius;
    pieChart.titles = @[@"Tencent",@"Alibaba",@"Baidu",@"Apple",@"Google"];
    pieChart.isHideTitle = isHideTitle;
    pieChart.isHidePercentage = isHidePercent;
    [self.view addSubview:pieChart];
}

- (void)animationPieChartDemo {
    ERPieChart *pieChart = [[ERPieChart alloc] initWithAnimationStyle:ERPieChartAnimation];
    _pieChart = pieChart;
    pieChart.datas = DATAS;
    pieChart.center = CENTER;
    pieChart.radius = radiu;
    pieChart.airCircleRadius = AirRadius;
    pieChart.titles = @[@"Tencent",@"Alibaba",@"Baidu",@"Apple",@"Google"];
    pieChart.isHideTitle = isHideTitle;
    pieChart.isHidePercentage = isHidePercent;
    [self.view addSubview:pieChart];
}

- (void)loadBasicPieChartUI {
    // 加载半径控制条
    [self loadRadiusSlider];
    // 加载内圆控制条
    [self loadAirCircleRadiusSlider];
    // 加载title隐藏button
    [self loadIsHideTitleButton];
    // 记载隐藏percent的button
    [self loadIsHidePercentButton];
    // 刷新button
    [self loadRefreshButton];
}

- (void)loadRadiusSlider {
    // Radiu Label
    UILabel *radiusLabel = [[UILabel alloc] init];
    radiusLabel.center = CGPointMake(MARGIN * 1.5, SCREENH * .5);
    radiusLabel.text = @"Radiu";
    radiusLabel.textAlignment = NSTextAlignmentCenter;
    [radiusLabel sizeToFit];
    [self.view addSubview:radiusLabel];
    // Radiu Slider
    CGFloat radiuSliderX = CGRectGetMaxX(radiusLabel.frame) + MARGIN;
    CGFloat radiuSliderY = SCREENH * .5 - radiusLabel.bounds.size.height * .25;
    CGFloat radiuSliderW = SCREENW - radiusLabel.frame.size.width - MARGIN * 2 - CGRectGetMinX(radiusLabel.frame);
    UISlider *radiuSlider = [[UISlider alloc] initWithFrame:CGRectMake(radiuSliderX, radiuSliderY, radiuSliderW, 0)];
    _radiuSlider = radiuSlider;
    radiuSlider.value = 1;
    [radiuSlider sizeToFit];
    [radiuSlider addTarget:self action:@selector(didChangeRadiuSlider:) forControlEvents:UIControlEventValueChanged];
    [radiuSlider addTarget:self action:@selector(didChangedComplete:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:radiuSlider];
}


- (void)didChangeRadiuSlider:(UISlider *)sender {
    radiu = sender.value * 100;
}

- (void)didChangedComplete:(UISlider *)sender {
    self.AirRadiuSlider.maximumValue = sender.value;
    [self refresh];
}

- (void)loadAirCircleRadiusSlider {
    // AirCircleRadius Label
    UILabel *AirRadiusLabel = [[UILabel alloc] init];
    AirRadiusLabel.center = CGPointMake(MARGIN * 1.5, SCREENH * .5 + MARGIN * 3);
    AirRadiusLabel.text = @"AirRadiu";
    AirRadiusLabel.textAlignment = NSTextAlignmentCenter;
    [AirRadiusLabel sizeToFit];
    [self.view addSubview:AirRadiusLabel];
    // Radiu Slider
    CGFloat radiuSliderX = CGRectGetMaxX(AirRadiusLabel.frame) + MARGIN;
    CGFloat radiuSliderY = SCREENH * .5 + MARGIN * 3 - AirRadiusLabel.bounds.size.height * .25;
    CGFloat radiuSliderW = SCREENW - AirRadiusLabel.frame.size.width - MARGIN * 2 - CGRectGetMinX(AirRadiusLabel.frame);
    UISlider *airRadiuSlider = [[UISlider alloc] initWithFrame:CGRectMake(radiuSliderX, radiuSliderY, radiuSliderW, 0)];
    _AirRadiuSlider = airRadiuSlider;
    airRadiuSlider.value = .5;
    [airRadiuSlider sizeToFit];
    [airRadiuSlider addTarget:self action:@selector(didChangeAirRadiuSlider:) forControlEvents:UIControlEventValueChanged];
    [airRadiuSlider addTarget:self action:@selector(didChangedAirRadiuComplete:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view addSubview:airRadiuSlider];
}

- (void)didChangeAirRadiuSlider:(UISlider *)sender {
    AirRadius = sender.value * 100;
}

- (void)didChangedAirRadiuComplete:(UISlider *)sender {
    self.radiuSlider.minimumValue = sender.value;
    [self refresh];
}

- (void)loadIsHideTitleButton {
    //isHideLabel
    UILabel *isHideLabel = [[UILabel alloc] init];
    CGFloat isHideLabelY = SCREENH * .5 + MARGIN * 6;
    isHideLabel.center = CGPointMake(MARGIN * 1.5, isHideLabelY);
    isHideLabel.text = @"isHideTitleLabel";
    isHideLabel.textAlignment = NSTextAlignmentCenter;
    [isHideLabel sizeToFit];
    [self.view addSubview:isHideLabel];
    //isHideButton
    UISwitch *isHideButton = [[UISwitch alloc] init];
    CGFloat isHideButtonX = CGRectGetMaxX(isHideLabel.frame) + MARGIN * 3;
    isHideButton.center = CGPointMake(isHideButtonX, isHideLabelY + MARGIN -2);
    [isHideButton addTarget:self action:@selector(didClickIsHideTitleButton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:isHideButton];
    
}

- (void)didClickIsHideTitleButton:(UISwitch *)sender {
    if (sender.on) {
        isHideTitle = YES;
    }
    if (!sender.on) {
        isHideTitle = NO;
    }
    [self refresh];
}

- (void)loadIsHidePercentButton {
    //isHideLabel
    UILabel *isHideLabel = [[UILabel alloc] init];
    CGFloat isHideLabelY = SCREENH * .5 + MARGIN * 9;
    isHideLabel.center = CGPointMake(MARGIN * 1.5, isHideLabelY);
    isHideLabel.text = @"isHidePercent";
    isHideLabel.textAlignment = NSTextAlignmentCenter;
    [isHideLabel sizeToFit];
    [self.view addSubview:isHideLabel];
    //isHideButton
    UISwitch *isHideButton = [[UISwitch alloc] init];
    CGFloat isHideButtonX = CGRectGetMaxX(isHideLabel.frame) + MARGIN * 3;
    isHideButton.center = CGPointMake(isHideButtonX, isHideLabelY + MARGIN -2);
    [isHideButton addTarget:self action:@selector(didClickIsHidePercentButton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:isHideButton];
    
}

- (void)didClickIsHidePercentButton:(UISwitch *)sender {
    if (sender.on) {
        isHidePercent = YES;
    }
    if (!sender.on) {
        isHidePercent = NO;
    }
    [self refresh];
}

- (void)loadRefreshButton {
    UIButton *button = [[UIButton alloc] init];
    button.center = CGPointMake(SCREENW * .5, SCREENH - MARGIN - 15);
    button.bounds = CGRectMake(0, 0, SCREENW * .8, 30);
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"Refresh" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)refresh {
    [self.pieChart removeFromSuperview];
//    [self basicPieChartDemo];
    if ([self.navigationItem.title isEqualToString:@"Basic Pie Chart"]) {
        [self basicPieChartDemo];
//        [self loadBasicPieChartUI];
    }
    if ([self.navigationItem.title isEqualToString:@"Animation Pie Chart"]) {
       [self animationPieChartDemo];
//        [self loadBasicPieChartUI];
    }
    
}

@end
