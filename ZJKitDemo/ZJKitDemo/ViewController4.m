//
//  ViewController4.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/15.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ViewController4.h"

@interface ViewController4 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
@end

@implementation ViewController4
/**
 *  iOS的屏幕是一秒钟刷新60次。实际上我们之前的动画 也是60个frame 队列然后轮流展示而已。
 所以实际上我们可以自己使用 nstime 每秒执行60次来实现动画
 http://www.robertpenner.com/easing 各种效果的c 函数
 float quadraticEaseInOut(float t) {
 return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
 }
这个函数就是描述 EaseInOut效果的函数。时间是 为1.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400 , 500)];
//    [self.view addSubview:self.containerView];
//    
//    UIImage *ballImage = [UIImage imageNamed:@"3"];
//    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
//    [self.containerView addSubview:self.ballView];
//    
//    [self animate];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //replay animation on tap
    [self animate];
}
/**
 *  这个函数是根据 上面提供的EaseInOut 函数转换的函数 那第一个if 举例 
 前4/11 的过程是下落过程。函数应该就是 上面 t‘<0.5 的函数  为  2*t’*t‘ 这里的t’ 是（0 - 0.5）之间的值 而 我们的t是 0 到 4/11的值
 所以将4/11 转化到 1/2上面去 就变成了 2*(11/8 *t)*(11/8 *t)
 而接下来的运算 都是转化到单位 1运算的。这里还是 0.5 所以 再乘以2 所以就是 (121 * t * t)/16.0
 
 第二段是是向上反弹的 并且落下去的 抛物线函数
 *
 *  @param t <#t description#>
 *
 *  @return <#return value description#>
 */
float bounceEaseOut(float t) {
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    }
    else if (t < 6/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    }
    else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    }
    else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

float interpolate(float from, float to, float time) {
    return (to - from) * time + from;
}
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self
                                                selector:@selector(step:) userInfo:nil
                                                 repeats:YES];
}

static double  last ;
- (void)step:(NSTimer *)step {
    double new = CACurrentMediaTime();
//    NSLog(@"%f",new - last);
    last = new;
    //update time offset
    self.timeOffset = MIN(self.timeOffset + 1/60.0, self.duration); //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration; //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    self.ballView.center = [position CGPointValue];
//    [NSThread sleepForTimeInterval:0.2];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        
        self.timer = nil;
    }
}




//float bounceEaseOut(float t) {
//    if (t < 4/11.0) {
//        return (121 * t * t)/16.0;
//    }
//    else if (t < 8/11.0) {
//        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
//    }
//    else if (t < 9/10.0) {
//        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
//    }
//    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
//}
//        
//float interpolate(float from, float to, float time) {
//    return (to - from) * time + from; }
//- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
//{
//    if ([fromValue isKindOfClass:[NSValue class]]) {
//        //get type
//        const char *type = [fromValue objCType]; if (strcmp(type, @encode(CGPoint)) == 0) {
//            CGPoint from = [fromValue CGPointValue];
//            CGPoint to = [toValue CGPointValue];
//            CGPoint result = CGPointMake(interpolate(from.x, to.x, time),
//                                         interpolate(from.y, to.y, time)); return [NSValue valueWithCGPoint:result];
//        } }
//    //provide safe default implementation
//    return (time < 0.5)? fromValue: toValue; }
//- (void)animate {
//    //reset ball to top of screen
//    self.ballView.center = CGPointMake(150, 32);
//    //set up animation parameters
//    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)]; NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)]; CFTimeInterval duration = 1.0;
//    //generate keyframes
//    NSInteger numFrames = duration * 60; NSMutableArray *frames = [NSMutableArray array]; for (int i = 0; i < numFrames; i++)
//    {
//        float time = 1/(float)numFrames * i;
//        time = bounceEaseOut(time);
//        [frames addObject:[self interpolateFromValue:fromValue
//                           toValue:toValue time:time]];
//    }
//    //create keyframe animation
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation]; animation.keyPath = @"position";
//    animation.duration = 1.0;
//    animation.delegate = self;
//    animation.values = frames;
//    //apply animation
//    [self.ballView.layer addAnimation:animation forKey:nil];
//}


//




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
