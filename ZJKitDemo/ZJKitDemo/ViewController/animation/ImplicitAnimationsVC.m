//
//  ImplicitAnimationsVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/24.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ImplicitAnimationsVC.h"
/**
 *  可以看到 自己添加的calayer 改变颜色的时候是有动画效果的。而uiview 本身layer 改变颜色缺没有。
 实际上每个calyer 本身就默认有动画效果叫做implicit animation 由 Core Animation 自动实现。
 当我们改变一个属性的时候。动画的时间 由当前动画事务（ current transaction）定义。而具体什么动画由layer actions控制。
 事务是核心动画用来封装一组特定的属性动画的机制。当属性改变时，并不立即开始动画。而是当事务提交的后立即开始动画。
 事务是被CATransaction 类管理。这个类并不可以 alloc 和 init。而是通过方法
 +begin +commit  来push 或者 pop 到栈上面去
 +setAnimationDuration: 设置动画时间 默认 0.25s
 //Core Animation  在每次runloop 的时候自动执行一个 动画事务（transaction）
 即使你不手动调用[CATransaction begin] 系统也会自动将一个 runloop 里面的所有属性改变合并成一个动画.
 然后执行一个0.25s的改变动画。这就是 implicit animation
 
 而为什么对uiview自己本身的layer改变属性并没有动画呢？
 当layer的属性改变的时候 这个动画的过程是这样的
 1 查看这个layer 是否有代理 。代理是否实现了-actionForLayer:forKey 方法.如果有 发送消息 返回值。
 2 如果没有代理或者代理没有实现-actionForLayer:forKey 那么检查 actions 字典。是否包含这个property name 的actions
 3 如果action dictionary 里面也没有 那么往下 在 style dictionary hierarchy 里面查找这个属性名称的acton
 4 最后如果在查找过程中的任何一步找到action就会返回 否则一直没找到 就会调用 -defaultActionForKey:
 
 --------------------------------------------------------------
 上面的查找 返回的对象或者是nil（那么就会立即改变没有动画）是需要遵守CAAction 协议的。而CALayer 就会产生 从旧值 到新值的改变动画
 而为什么uivew 的backing layer 没有默认动画。是因为uiview的backing layer 的代理就是uiview。而uiview 重写了-actionForLayer:forKey  返回nil
 可以看到下面的例子 当做 [UIView beginAnimations:nil context:nil];的时候 actionForLayer:forKey 返回的不再是nil 而是一个CABasicAnimation 对象
 */
@interface ImplicitAnimationsVC ()
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)CALayer *colorLayer;
@end
@implementation ImplicitAnimationsVC


-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor grayColor];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.view addSubview:self.leftView];
    
    self.rightView =[[UIView alloc]initWithFrame:CGRectMake(155, 0, 150, 150)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rightView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(155, 155, 150, 150)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"改变颜色" forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor blueColor]];
    self.button.frame = CGRectMake(0, 400, 150, 50);
    [self.button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"改变颜色然后旋转" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    button.frame = CGRectMake(155, 400, 150, 50);
    [button addTarget:self action:@selector(changeColor2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3  setTitle:@"自定义actions" forState:UIControlStateNormal];
    [button3  setBackgroundColor:[UIColor blueColor]];
    button3 .frame = CGRectMake(0, 455, 150, 50);
    [button3  addTarget:self action:@selector(changeColor3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3 ];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4  setTitle:@"理解presentaion versus model" forState:UIControlStateNormal];
    [button4  setBackgroundColor:[UIColor blueColor]];
    button4 .frame = CGRectMake(155, 455, 150, 50);
    [button4  addTarget:self action:@selector(changeColor4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4 ];
    
    
   
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.delegate = self;
    self.colorLayer.frame = self.leftView.bounds;
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    self.leftView.layer.delegate = nil;
    [self.leftView.layer addSublayer:self.colorLayer];
    
    
    
    //test layer action when outside of animation block
    NSLog(@"Outside: %@", [self.rightView actionForLayer:self.rightView.layer forKey:@"backgroundColor"]);
    //begin animation block
    [UIView beginAnimations:nil context:nil];
    //test layer action when inside of animation block
    NSLog(@"Inside: %@", [self.rightView actionForLayer:self.rightView.layer forKey:@"backgroundColor"]);
    //end animation block
    [UIView commitAnimations];
    
    
    
   

}

- (void)changeColor {
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    self.rightView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
}

- (void)changeColor2 {
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    //begin a new transaction
    [CATransaction begin];
    //set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    
    [CATransaction setCompletionBlock:^{
        //rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform; transform = CGAffineTransformRotate(transform, M_PI_2); self.colorLayer.affineTransform = transform;
    }];
    
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //commit the transaction
    [CATransaction commit];
    
}

/**
 *  我们除了可以通过设置代理方法actionForLayer:forKey 来实现 Implicit Animations以外 还可以直接设置actions 字典来实现
 */
- (void)changeColor3 {
   
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.rightView.layer.actions = @{@"backgroundColor": transition};
    //这里只是试验 正常情况不要轻易改变backing layer 的代理 因为只有没有实现代理 才去寻找action 字典
    self.rightView.layer.delegate = nil;
    
    self.rightView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue
                                                      alpha:1.0].CGColor;
}


/**
 *  Presentation Versus Model
 这里我们需要理解 layer 动画的实现。实际上 layer 分为两种 model layer  和 presentation layer
 我们正常操作的layer 就是model layer。也需有人会理解为 他是mvc 模式中的view 实际上他更应该是 m。是记录着这个视图将要展现成的样子。而真正在动画过程中的每一帧的样子。是由presentation layer来展示的。换句话说 当执行一个动画。会生成很多presentation layer。然后一帧一帧的显示出来（iOS 一秒钟刷新60次）
 
 后监听点击事件 然后判断 hittest
 这里需要注意的是 我是使用的 [UIView setAnimationDuration:10]; 来对 backing layer 做动画。这里系统是在一开始就讲model layer 改变了 。然后在做的动画。而很多时候 自己的动画 需要自己来实现什么时候真真的改变 model layer 的逻辑
 */
- (void)changeColor4 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:10];
    float x = (float)((int)(self.bottomView.frame.origin.x + 200) % 400);
    self.bottomView.layer.position = CGPointMake(x, self.bottomView.layer.position.y);
//    CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    [UIView commitAnimations];
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    [self.view convertPoint:point toView:self.bottomView];
    if([self.bottomView.layer.presentationLayer hitTest:point]){
//        CGFloat red = arc4random() / (CGFloat)INT_MAX;
//        CGFloat green = arc4random() / (CGFloat)INT_MAX;
//        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//        self.leftView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
          NSLog(@"点击了 presentation layer");
    }
    if([self.bottomView.layer hitTest:point]){
        NSLog(@"点击了 model layer");
    }
    
}

@end
