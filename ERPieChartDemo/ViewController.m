//
//  ViewController.m
//  ERPieChartDemo
//
//  Created by 王耀杰 on 16/2/19.
//  Copyright © 2016年 Erma. All rights reserved.
//

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "ERPieChart.h"



@interface ViewController ()
{
    double add;
}

//创建全局属性
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) ERPieChartStyle style;
@property (nonatomic, weak) ERPieChart *pieChart;

@property (weak, nonatomic) IBOutlet UISlider *airRadiusSlider;

@end

@implementation ViewController

float airRadius = 50;
- (IBAction)didChageStyle:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.style = ERPieChartBasic;
        [self refresh];
    }
    if (sender.selectedSegmentIndex == 1) {
        self.style = ERPieChartAnimation;
        [self refresh];
    }
}

- (IBAction)refresh:(UIButton *)sender {
    [self refresh];
}
- (IBAction)AirRadiusSliderChanged:(UISlider *)sender {
    
    airRadius = sender.value * self.pieChart.radius;
    
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pieChartBasicDemo];
}

- (void)animatePieChartDemo{
    // 创建一个基础的饼图
    ERPieChart *pieChart = [[ERPieChart alloc] initWithStyle:ERPieChartAnimation];
    self.style = ERPieChartAnimation;
    pieChart.center = CGPointMake(SCREENWIDTH * 0.5, 160);
    pieChart.radius = 120;
    
    pieChart.airCircleColor = [UIColor whiteColor];
    pieChart.airCircleRadius = airRadius;
    
    pieChart.datas = @[@10,@20,@40,@60,@120];
    
    
    self.pieChart = pieChart;
    [self.view addSubview:pieChart];
}

- (void)pieChartBasicDemo {
    // 创建一个基础的饼图
    ERPieChart *pieChart = [[ERPieChart alloc] initWithStyle:ERPieChartBasic];
    self.style = ERPieChartBasic;
    pieChart.center = CGPointMake(SCREENWIDTH * 0.5, 160);
    pieChart.radius = 120;
    
    pieChart.airCircleColor = [UIColor whiteColor];
    pieChart.airCircleRadius = airRadius;
    
    pieChart.datas = @[@10,@20,@40,@60,@120];
    
    
    self.pieChart = pieChart;
    [self.view addSubview:pieChart];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)refresh {
    [self.pieChart removeFromSuperview];
    if (self.style == ERPieChartAnimation) {
        [self animatePieChartDemo];
    }
    
    if (self.style == ERPieChartBasic) {
        [self pieChartBasicDemo];
    }
}

@end
