//
//  ViewController2.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/10.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UITextField *durationField;
@property (nonatomic, weak) IBOutlet UITextField *repeatField;
@property (weak, nonatomic) IBOutlet UITextField *reSpeed;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CALayer *shipLayer;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    
    
    [self cAMediaTimingStudy];
   
    
}

-(void) cAMediaTimingStudy{
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"3"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    
    
    
    
    //create a path
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(0, 150)];
    [self.bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer];
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 64, 64);
    self.shipLayer.position = CGPointMake(0, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"3"].CGImage;
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:ges];
    
    [self.containerView.layer addSublayer:self.shipLayer];
}
//可以通过偏移时间实现拖动的效果
- (void)pan:(UIPanGestureRecognizer *)pan{
    CGFloat x = [pan translationInView:self.view].x;
    x /= 320.0;
    
    CFTimeInterval timeOffset = self.shipLayer.timeOffset;
    timeOffset = timeOffset + 10* x;
    //MIN(9.999, MAX(10.0, timeOffset - x));
    
    self.shipLayer.timeOffset = timeOffset;
    [pan setTranslation:CGPointZero inView:self.view];
}
static bool ispause = NO;
/*
 1.time
 layer 本身的事件存在一个Hierarchical Time 的概念。
 calayer 的duration 和 repeatCount/repeatDuration属性并不会影响到子动画
 但是beginTime, timeOffset, 和 speed 却影响到子动画
 在 core animation中使用一个全局时间 mach time
 CFTimeInterval time = CACurrentMediaTime();
 这个值在不同的设备中是不同的。（重启设备之后会清零。因为他的表示的就是这个设备上次reboot到现在的时间）主要是处理相对时间的。
 当设备休眠之后 这个时间也会休眠。所以对于长时间任务使用这个事件很有问题。
 
 而每一个子layer 都有自己的时间的概念。而因为 beginTime, timeOffset和 speed的不同 导致跟全局时间不同。需要方法转换
 - (CFTimeInterval)convertTime:(CFTimeInterval)t fromLayer:(CALayer *)l;
 - (CFTimeInterval)convertTime:(CFTimeInterval)t toLayer:(CALayer *)l;
 当在多个layers 中拥有不同beginTime, timeOffset和 speed 并且你需要同步动画的时候。需要处理好这个转换
 2 pause
 动画一旦加入到layer上面去将没法改变。
 暂停动画 首先要明白 我们移除动画。然后设置model layer 为 presentationLayer 的情况也能实现动画暂停但是不利于 动画回复。
 可以设置speed 为0 这样就暂停了动画。再把model设置一下就ok了。一开始尝试的时候。我是直接设置speed为0.然后设置model layer的属性等于 presentationLayer 的属性。可是由于speed 属性的影响是异步的。导致不停的暂停 重新开始。会发现整个layer都发生不可知的变化。这样并不是我所希望的。
 然后使用了timeOffset 跟 beginTime 协同操作 这样效果好很多。
 
 当speed 小于1 的时候。都会显示model layer的情况。
 */
- (IBAction)pauseOrRestart:(id)sender {
    CALayer *presentationLayer =self.shipLayer.presentationLayer;//?:self.shipLayer;
  
    NSLog(@"%@-----%@",NSStringFromCGPoint(presentationLayer.position), NSStringFromCGRect(presentationLayer.frame));
    
//    if(ispause){
////        self.shipLayer.frame = CGRectMake(0, 0, 64, 64);
////        self.shipLayer.position = CGPointMake(0, 150);
//        self.shipLayer.speed = 1;
//    }else{
//        presentationLayer =self.shipLayer.presentationLayer;
//       
//        self.shipLayer.speed = 0;
//        self.shipLayer.position = presentationLayer.position;
//        self.shipLayer.affineTransform = presentationLayer.affineTransform;
//        
//    }
    
    
    if(ispause){

        CFTimeInterval pausedTime = [self.shipLayer timeOffset];
        self.shipLayer.speed = 1.0;
        self.shipLayer.timeOffset = 0.0;
        self.shipLayer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.shipLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.shipLayer.beginTime = timeSincePause;

    }else{
        CFTimeInterval pausedTime = [self.shipLayer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.shipLayer.speed = 0.0;
        self.shipLayer.timeOffset = pausedTime;

        
    }
   
    
//    self.shipLayer.presentationLayer
    
    ispause = !ispause;
}

- (IBAction)start:(id)sender {
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
    
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    //animate the ship rotation
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    //默认是z轴旋转 可以设置@"transform.rotation.x"
    /*
     rotation.x
     Set to an NSNumber object whose value is the rotation, in radians, in the x axis.
     rotation.y
     Set to an NSNumber object whose value is the rotation, in radians, in the y axis.
     rotation.z
     Set to an NSNumber object whose value is the rotation, in radians, in the z axis.
     rotation
     Set to an NSNumber object whose value is the rotation, in radians, in the z axis. This field is identical to setting the rotation.z field.
     scale.x
     Set to an NSNumber object whose value is the scale factor for the x axis.
     scale.y
     Set to an NSNumber object whose value is the scale factor for the y axis.
     scale.z
     Set to an NSNumber object whose value is the scale factor for the z axis.
     scale
     Set to an NSNumber object whose value is the average of all three scale factors.
     translation.x
     Set to an NSNumber object whose value is the translation factor along the x axis.
     translation.y
     Set to an NSNumber object whose value is the translation factor along the y axis.
     translation.z
     Set to an NSNumber object whose value is the translation factor along the z axis.
     translation
     Set to an NSValue object containing an NSSize or CGSize data type. That data type indicates the amount to translate in the x and y axis.

    */
//    animation.keyPath = @"transform.rotation";
//    animation.duration = 8;
//    animation.repeatCount = repeatCount;
//    //动画持续时间
////    animation.repeatDuration = 10;//INFINITY 特别大的一个值 表示无限循环
//     animation.autoreverses = YES;
//    animation.byValue = @(M_PI * 2);
//    animation.delegate = self;
//    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    
    
    //apply perspective transform
//    CATransform3D perspective = CATransform3DIdentity;
//    perspective.m34 = -1.0 / 500.0;
//    self.containerView.layer.sublayerTransform = perspective;
//    //apply swinging animation
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform.rotation.y";
//    animation.toValue = @(-M_PI_2);
//    animation.duration = 2.0;
//    animation.repeatDuration = 10;
//    animation.autoreverses = YES;
//    [self.shipLayer addAnimation:animation forKey:nil];
    
    

    //set initial values
    CFTimeInterval timeOffset = duration;
    float speed = repeatCount;
    
    
    /*
     timeOffset 开始的偏移时间。并不减少总执行时间 可以想象一下本来一个0 - 10s 的动画。如果timeOffset设置为2 就相当于先执行 2-10s 的动画然后在执行0-2s的动画
     speed 速度。正常情况是1. 如果10s动画就是10s执行完成。如果设置为5 那么这个动画变成2s执行完成.
     
     beginTime 是设置加入动画的延迟时间。需要注意的是 值是需要加上CACurrentMediaTime（） 的。
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.delegate = self;
    animation.keyPath = @"position";
    CFTimeInterval beginTime = CACurrentMediaTime() + timeOffset;
//    animation.beginTime = beginTime;
    animation.timeOffset = timeOffset;
    animation.speed = speed;
    animation.duration = 10;
    animation.path = self.bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.delegate = self;
//    animation.repeatCount = 3;
    animation.repeatDuration = 20;
    /*
     可以设置fillMode 决定动画结束完成之后的 layer的展示。如果设置成kCAFillModeForwards 最终的状态就会留在界面上。需要注意。要使用这种功能。需要将removedOnCompletion 设置为NO。 
     当然这样也有不好的地方 animation 会一直留在layer上面。浪费很大的性能。所以addAnimation 方法需要传入key 以便于不需要的时候移除这个 animation。
     */
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;//kCAFillModeRemoved;//kCAFillModeBoth;//kCAFillModeBackwards;//kCAFillModeForwards;
    
    [self.shipLayer addAnimation:animation forKey:@"slide"];
    
    
    
    
    
    //disable controls
    [self setControlsEnabled:NO];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //reenable controls
    [self setControlsEnabled:YES];
}

- (void)setControlsEnabled:(BOOL)enabled {
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton])
    {
        control.enabled = enabled; control.alpha = enabled? 1.0f: 0.25f;
    }
}
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
