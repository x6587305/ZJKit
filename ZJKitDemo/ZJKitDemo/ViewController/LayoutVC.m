//
//  LayoutVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/22.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "LayoutVC.h"

@interface LayoutVC ()
@property(nonatomic,strong)UIView *layerView;
@property(nonatomic,strong)CALayer *blueLayer;
@property(nonatomic,strong)CALayer *redLayer;
@end
@implementation LayoutVC
/**
 *  实际上 uiview 的frame bounds center 就是 对 layer 的 frame bounds postion 的封装而已
  frame 是相对于父坐标系的。而且他是计算出来的
  而frame是虚拟的属性。是通过bound center 以及transform 合成的。
  可以看出当uiview 旋转之后 frame 发生了变化
  bounds 是相对于自己的坐标系的。
  center postion是view/layer的中间。相当于anchorPoint相对于父view的位置。这句话比较拗口 。首先需要了解anchorPoint。在代码中会给出进一步的理解
 
anchorPoint 在正常情况下是等于center或者postion 的位置的。他的单位是unit 也就是是0到1之间小数。换句话说anchorPoint的值默认是（0.5，0.5）
 
 
当调用layer bounds changes or the -setNeedsLayout 会自动调用
 - (void)layoutSublayersOfLayer:(CALayer *)layer;
 在这里处理布局 但是 屏幕旋转什么并不调用。所以比不上自动布局

 */

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor grayColor];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 0, 300, 100)];
    [slider addTarget:self action:@selector(changeZ:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    
    self.layerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 300, 300)];
//    layerView.center = self.view.center;
    [self.layerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: self.layerView];
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(0, 0, 300, 300);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.blueLayer.zPosition = 0.5;
    [self.layerView.layer addSublayer:self.blueLayer];
    
    self.redLayer= [CALayer layer];
    self.redLayer.frame = CGRectMake(0, 0, 300, 300);
    self.redLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layerView.layer addSublayer:self.redLayer];

    
    
    [self logView:self.layerView];
    [self logLayer:self.blueLayer];
    
    /*
      这里需要注意 对于uiview 的 transform 在layer层的实现是 affineTransform。
      而 layer 层的transform 是 transform3D。
     */
    self.blueLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
    
    [self logLayer:self.blueLayer];
    
    /*
     设置了anchorPoint 为左上角的点 可以看到 旋转是以这个点为中心旋转的。可以看到frame的 x，y 值跟着改变 ，视图位置缺发生了变化。
     这里可以返回去理解  center postion是view/layer的中间。相当于anchorPoint相对于父view的位置。即使我们改变了 anchorPoint的值。但是打印出来的center并没有改变。而视图上看到的却是整个视图网右下角移动了。而那个 anchorPoint在父视图上的位置并没有改变。
     */
    self.blueLayer.anchorPoint = CGPointMake(0, 0);
    [self logLayer:self.blueLayer];
    
}
/**
 calayer 没有事件链 不能监听事件。但是提供了两个方法来判断某个点是否在这个区间内
 -containsPoint: 
 -hitTest:
 containsPoint 是在自己的坐标系里面。当点在自己的坐标系的frame之内(有形状剪切。。) 就返回yes
 
 
 通过以下的方法转换坐标系
 - (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer;
 - (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer;
 - (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;
 - (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;
 *
 
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //convert point to the white layer's coordinates
    point = [self.blueLayer convertPoint:point fromLayer:self.view.layer];
    if([self.blueLayer containsPoint:point]){
        NSLog(@"\ncontainsPoint  at  blueLayer");
    }
    //点的坐标系 已近变成了self。blueLayer 的了。
    point = [self.redLayer convertPoint:point fromLayer:self.blueLayer];
    if([self.blueLayer containsPoint:point]){
        NSLog(@"\ncontainsPoint  at  redLayer");
    }
    
    /*
     hittest 跟containsPoint 有很大的区别。他会自动转换所有的子layerView 的坐标系 并且做containsPoint 判断 直到找到一个 就返回这个对象。如果没找到返回nil.
     这里有个疑问 书上说 zPosition并不影响这个hittest 获取的顺序。hitTest 是根据 layer tree的结构来查找的。而zPosition只影响视觉。
     但是这个例子却表示了 zPosition 是影响的。
     */
#warning 这里有疑问有待确定
    point = [self.view.layer convertPoint:point fromLayer:self.redLayer];
    CALayer *layer = [self.layerView.layer hitTest:point];
    if(layer){
        NSLog(@"hit in %@",layer);
    }
}
/**
 *  改变zPosition 可以改变层级
 *
 *  @param slider <#slider description#>
 */
-(void)changeZ:(UISlider *)slider{
    float zPosition = slider.value;
    self.redLayer.zPosition = zPosition;
    NSLog(@"%f",zPosition);
}

-(void)logView:(UIView *)view{
    NSLog(@"\nview.frame:%@   \nview.bounds:%@   \nview.cente:%@",NSStringFromCGRect(view.frame) ,NSStringFromCGRect(view.bounds),NSStringFromCGPoint(view.center));
}
-(void)logLayer:(CALayer *)layer{
    NSLog(@"\nlayer.frame:%@   \nlayer.bounds:%@   \nlayer.cente:%@",NSStringFromCGRect(layer.frame) ,NSStringFromCGRect(layer.bounds),NSStringFromCGPoint(layer.position));
}



@end
