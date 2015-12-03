//
//  ViewController.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/1.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
