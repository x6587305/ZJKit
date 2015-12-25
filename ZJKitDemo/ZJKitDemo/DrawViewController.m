//
//  DrawViewController.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/18.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"
@interface DrawViewController ()
@property (nonatomic, strong) UIBezierPath *path;
@end
@implementation DrawViewController
-(void)viewDidLoad{
    DrawView *view  = [[DrawView alloc]init];
    view.frame = CGRectMake( 0, 0, 300, 500);
    [self.view addSubview:view];
}


@end
