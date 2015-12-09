//
//  ViewController.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/1.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
@interface ViewController ()
@property (nonatomic, strong)  UIView *layerView;
@property (nonatomic, strong) CALayer *blueLayer;
@property (nonatomic, strong) CALayer *redLayer;
@property (nonatomic, strong) CALayer *colorLayer;
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
    
    self.layerView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 250, 250)];
    self.layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layerView];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 400, 100, 100);
    [button setTitle:@"change color" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(changeColor2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

//    [self layerStudy];
//    [self animationStudy];
     [self animationStudy2];
}

#pragma make --- animation学习
-(void)animationStudy2{//--------explicit animations
    
    
    //property animation --1.basic  2.keyframe
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f); self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
    
}
-(void)changeColor2:(id)btn{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    //可以添加这样添加动画
    /*
     CABasicAnimation 主要有这个三个值。看名字也能明白作用。需要注意的是  动画的类型是 通过keyPath 来设置的. 在某种程度上 跟 implicit animations. 里面默认的actions 字典有点像的
     id fromValue  开始的值
     id toValue   结束的值
     id byValue  变化的值
     这三个值并不需要都提供 甚至不应该都提供。因为会冲突。获取原则CABasicAnimation文档里面有描述
     需要注意的 是 这个animation并不改变 model 只改变 presentation 所以自行完成之后有回复到之前的样子了
     */
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
//    animation.toValue = (__bridge id)color.CGColor;
//    
////     animation.fromValue = (__bridge id)[UIColor blackColor].CGColor;
////     animation.byValue = (__bridge id)color.CGColor;
//    //apply animation to layer
//    [self.colorLayer addAnimation:animation forKey:nil];
   
    
//    //下面的方法可以正确的运行我们需要的效果
//    CABasicAnimation *animation = [CABasicAnimation animation]; animation.keyPath = @"backgroundColor";
//    animation.toValue = (__bridge id)color.CGColor;
//    //apply animation without snap-back
//    [self applyBasicAnimation:animation toLayer:self.colorLayer];
    
    /*
     CABasicAnimation 存在一个特殊的delegate CAAnimationDelegate 来处理动画完成后的回调
     
     --CAAnimationDelegate 并不真实的存在于某个头文件里面 在CAAnimation 里面可以看到他(一个nsobject 的分类)的方法

    - (void)animationDidStart:(CAAnimation *)anim;
    - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
     通过监听动作完成之后在修改该model layer的值。并且不加动画来实现同样的效果。
     貌似会闪一下。。我们的产品 肯定又要叫了 不让闪！！！！
     */
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.delegate = self;
    [self.colorLayer addAnimation:animation forKey:nil];
}
- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer{
    //set the from value (using presentation layer if available)
    animation.fromValue = [layer.presentationLayer ?: layer valueForKeyPath:animation.keyPath];
    //update the property in advance
    //note: this approach will only work if toValue != nil
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];
    //apply animation to layer
    [layer addAnimation:animation forKey:nil];
}
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    //set the backgroundColor property to match animation toValue
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
}

-(void)animationStudy{//--------implicit animations.
   
    
    
    
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    self.blueLayer.frame = CGRectMake(50, 50, 250, 250);
    [self.layerView.layer addSublayer:self.blueLayer];
    
    self.layerView.layer.backgroundColor = [UIColor blueColor].CGColor;
    
    //add a custom action
    self.redLayer = [CALayer layer];
    self.redLayer.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    //可以改变actions 来实现修改 动画
    self.redLayer.actions = @{@"backgroundColor": transition};
    [self.layerView.layer addSublayer:self.redLayer];
}

/*并没有加动画却可以看到 切换颜色的时候有明显的动画效果 - implicit animation
 这样的动画 被CATransaction 类管理。这个类并不可以 alloc 和 init。而是通过方法
 +begin +commit  来push 或者 pop 到栈上面去
 +setAnimationDuration: 设置动画时间 默认 0.25s
 //Core Animation  在每次runloop 的时候自动执行一个 动画操作（transaction）
 即使你不手动调用[CATransaction begin] 系统也会自动将一个 runloop 里面的改变并成一个动画.
 然后执行一个0.25s的改变动画
 */
-(void)changeColor:(UIButton *)obj{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.blueLayer.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
//    self.blueLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
//    //自己修改该动画时间 既然
//    //为了防止 设置影响到正在进行的其他动画（比如旋转动画）。最好自己push一个新的动作。
//    //实际上 如果不push新的。大部分情况下也能正常工作的
//    [CATransaction begin];
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.blueLayer.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
//    //这个时间只对 之后添加的动画有效果
//     [CATransaction setAnimationDuration:1.0];
//    
//    [CATransaction setCompletionBlock:^{
//        //这里边的动画 将恢复到0.25s 因为setAnimationDuration 只对当前的动画有效果。这里面的是下一个动画了
//        //rotate the layer 90 degrees
//        CGAffineTransform transform = self.blueLayer.affineTransform;
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        self.blueLayer.affineTransform = transform;
//    }];
//    self.blueLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//   
//    //view 并没有动画
//    self.layerView.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
//    //commit the transaction
//    [CATransaction commit];
//    
//    //uiview 需要用这两个方法
//    [UIView beginAnimations:nil context:nil];
//    self.layerView.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
//    [UIView commitAnimations];
    
  
//    //对于uiview 本身的 backing layer implicit animation 缺并没有效果
//    //begin a new transaction
//    [CATransaction begin];
//    //set the animation duration to 1 second
//    [CATransaction setAnimationDuration:1.0];
//    //randomize the layer background color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.layerView.layer.backgroundColor =[UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//                                                                                            //commit the transaction
//    [CATransaction commit];
    
    
    /*
     当layer的属性改变的时候 这个动画的过程是这样的
     1 查看这个layer 是否有代理 。代理是否实现了-actionForLayer:forKey 方法.如果有 发送消息 返回值。
     2 如果没有代理或者代理没有实现-actionForLayer:forKey 那么检查 actions 字典。是否包含这个property name 的actions
     3 如果action dictionary 里面也没有 那么往下 在 style dictionary hierarchy 里面查找这个属性名称的acton
     4 最后如果在查找过程中的任何一步找到action就会返回 否则一直没找到 就会调用 -defaultActionForKey:
     
     --------------------------------------------------------------
     上面的查找 返回的对象或者是nil（那么就会立即改变没有动画）是需要遵守CAAction 协议的。而CALayer 就会产生 从旧值 到新值的改变动画
     而为什么uivew 的backing layer 没有默认动画。是因为uiview的backing layer 的代理就是uiview。而uiview 重写了-actionForLayer:forKey  返回nil
     */
    
    //test layer action when outside of animation block
//    NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
//    //begin animation block
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    //test layer action when inside of animation block
//    NSLog(@"Inside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
//        CGFloat red = arc4random() / (CGFloat)INT_MAX;
//        CGFloat green = arc4random() / (CGFloat)INT_MAX;
//        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//     self.layerView.layer.backgroundColor =[UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    //end animation block
//    [UIView commitAnimations];
//    //上面的代码可以看到 当 调用[UIView beginAnimations:nil context:nil]; 之后-actionForLayer:forKey  返回了一个 CABasicAnimation 对象
    
    
    
    
//        [CATransaction begin];

//        self.blueLayer.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
//    
//    //还可以通过这个方法关闭之后的动画
//        [CATransaction setDisableActions:YES];
//        self.blueLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    
//        //view 并没有动画
//        self.layerView.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
//        //commit the transaction
//        [CATransaction commit];
    
    
    
//    self.redLayer.backgroundColor =[UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    
    
    
    
    
    
    
    //layer 很多人会理解为mvc上面的 view - v 实际上更应该还是 model。他记录的是界面要显示成的样子的数据。
    /*
     这里有presentation layer 的概念。这个是当前显示的layer。比如有动画的时候。动画执行过程中 显示的 是 presentation layer 可以通过 -presentationLayer 方法获取的到。
     presentation layer 实际上本质就是普通的layer类型。（ios 一秒刷新60次屏幕。难道意味着一个 layer的动画 设置时间一s 完成 就会产生60 个 presentation layer ？？？？？）
     
     一般情况下不需要访问  presentation layer 当然凡事必有例外：
     
     1.类似进度条这样的。有动画 还需要更新数字的。如果只是做的假的。或者会前进一大块。做了动画变得圆滑。但是并不希望数字只是动一下。这时候 就可以获取 presentation layer 来设置真真显示的百分比
     2.事件。如果使用-hitTest: 的对象在变化中。而hieTest 判断的却是 modelLayer 。显然是不合理的。
     
     */
    [CATransaction begin];
    [CATransaction setAnimationDuration:10.0];
    self.blueLayer.frame = CGRectMake(arc4random() %160, arc4random() %160, arc4random() %160, arc4random() %160);
    self.blueLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    [CATransaction commit];
}






#pragma make ---layer学习
/*
*/
-(void)layerStudy{
//    [self layerDraw];
//    [self layerLayout];
//    [self layerTouch];
//    [self layerScal];
//    [self layerTransform];
//    [self layerTransform3D];
//    [self layerShapeLayer];
//    [self layerTextLayer];
}

//CATransformLayer --3D transform 的layer -- 做色子应该要看他
//CAGradientLayer -- 渐变
//CAReplicatorLayer --复制  镜像等
//CAScrollLayer  --  Scroll
//CATiledLayer

-(void)layerTextLayer{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = view.bounds;
    [view.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    //set layer text
    textLayer.string = text;
    
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
        label.font =[UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        label.numberOfLines = 0;
        [label setText:text];
    
    
    LayerLabel *label2 = [[LayerLabel alloc]initWithFrame:CGRectMake(0, 400, 320, 200)];
    label2.font =[UIFont systemFontOfSize:15];
    label2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label2];
    label2.numberOfLines = 0;
    [label2 setText:text];
    
    
    
    
    
//    //set text attributes
//    textLayer.alignmentMode = kCAAlignmentJustified; textLayer.wrapped = YES;
//    //choose a font
//    UIFont *font = [UIFont systemFontOfSize:15];
//    //choose some text
//    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \ elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
//    //create attributed string
//    NSMutableAttributedString *string = nil;
//    string = [[NSMutableAttributedString alloc] initWithString:text];
//    //convert UIFont to a CTFont
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName; CGFloat fontSize = font.pointSize;
//    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
//    //set text attributes
//    NSDictionary *attribs = @{
//                              (__bridge id)kCTForegroundColorAttributeName:
//                                  (__bridge id)[UIColor blackColor].CGColor, (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
//                              };
//    [string setAttributes:attribs range:NSMakeRange(0, [text length])]; attribs = @{
//                                                                                    (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor, (__bridge id)kCTUnderlineStyleAttributeName:
//                                                                                        @(kCTUnderlineStyleSingle),
//                                                                                    (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
//                                                                                    };
//    [string setAttributes:attribs range:NSMakeRange(6, 5)];
//    //release the CTFont we created earlier
//    CFRelease(fontRef);
//    //set layer text
//    textLayer.string = string;
    
//    //可以看出 使用textLayer 跟 uilabel 绘制的文字差别很大。他们使用不同的实现方式
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
//    label.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:label];
//    label.numberOfLines = 0;
//    [label setAttributedText:string];
}
/*
 CAShapeLayer 是一个可以画各种图形的cayer 相比纯粹的画图。 使用向量图 代替 位图 有很多优势。
 1 比绘图性能好非常多
 2 因为不用位图。也不需要一个大画布（我是这么理解的。实际上就是当你重写draw方法的时候。会准备一个 backing image 大小等于这个view的 大小* Scale）
 3. 他不受view 的bounds 的大小限制 可以画到外面去
 4.同样 因为使用向量图 所以 放大缩小旋转等 不会模糊
 */
-(void)layerShapeLayer{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25
                startAngle:0 endAngle:2*M_PI
                 clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)]; [path addLineToPoint:CGPointMake(125, 225)]; [path moveToPoint:CGPointMake(150, 175)]; [path addLineToPoint:CGPointMake(175, 225)]; [path moveToPoint:CGPointMake(100, 150)]; [path addLineToPoint:CGPointMake(200, 150)];
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer]; shapeLayer.strokeColor = [UIColor redColor].CGColor; shapeLayer.fillColor = [UIColor clearColor].CGColor; shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound; shapeLayer.lineCap = kCALineCapRound; shapeLayer.path = path.CGPath;
    //add it to our view
    [view.layer addSublayer:shapeLayer];
}

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
    
    //create a new transform
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
//    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
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

/*Scaling Filters
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
-(void)layerScal{
    
}

/*
 对于事件 layer 是没有响应的。layer 提供了两个方法帮助处理
 -containsPoint:
 -hitTest:
 参数都是layer的坐标系的坐标。前者是当前layer 是否包含这个坐标 后者包含子layer。
 这里有疑问了 偏到旁边的子坐标怎么算 试试吧
 
 关于自动布局等情况下 layer需要手动处理逻辑
 - (void)layoutSublayersOfLayer:(CALayer *)layer;
 通过上面方法来处理
 当 layer bound改变或者调用过 -setNeedsLayout方法之后上面方法会被自动调用
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
    
    
    self.layerView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"4"].CGImage);
    
    //masksToBounds 属性会将阴影也切掉
//    self.layerView.layer.cornerRadius =10;
//    self.layerView.layer.masksToBounds = YES;
    self.layerView.layer.shadowOpacity = 0.5f;//有点浓度的概念
    self.layerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);//偏移量 就是阴影主要在那边
    self.layerView.layer.shadowRadius = 5.0f;//数字越大越柔和
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //当blueLayer的视觉 超过了父 containsPoint并不会判定在范围以内   hitTest 会
    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
    //如果装换成子layer的坐标系里面就可以了
    //    point = [self.blueLayer convertPoint:point fromLayer:self.view.layer];
    //    NSLog(@"%@",NSStringFromCGPoint(point));
    //上面理解错了 containsPoint 应该是自己的坐标系中  而 hitTest 是父坐标系
    //    if([self.blueLayer containsPoint:point]){
    //        NSLog(@"in containsPoint blueLayer");
    //    }
    if([self.blueLayer hitTest:point]){
        NSLog(@"-------------in hitTest blueLayer");
    }
    if([self.blueLayer.presentationLayer hitTest:point]){
        NSLog(@"++++++++++++presentationLayer hitTest blueLayer");
    }
//    //get layer using containsPoint:
//    if ([self.layerView.layer containsPoint:point]) {
//        //convert point to blueLayer’s coordinates
//        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
//        if ([self.blueLayer containsPoint:point]) {
//            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer" message:nil
//                                       delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] show];
//        }
//        else
//        {
//            [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
//                                        message:nil delegate:nil
//                              cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        }
//    }
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

#warning 并没有弄明白 一直大黑屏 先过 之后来看
@implementation LayerLabel
+ (Class)layerClass {
    //this makes our label create a CATextLayer //instead of a regular CALayer for its backing layer
    return [CATextLayer class];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.textLayer.backgroundColor = [backgroundColor CGColor];
}
- (CATextLayer *)textLayer {
    CATextLayer *layer = (CATextLayer *)self.layer;
    return layer;
}
- (void)setUp {
    //set defaults from UILabel settings
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    //we should really derive these from the UILabel settings too //but that's complicated, so for now we'll just hard-code them
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    [self textLayer].wrapped = YES;
    [self.layer display];
}
- (id)initWithFrame:(CGRect)frame {
    //called when creating label programmatically
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    //called when creating label using Interface Builder
    [self setUp];
}
- (void)setText:(NSString *)text {
    super.text = text;
    //set layer text
    [self textLayer].string = text;
}
- (void)setTextColor:(UIColor *)textColor {
    super.textColor = textColor;
    //set layer text color
    [self textLayer].foregroundColor = textColor.CGColor;
}
- (void)setFont:(UIFont *)font {
    super.font = font;
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName; CGFontRef fontRef = CGFontCreateWithFontName(fontName); [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    CGFontRelease(fontRef);
}
@end
