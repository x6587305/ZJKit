//
//  CAGradientLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/24.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "CAGradientLayerVC.h"
/**
 *  并不想深入了解一下 把例子放在这里吧
 */
@implementation CAGradientLayerVC

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self basicGradients];
    [self multipartGradients];
   
}

-(void)basicGradients{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 300)];
    [self.view addSubview:view];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}


-(void)multipartGradients{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(155, 0, 150, 300)];
     [self.view addSubview:view];
    
    //create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
   
    
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    //set locations
    gradientLayer.locations = @[@0.0, @0.25, @0.5];
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}
@end
