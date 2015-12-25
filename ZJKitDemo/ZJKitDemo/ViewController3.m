//
//  ViewController3.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/14.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ViewController3.h"

@interface ViewController3 ()
@property(nonatomic,strong) CALayer *colorLayer ;
@property(nonatomic,strong) CALayer *colorLayer2 ;
@property(nonatomic,strong) UIView *colorView;


@property(nonatomic,strong) UIView *layerView;

@property(nonatomic,strong)UIImageView *ballView;
//self.layerView.layer
@end
/**
   我们之前设置的动画 默认都是linear pacing 这是线性匀速的变化。很多场合并不适合。或者说并不自然。我们需要更自然的动画。需要有加速度的概念。这时候就需要CAMediaTimingFunction 类的帮助了。
 kCAMediaTimingFunctionLinear //默认的匀速
 kCAMediaTimingFunctionEaseIn  //加速到最大速度 最后不减速
 kCAMediaTimingFunctionEaseOut  //直接开始最大速度。 最后减速 //当你使用uiview的动画的时候这个是默认的
 kCAMediaTimingFunctionEaseInEaseOut 开始也加速 最后也减速
 kCAMediaTimingFunctionDefault 跟kCAMediaTimingFunctionEaseOut 基本一样, 但是迅速加速到很快 然后又急剧减速。不要被default 说迷惑。这个只是implicit animations 动画的默认值。
 */
@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self timeingFuncionStudy];
//    [self timeingFuncionStudy2];
    [self timeingFuncionStudy3];
//    [self timeBaseAnimation];
}


-(void)timeBaseAnimation{
    
}

-(void) timeingFuncionStudy3{
    UIImage *ballImage = [UIImage imageNamed:@"3"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.view addSubview:self.ballView];
    //animate
    [self animate];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //replay animation on tap
    [self animate];
}
- (void)animate {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation]; animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 32)], [NSValue valueWithCGPoint:CGPointMake(150, 268)], [NSValue valueWithCGPoint:CGPointMake(150, 140)], [NSValue valueWithCGPoint:CGPointMake(150, 268)], [NSValue valueWithCGPoint:CGPointMake(150, 220)], [NSValue valueWithCGPoint:CGPointMake(150, 268)], [NSValue valueWithCGPoint:CGPointMake(150, 250)], [NSValue valueWithCGPoint:CGPointMake(150, 268)]
                         ];
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    //apply animation
    self.ballView.layer.position = CGPointMake(150, 268); [self.ballView.layer addAnimation:animation forKey:nil];
}
/**
 *  CAMediaTimingFunction 实际上 是一个从（0，0） 到 （1，1）的贝塞尔曲线来处理速度的。
 下面是各种类型的两个控制点
 kCAMediaTimingFunctionLinear  (0.0,0.0)  (1.0,1.0)
 kCAMediaTimingFunctionEaseIn  (0.42,0.0) (1.0,1.0)
 kCAMediaTimingFunctionEaseOut  (0.0,0.0)  (0.58,1.0)
 kCAMediaTimingFunctionEaseInEaseOut  (0.42,0.0)  (0.58,1.0)
 kCAMediaTimingFunctionDefault (0.25,0.1)  (0.25,1.0).

 所以实际上我们可以创建自己的 贝塞尔曲线来控制速度
 CAMediaTimingFunction functionWithControlPoints:<#(float)#> :<#(float)#> :<#(float)#> :<#(float)#>
 4个匿名参数 是 x1 y1 x2 y2 是两个控制点的坐标
 */
-(void) timeingFuncionStudy2{
    self.layerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:self.layerView];
    
    
    //create timing function
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:
                                       kCAMediaTimingFunctionDefault];
    
    
    //get control points
    float controlPoint0[2], controlPoint1[2], controlPoint2[2],controlPoint3[2];
    [function getControlPointAtIndex:0 values:controlPoint0];
    [function getControlPointAtIndex:1 values:controlPoint1];
    [function getControlPointAtIndex:2 values:controlPoint2];
    [function getControlPointAtIndex:3 values:controlPoint3];
    //create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1)
            controlPoint1:CGPointMake(controlPoint1[0], controlPoint1[1]) controlPoint2:CGPointMake(controlPoint2[0], controlPoint2[1])];
    //scale the path up to a reasonable size for display
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor grayColor].CGColor;
    shapeLayer.frame = CGRectMake(100, 100, 200, 200);
    shapeLayer.position = CGPointMake(100, 100);
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = path.CGPath;
    [self.layerView.layer addSublayer:shapeLayer];
    //flip geometry so that 0,0 is in the bottom-left
    self.layerView.layer.geometryFlipped = YES;
    
   
}

// CAMediaTimingFunction *xx =  [CAMediaTimingFunction functionWithControlPoints:1.0 :1.0 :1.0 :1.0];

-(void) timeingFuncionStudy{
     UIButton *changeColorButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    changeColorButton.frame = CGRectMake(0, 300, 100, 30);
    changeColorButton.backgroundColor = [UIColor redColor];
    [changeColorButton setTitle:@"改变颜色" forState:UIControlStateNormal];
    [changeColorButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeColorButton];
    
    self.colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.colorView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.colorView];
    self.colorView.center = CGPointMake(self.view.bounds.size.width/2.0 -100,self.view.bounds.size.height/2.0);
    self.colorLayer2 = [CALayer layer];
    self.colorLayer2.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer2.position = CGPointMake(self.view.bounds.size.width/2.0+100,self.view.bounds.size.height/2.0);
    self.colorLayer2.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer2];

    
    //create a red layer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width/2.0,self.view.bounds.size.height/2.0);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}
/**
 *  keyframe animation 也可以设置 CAMediaTimingFunction 这是一个数组。可以设置每一个变化的的变化规则
 *
 *  @param btn <#btn description#>
 */
- (void)changeColor:(UIButton *)btn{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor blueColor].CGColor ];
    //add timing function
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[fn, fn, fn];
    [self.colorLayer addAnimation:animation forKey:nil];
}
/**
 对于 uiview的动画 使用的是如下的参数
 UIViewAnimationOptionCurveEaseInOut
 UIViewAnimationOptionCurveEaseIn
 UIViewAnimationOptionCurveEaseOut 
 UIViewAnimationOptionCurveLinear
 */
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
////     CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation keyAnimation];
//    CGPoint point =  [[touches anyObject] locationInView:self.view];
//    
//    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        self.colorView.center =
//                            CGPointMake(point.x - 100, point.y);;
//                        } completion:NULL];
//    
//    
////    [CATransaction begin];
////    [CATransaction setAnimationDuration:1.0];
////    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
////    //set the position
////    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
////    [CATransaction commit];
//    
//     CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
//    keyAnimation.duration = 5;
//    keyAnimation.keyPath = @"position";
//   
//    keyAnimation.values = @[[NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:CGPointMake(0, 0)], [NSValue valueWithCGPoint:CGPointMake(320, 0)], [NSValue valueWithCGPoint:CGPointMake(320,  500)], [NSValue valueWithCGPoint:CGPointMake(0, 500)],[NSValue valueWithCGPoint:point],];
//    
//    CAMediaTimingFunction *in = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
//    CAMediaTimingFunction *out = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
//    CAMediaTimingFunction *inout = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//    //这个4个匿名参数的方法 可以构建自己想要的动画加速效果
//   
////    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunction];
//    keyAnimation.timingFunctions = @[out,in,  inout];
//    [self.colorLayer addAnimation:keyAnimation forKey:nil];
//    
//    
//    
//    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:1.0];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]]; //set the position
////    CGPoint point =  [[touches anyObject] locationInView:self.view];
//    self.colorLayer2.position = CGPointMake(point.x + 100, point.y);
//    
//    //kCAMediaTimingFunctionDefault
//    //commit transaction
//    [CATransaction commit];
//    
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
