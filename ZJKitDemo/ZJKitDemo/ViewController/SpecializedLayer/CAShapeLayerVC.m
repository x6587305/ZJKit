//
//  CAShapeLayer.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/23.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//
/**
 *  CAShapeLayer 是基于向量的绘制图片。区别于位图（重写 draw: 方法）他的性能和速度好非常多。并且他是基于GPU的绘制 而不是 CPU的绘制
 1.速度快
 2.耗费内存小
 3.不受layer的bounds 限制 可以会知道外面去。
 4.不会变模糊（这个是向量图片的优点 区别于位图）
 */
#import "CAShapeLayerVC.h"
@interface CAShapeLayerVC()

@end
@implementation CAShapeLayerVC
-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self addAShapLayerView];
    
    [self addDrawView];

}

-(void) addDrawView{
    ZJDrawView *zjDrawView = [[ZJDrawView alloc] init];
    zjDrawView.backgroundColor = [UIColor whiteColor];
    zjDrawView.frame = CGRectMake(0, 150, 150, 300);
    [self.view addSubview:zjDrawView];
    
    ZJCAShapeLayerDrawView *zjCAShapeLayerDrawView = [[ZJCAShapeLayerDrawView alloc] init];
    zjCAShapeLayerDrawView.backgroundColor = [UIColor whiteColor];
    zjCAShapeLayerDrawView.frame = CGRectMake(155, 150, 150, 300);
    [self.view addSubview:zjCAShapeLayerDrawView];
    
}
-(void)addAShapLayerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 100, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addArcWithCenter:CGPointMake(-25, 0) radius:25
//                startAngle:0 endAngle:2*M_PI
//                 clockwise:YES];
//    [path moveToPoint:CGPointMake(-25, 25)];
//    [path addLineToPoint:CGPointMake(-25, 75)];
//    [path moveToPoint:CGPointMake(-25, 75)];//不加这一句 会填充错
//    [path addLineToPoint:CGPointMake(-50, 125)];//左脚
//    [path moveToPoint:CGPointMake(-25, 50)];
//    [path addLineToPoint:CGPointMake(0, 125)];//右脚
//    [path moveToPoint:CGPointMake(-75, 50)];
//    [path addLineToPoint:CGPointMake(50, 50)];
    
    
    //圆角
    CGRect rect = CGRectMake(-50, 0, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner corners = UIRectCornerTopRight |
    UIRectCornerBottomRight | UIRectCornerBottomLeft;
    //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    //create shape layer
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    //add it to our view
    [view.layer addSublayer:shapeLayer];
}


@end


/**
 *  制定一个uiview 对比使用 基于位图的 draw 实现 以及 基于向图的CAShapeLayer 的画图功能的性能
 */
#pragma mark ----第二种实现 通过 CAShapeLayer
@interface ZJCAShapeLayerDrawView()
@property(nonatomic,strong)UIBezierPath *path;
@end
@implementation ZJCAShapeLayerDrawView
/**
 *  而core animation 提供的 CAShapeLayer 是基于硬件加速的。速度要快非常多。并且也不会创建一个非常大的 backing image
 文字使用 CATextLayer  Gradients 使用 CAGradientLayer
 *
 *  @return <#return value description#>
 */
-(instancetype)init{
    self = [super init];
    if(self){
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        //configure the layer
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }
    return self;
}
//通过重写这个方法 改变 默认的view 的layer
+ (Class)layerClass {
    //this makes our view create a CAShapeLayer //instead of a CALayer for its backing layer
    return [CAShapeLayer class];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point]; }
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self]; //add a new line segment to our path
    [self.path addLineToPoint:point];
    //update the layer with a copy of the path
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}
@end


#pragma mark ----第一种实现 通过 drawRect 绘制
@interface ZJDrawView()
@property(nonatomic,strong)UIBezierPath *path;
@end


@implementation ZJDrawView
/**
 *  这么实现随着时间的推移 速度越来越慢 因为 path 越来越大并且每次移动手指的时候都会绘制路径。
 *
 *  @return <#return value description#>
 */
-(instancetype)init{
    self = [super init];
    if(self){
        self.path = [[UIBezierPath alloc] init];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point]; }
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self]; //add a new line segment to our path
    [self.path addLineToPoint:point];
    //redraw the view
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //draw path
    [[UIColor clearColor] setFill]; [[UIColor redColor] setStroke]; [self.path stroke];
}
@end
