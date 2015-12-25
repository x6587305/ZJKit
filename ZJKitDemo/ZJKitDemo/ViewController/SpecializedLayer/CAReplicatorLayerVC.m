//
//  CAReplicatorLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/24.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "CAReplicatorLayerVC.h"
/**
 *  并不想深入了解一下 把例子放在这里吧
 */
@implementation CAReplicatorLayerVC

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self repeatView];
    [self reflectionsView];
}
-(void)reflectionsView{
    ReflectionView *view = [[ReflectionView alloc]initWithFrame:CGRectMake(155, 0, 150, 300)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:view.bounds];
    imageview.image =  [UIImage imageNamed:@"3"];
    [view addSubview:imageview];
    [self.view addSubview:view];
}



-(void)repeatView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 300)];
    [self.view addSubview:view];
    
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = view.bounds;
    [view.layer addSublayer:replicator];
    
    //configure the replicator
    replicator.instanceCount = 10;
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
}


@end



@implementation ReflectionView
+ (Class)layerClass {
    return [CAReplicatorLayer class];
}
- (void)setUp {
    //configure replicator
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    //move reflection instance below original and flip vertically
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0); layer.instanceTransform = transform;
    //reduce alpha of reflection layer
    layer.instanceAlphaOffset = -0.6;
}
- (id)initWithFrame:(CGRect)frame {
    //this is called when view is created in code
    if ((self = [super initWithFrame:frame])) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    //this is called when view is created from a nib
    [self setUp];
}
@end
