//
//  DrawLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/22.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "DrawLayerVC.h"
/**
 *
 */
@interface DrawLayerVC()

@end
@implementation DrawLayerVC
-(void)viewDidLoad{
      self.view.backgroundColor = [UIColor grayColor];
    
    UIView *layerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    layerView.center = self.view.center;
    [layerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: layerView];

    
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f); blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //set controller as layer delegate
    /**
     *  drawLayer 方法实际上是代理方法 而正常创建一个uiview 他的layer 的代理都是 uiview本身
     */
    blueLayer.delegate = self;
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [layerView.layer addSublayer:blueLayer];
    //force layer to redraw
    /**
     *  uiview 通过 setNeedsDisplay 方法
     而 calayer 通过 display 方法来表示需要重新调用 draw 方法
     */
    [blueLayer display];
}
/**
 *  CALayer 的 - (void)displayLayer:(CALayerCALayer *)layer; 方法实际上就是 uiview 的draw 方法的底层实现。uiview 的draw 只是它的包装。
 我们需要知道的是 一旦你实现这个方法 即使一行代码都没有。系统也会创建一个 view 大小* contentsScale 大小的图片。非常耗费性能跟内存
 *
 *  @param layer <#layer description#>
 *  @param ctx   <#ctx description#>
 */
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}
@end
