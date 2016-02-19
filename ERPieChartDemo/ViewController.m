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


@property (nonatomic, weak) ERPieChart *pieChart;

@property (weak, nonatomic) IBOutlet UISlider *airRadiusSlider;

@end

@implementation ViewController
- (IBAction)AirRadiusSliderChanged:(UISlider *)sender {
    
    self.pieChart.airCircleRadius = sender.value * self.pieChart.radius;
    [self.pieChart setNeedsDisplay];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    // 创建一个基础的饼图
    ERPieChart *pieChart = [[ERPieChart alloc] initWithStyle:ERPieChartAnimation];
    pieChart.center = CGPointMake(SCREENWIDTH * 0.5, 180);
    pieChart.radius = 100;
    
    pieChart.backgroundColor = [UIColor blackColor];
    
//    pieChart.airCircleColor = [UIColor whiteColor];
//    pieChart.airCircleRadius = 20;
    
    pieChart.datas = @[@10,@20,@40,@60,@120];
    
    
    self.pieChart = pieChart;
    [self.view addSubview:pieChart];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
