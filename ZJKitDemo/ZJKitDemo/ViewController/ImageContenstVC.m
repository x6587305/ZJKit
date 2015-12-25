//
//  ImageContenstVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/22.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ImageContenstVC.h"
/**
 *  跟uiview 有一个树形结构一样 layer 也有个树形结构。创建一个uiview 的时候会自动创建一个 layer 作为这个uiview 的主layer。你可以自己创建layer addsublayer 上去。
 
 */
@implementation ImageContenstVC
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    imageview.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:imageview];//用来对比效果的图片
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIView *layerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    layerView.center = self.view.center;
    [layerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: layerView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50, 50, 200, 200);
    /**
     *  layer 有个contents 对象 虽然是id 类型的但是在 iOS 里面 就是 CGImage 类型
     */
    UIImage *image = [UIImage imageNamed:@"1"];
    layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    
    
    /**
     *  跟 contentMode对应的 layer 也有自己的 contentsGravity
     
     kCAGravityCenter
     kCAGravityTop 
     kCAGravityBottom 
     kCAGravityLeft 
     kCAGravityRight 
     kCAGravityTopLeft
     kCAGravityTopRight 
     kCAGravityBottomLeft 
     kCAGravityBottomRight 
     kCAGravityResize 
     kCAGravityResizeAspect
     kCAGravityResizeAspectFill
     
     */
    layer.contentsGravity = kCAGravityResizeAspectFill;
    /**
     *  uiview 的 clipsToBounds 实际就是改变的 masksToBounds
     */
    layer.masksToBounds = YES;
    
    /**
     *  contentsScale 表示的是我们用几个像素来描述显示的一个点。在设置了contentsGravity 的情况下是没有任何作用的. 一般情况下 我们需要设置为需要的scale 如果是图片设置为  image.scale 如果是其他的 设置为 [UIScreen mainScreen].scale
     */
    layer.contentsScale = image.scale;
    
    /**
     *  contentsRect 的值的单位 是 Unit 是一个0到1 之间的小数 可以理解为百分比。
        而这个对象的最用 就是决定这个image 的那些部分是有效的。
         
        这是一个很总要很有用处的属性。我们在处理类似表情这样的需求的时候可能有很多小表情图片。可是加载一张大一点的图片 的性能与速度要远远好于加载很多张小图片。也可以减小包的体积.
     我们就可以将所有表情坐在一张图片上面。然后通过这个值来达到显示某一张小图的目的。

     */
    layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
    
    /**
     最后要了解的属性就是 contentsCenter 了。这个属性最简单的解释就是 9 path 图片。就是设值一个拉伸区域。然后是个角是完全不会变形的。
     当然需要注意的是单位仍然是 unit
     //不仅仅是影响我们的 contents 图片。即使是自己绘制的图形 也可以使用
     */
    layer.contentsCenter =CGRectMake(0.25, 0.25, 0.25, 0.25);
    
    [layerView.layer addSublayer:layer];
}

@end
