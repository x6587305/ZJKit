//
//  EffectVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/22.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "EffectVC.h"
@interface EffectVC ()
@property(nonatomic,strong) UIView *layerView1;
@property(nonatomic,strong) UIView *layerView2;

@property(nonatomic,strong) UIView *shadowView1;
@property(nonatomic,strong) UIView *shadowView2;

@property(nonatomic,strong) UIView *layerView;
@property(nonatomic,strong) CALayer *blueLayer;
@end
@implementation EffectVC
-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.layerView1 = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    self.layerView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.layerView1];
    
    self.layerView2 = [[UIView alloc]initWithFrame:CGRectMake(-50, -50, 100, 100)];
    self.layerView2.backgroundColor = [UIColor blueColor];
    [self.layerView1 addSubview:self.layerView2];
    
    
    self.layerView2.layer.shadowOpacity = 0.5f;
    self.layerView2.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layerView2.layer.shadowRadius = 5.0f;
    
    

    
    
    //set the corner radius on our layers
    //设置圆角
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    //add a border to our layers
    //设置边框
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;
    //enable clipping on the second layer
    //设置 边框剪切
    self.layerView1.layer.masksToBounds = YES;
    
    
    
    
    self.layerView = [[UIView alloc]initWithFrame:CGRectMake(50, 200, 200, 200)];
    self.layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layerView];
    
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(-50, 0, 200, 200);
    [self.layerView.layer addSublayer:layer];
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"5"].CGImage);
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(50, 50,100, 100);;
    UIImage *maskImage = [UIImage imageNamed:@"7"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
//    [layer addSublayer:maskLayer];
    //所谓遮罩 就是 当遮罩的图片 有像素的时候 就显示原本的像素 否则就透明。
    layer.mask = maskLayer;
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(150, 0, 200, 200);
    [self.layerView.layer addSublayer:self.blueLayer];
    self.blueLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"5"].CGImage);
    
    
    //masksToBounds 属性会将阴影也切掉
    //    self.layerView.layer.cornerRadius =10;
    //    self.layerView.layer.masksToBounds = YES;
    //对于 图片的 阴影 会根据图片的轮廓。
    self.blueLayer.shadowOpacity = 1.0f;//有点浓度的概念
    self.blueLayer.shadowOffset = CGSizeMake(0.0f, 5.0f);//偏移量 就是阴影主要在那边
    self.blueLayer.shadowRadius = 5.0f;//数字越大越柔和
    //也可以设置阴影路径
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.blueLayer.bounds);
    self.blueLayer.shadowPath = circlePath;
    CGPathRelease(circlePath);

    
      //因为 masksToBounds 切阴影的缘故。所以我们要实现阴影 和切割都需要的情况 一般情况需要用两个view 来实现
    self.shadowView2 = [[UIView alloc]initWithFrame:CGRectMake(250, 50, 100, 100)];
    self.shadowView2.backgroundColor = [UIColor whiteColor];
    self.shadowView2.layer.shadowOpacity = 0.5f;
    self.shadowView2.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.shadowView2.layer.shadowRadius = 5.0f;
    [self.view addSubview:self.shadowView2];
    
    self.shadowView1 = [[UIView alloc]initWithFrame:CGRectMake(250, 50, 100, 100)];
    self.shadowView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shadowView1];
    
    
    

    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-50, -50, 100, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.shadowView1 addSubview:view];

    
    
    self.shadowView1.layer.cornerRadius = 20.0f;
    self.shadowView2.layer.cornerRadius = 20.0f;
    
    self.shadowView1.layer.masksToBounds = YES;
    
    
    
   
}

/*
 其他补充
 Scaling Filters
 //图片显示 最好像素跟需要显示出来的像素 一样大。这样既不会拉伸变形。也不需要gpu额外操作缩放。当然当尺寸不一样 layer 也需要缩放 通过Scaling Filters
 kCAFilterLinear
 kCAFilterNearest
 kCAFilterTrilinear
 他有上面三种类型
 默认是 kCAFilterLinear 这个模式
 这个过滤出来的图片是通过取几个点来生成一个像素。这样会很平滑。大部分会很不错。但是缩放的时候 有可能变得模糊
 kCAFilterTrilinear
 跟kCAFilterLinear 差别并不大。但是他在生成的时候合成三种尺寸。然后在通过这个 得出最后结果
 这两个类型在处理高质量的图片的时候效果很好
 kCAFilterNearest
 这种类型比较直接就是取旁边的一个像素的颜色。 速度快。不会模糊。但是会补均匀。视觉效果也会变形
 
 
 总的来说 当横平竖直。颜色简单的制作出来的图片 更适合kCAFilterNearest
 其他的图片比如照相机拍摄的照片默认的更加适合
 
 
 shouldRasterize //处理透明度的时候 子layer 怎样透明的属性
 */
@end
