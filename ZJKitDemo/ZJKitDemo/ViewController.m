//
//  ViewController.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/1.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()
@property (nonatomic, strong)  UIView *layerView;
@property (nonatomic, strong) CALayer *blueLayer;
@property (nonatomic, strong) CALayer *redLayer;
@end

@implementation ViewController
//愚蠢的不会哦了github 导致之前写的很多东西丢失了。先凭着记忆写点文字记录吧
//之前主要了解了一下锁。主要就是 自旋锁跟 互斥锁的不同。自旋一直忙等。耗费cpu但是效率高。 而互斥需要切换上下文。
//然后是 去了解 calayer
//contentsGravity
/*kCAGravityCenter
 kCAGravityTop kCAGravityBottom kCAGravityLeft kCAGravityRight kCAGravityTopLeft
 kCAGravityTopRight kCAGravityBottomLeft kCAGravityBottomRight kCAGravityResize kCAGravityResizeAspect kCAGravityResizeAspectFill
 
 
 contentsScale 是指 一个点耗费几个像素。
 contentsRect 参数 是Unit 的cgrect 是0到1之间的小数。主要用途 很多图片绘制在一张图片上。然后使用图片的时候根据这个参数来显示小图。好处 大幅度减小包的体积。以及加载速度。 加载一张大图性能要远远好于加载多个小图
 
 contentsCenter 像。9图那样中间拉伸边角不变
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self layerStudy];
    
}
-(void)layerStudy{
//    [self layerDraw];
//    [self layerLayout];
    [self layerTouch];
    
}

/*
 对于事件 layer 是没有响应的。layer 提供了两个方法帮助处理
 -containsPoint:
 -hitTest:
 参数都是layer的坐标系的坐标。前者是当前layer 是否包含这个坐标 后者包含子layer。
 这里有疑问了 偏到旁边的子坐标怎么算 试试吧
 */
-(void)layerTouch{
    self.layerView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 250, 250)];
    self.layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layerView];
    
    self.blueLayer = [CALayer layer];
    
    self.blueLayer.frame = CGRectMake(50, 50, 250, 250);
    
//    self.blueLayer.frame = CGRectMake(50, 50, 150, 150);
    self.blueLayer.backgroundColor = [UIColor redColor].CGColor;
    self.blueLayer.anchorPoint = CGPointMake(0, 0);
    [self.layerView.layer addSublayer:self.blueLayer];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //当blueLayer的视觉 超过了父 containsPoint并不会判定在范围以内   hitTest 会
    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
    //如果装换成子layer的坐标系里面就可以了
//    point = [self.blueLayer convertPoint:point fromLayer:self.view.layer];
    
    if([self.blueLayer containsPoint:point]){
        NSLog(@"in blueLayer");
    }
    if([self.blueLayer hitTest:point]){
        NSLog(@"in hit blueLayer");
    }
    //get layer using containsPoint:
    if ([self.layerView.layer containsPoint:point]) {
        //convert point to blueLayer’s coordinates
        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
        if ([self.blueLayer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer" message:nil
                                       delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
                                        message:nil delegate:nil
                              cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

/**
 *  对应view 的 frame bound 和center layer 也有对应的frame bound 和 position
 *  frame 是外坐标系。相对于父view bound 是内坐标系相对于自己。 
    而 center 和postion 相当于anchorPoint相对于父view的位置（实际上看不懂这个。因为改变anchorPoint 并没有改变 center 和position 啊。被改变的是frame）
 
    view的这些属性实际上就是对下面的layer的属性的访问。
    而frame是虚拟的属性。是通过bound center 以及transform 合成的。
 !! 当旋转之后 frame 会变化 而 bound 是不变
 */
-(void)layerLayout{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:view];
        view.backgroundColor = [UIColor redColor];
     NSLog(@"%@ -- %@  --- %@",NSStringFromCGRect(view.layer.frame),NSStringFromCGRect(view.layer.bounds),NSStringFromCGPoint(view.layer.position));
    //旋转了之后 frame 变化了 而 bound并没有
    view.transform = CGAffineTransformMakeRotation(1);
    NSLog(@"%@ -- %@  --- %@",NSStringFromCGRect(view.layer.frame),NSStringFromCGRect(view.layer.bounds),NSStringFromCGPoint(view.layer.position));
    
    //英文有限文档的anchorPoint解释看的并不是很明白。但是可以通过现象看得出来。是指layer上面的哪个点作为中心点。并且会改变frame以达到那个点 跟center 重合。
    //以后旋转也将围绕这个点来旋转 这个才是总
    view.layer.anchorPoint = CGPointMake(0, 0);
     NSLog(@"%@ -- %@  --- %@ -- %@",NSStringFromCGRect(view.layer.frame),NSStringFromCGRect(view.layer.bounds),NSStringFromCGPoint(view.layer.position),NSStringFromCGPoint(view.center));

    //layer 还有 z轴zPosition 和anchorPointZ
    //改变 zPosition 可以改变层级
    
   
}

-(void)layerDraw{
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f); blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //set controller as layer delegate
    blueLayer.delegate = self;
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [self.view.layer addSublayer:blueLayer];
    //force layer to redraw
    [blueLayer display];

}
//
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
