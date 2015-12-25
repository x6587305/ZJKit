//
//  CADisplayLinkViewController.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/16.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "CADisplayLinkViewController.h"
/**
 *  之前的nstimer运行起来看上去很完美 实际上是有缺陷的。因为在iOS里面 每一个线程都会有个一个NSRunloop 不停的循环来做逻辑。而每一个loop都会按顺序做一些事情：
 1 执行用户事件
 2  发送 接受网络数据
 3  执行 gcd 代码块
 4  执行timer actions
 5 绘制屏幕
 即使你想timer每一秒执行60次 可是在执行timer actions 之前前面的代码话费的时间将会影响到你的逻辑
 
 那怎么解决这个问题呢。。
 1 我们可以使用 CADisplayLink 代替timer 这个是设计来刷新屏幕的
 2 我们使用实际的时间代替算出来的时间（就是每次执行都 是加上 1/60s 而是获取 时间来做逻辑）
 3 。设置 run loop mode
 
 *CADisplayLink 是不停的在执行。当执行代码基本不耗费时间的时候 一秒钟刷新60次。如果因为逻辑导致 延迟了。就会丢失一些frame。所以需要用实际的时间来处理逻辑。
 
 *  @param step <#step description#>
 */
@interface CADisplayLinkViewController ()
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *ballView;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval timeOffset;
@property (nonatomic, assign) CFTimeInterval lastStep;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@end

@implementation CADisplayLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300 , 300)];
    [self.view addSubview:self.containerView];
    
    UIImage *ballImage = [UIImage imageNamed:@"3"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.containerView addSubview:self.ballView];
    
    [self animate];
}

- (void)animate {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
//    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}
static double  last ;
static int i;
- (void)step:(CADisplayLink *)timer {
    
    
//     [NSThread sleepForTimeInterval:0.05];
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    i++;
    double new = CACurrentMediaTime();
    NSLog(@"%d : %f",i,new - last);
    last = new;
    NSLog(@"--------%f", self.timeOffset + stepDuration);
   
    //update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;//apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil; }
}


extern float bounceEaseOut(float);
extern float interpolate(float,float,float);

//float bounceEaseOut(float t) {
//    if (t < 4/11.0) {
//        return (121 * t * t)/16.0;
//    }
//    else if (t < 6/11.0) {
//        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
//    }
//    else if (t < 8/11.0) {
//        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
//    }
//    else if (t < 9/10.0) {
//        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
//    }
//    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
//}

//float interpolate(float from, float to, float time) {
//    return (to - from) * time + from;
//}
- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [(NSValue *)fromValue objCType]; if (strcmp(type, @encode(CGPoint)) == 0)
        {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time),
                                         interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
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
