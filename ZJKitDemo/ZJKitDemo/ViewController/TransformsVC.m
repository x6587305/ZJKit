//
//  TransformsVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/22.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "TransformsVC.h"
/*对于CGAffineTransform 学习绘图的时候已经有过一点了解。简单的说就是将一个点映射到另外一个点 是通过一个矩阵
 【x,y,1】* [a  b 0]   =  [x'  y'  1]
 c  d  0
 tx ty 1
 
 对于矩阵的结果
 x' = ax + cy + tx
 y' = bx + dy + ty
 所以绝大部分情况下 b 和 c 都是设置为0 这样 x 轴缩放就是 a。 y轴缩放就是d。x 轴偏移就是tx y轴偏移就是ty。
 当然如果要做一些奇怪的转换就需要用到 bc了。比如做变形  如下那种变形 就可以设置c 为 -1 d 为0 实现
 /******______**********_____**/
/*****|      |        /    /
 /*****|______|       /____/
 /******************/
/*
 uiview 的CGAffineTransform  实际上就是 calayer 的CGAffineTransform 的包装。开放的高级接口而已
 uiview 的transform属性 对应 calayer 的affineTransform 属性
 而aclayer 的transform属性 是 CATransform3D 对象
 
 因为矩阵相乘不满足 交换律 所以可以可以想象执行 transform 的顺序不同结果也不同.
 而旋转 和缩放 是对以后的操作都有影响的。当执行过缩放0.5之后。在偏移 200 实际上是偏移100.如果旋转之后在偏移。可以想象为x，y 轴也跟着旋转了。
 
 //
 */
@interface TransformsVC()
@end
@implementation TransformsVC

-(void)viewDidLoad{
     self.view.backgroundColor = [UIColor lightGrayColor];
    [self layerTransform];
    [self layerTransform3D];
}
-(void) layerTransform{
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view2];
    
    //create a new transform
    CGAffineTransform transform2 = CGAffineTransformIdentity;
    transform2 = CGAffineTransformTranslate(transform2, 200, 0);
    transform2 = CGAffineTransformScale(transform2, 0.5, 0.5);
    transform2 = CGAffineTransformRotate(transform2, M_PI / 180.0 * 30.0);
    //apply transform to layer
    view2.layer.affineTransform = transform2;
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    //处理的顺序不同  view 的最终状态也会不同
    CGAffineTransform transform = CGAffineTransformIdentity; //scale by 50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5); //rotate by 30 degrees
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0); //translate by 200 points
    transform = CGAffineTransformTranslate(transform, 200, 0);
    //apply transform to layer
    view.layer.affineTransform = transform;
    
}
/*
 3D Transform 其实跟 2D的并没有什么本质区别。只是多了个Z轴。当然 矩阵也就变成4*4 的矩阵。
 我们主要还是使用系统提供的方法连处理坐标转化
 CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
 CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
 CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
 */
-(void) layerTransform3D{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 256, 256)];
    view.backgroundColor = [UIColor whiteColor];
    //    UIImage *image = [UIImage imageNamed:@"3"];
    //    view.layer.contents = (__bridge id _Nullable)(image.CGImage);
    [self.view addSubview:view];
    
    CATransform3D transform = CATransform3DIdentity;
    // CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    //m34 表示的是在z 轴的偏移量。也可以理解为摄像机的位置。当不设置的时候是完全没有立体的感觉。就仿佛2维转化的缩放一样
    //m34设置为 -1.0 / d,  d即使摄像机(视觉)距离视图的距离
    transform.m34 = - 1.0 / 500.0;
    transform =CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    //CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    view.layer.transform = transform;
    
    /*
     sublayerTransform  设置在父layer 上面让所有的子layer 都在同一个 M34 是一个常用的用法
     doubleSided 当翻转180度后是否能够看到镜像图片
     */
    //父view旋转之后 子view 相反的旋转之后的情况可能和你想象的不同。要理解这个需要知道他们在不同的坐标系上面。
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(64, 64, 128, 128)];
    view2.backgroundColor = [UIColor blueColor];
    //     view2.layer.contents = (__bridge id _Nullable)(image.CGImage);
    [view addSubview:view2];
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = - 1.0 / 500.0;
    transform2 =CATransform3DRotate(transform2, -M_PI_4, 0, 1, 0);
    view2.layer.transform = transform2;
    
}
@end
