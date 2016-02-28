//
//  ERExample.h
//  ERPieChartDemo
//
//  Created by 王耀杰 on 16/2/21.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ERExample : NSObject
/**
 *  每组的headerTitle
 */
@property (nonatomic, copy) NSString *headerTitle;
/**
 *  每行的title
 */
@property (nonatomic, strong) NSArray *titles;
@end
