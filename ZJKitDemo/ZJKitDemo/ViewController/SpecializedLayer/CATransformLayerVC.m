//
//  CATransformLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/24.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "CATransformLayerVC.h"
@interface CATransformLayerVC ()
@property(nonatomic,strong)UIView *containerView;
@end
@implementation CATransformLayerVC
/**
 *  实际上 CATransformLayer 本身并不显示任何东西。还是靠子layer 来显示。
 他负责的是统一了一个坐标系。或者说让坐标系 在父layer 上？？
 因为之前我们是知道的 父layer 3d旋转  a  子layer 反向旋转a 子layer 并不是没有旋转的样子。因为坐标系是不同的.
 */
-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.containerView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.containerView];
    
    //set up the perspective transform
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = pt;
    //set up the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.containerView.layer addSublayer:cube1];
    
    //set up the transform for cube 2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];

}



- (CALayer *)faceWithTransform:(CATransform3D)transform {
    //create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    //apply a random color
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue
                                           alpha:1.0].CGColor;
    //apply the transform and return
    face.transform = transform;
    return face;
}
- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    //create cube layer
    
    CATransformLayer *cube = [CATransformLayer layer];
    cube.transform = transform;
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0,containerSize.height / 2.0);
    
    //可以体会一下上下两个写法的区别
//    CALayer *cube = [CALayer layer];
//    cube.transform = transform;
//    cube.sublayerTransform = transform;
    
    //add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //center the cube layer within the container
       //apply the transform and return
    
    return cube;
}
@end
