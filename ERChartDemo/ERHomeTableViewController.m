//
//  ERHomeTableViewController.m
//  ERPieChartDemo
//
//  Created by 王耀杰 on 16/2/21.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import "ERHomeTableViewController.h"
#import "ERExample.h"
#import "ERExampleController.h"

@interface ERHomeTableViewController ()

@property (nonatomic, strong) NSArray *examples;

@end

@implementation ERHomeTableViewController
static NSString * const ID = @"cell";

- (NSArray *)examples {
    if (_examples == nil) {
        ERExample *exmp0 = [[ERExample alloc] init];
        exmp0.headerTitle = @"饼状图";
        exmp0.titles = EXMP0;
        
        ERExample *exmp1 = [[ERExample alloc] init];
        exmp1.headerTitle = @"柱状图";
        exmp1.titles = EXMP1;
        
        ERExample *exmp2 = [[ERExample alloc] init];
        exmp2.headerTitle = @"折线图";
        exmp2.titles = EXMP2;
        
        _examples = @[exmp0,exmp1,exmp2];
    }
    return _examples;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ERExample *exmp = self.examples[section];
    return exmp.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ERExample *exmp = self.examples[indexPath.section];
    cell.textLabel.text = exmp.titles[indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ERExample *exmp = self.examples[section];
    return exmp.headerTitle;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ERExampleController *exampleController = [[ERExampleController alloc] init];
    ERExample *exmp = self.examples[indexPath.section];
    exampleController.navigationItem.title = exmp.titles[indexPath.row];
    [self.navigationController pushViewController:exampleController animated:YES];
}

@end
