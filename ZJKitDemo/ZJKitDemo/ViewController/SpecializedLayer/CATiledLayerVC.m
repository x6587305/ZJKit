

//
//  CATiledLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/24.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//
/**
 *  当需要绘制一张非常大的图片的时候。使用 UIImage -imageNamed: 或者-imageWithContentsOfFile:方法是在主线程中的。会导致卡顿 甚至显示不全。 而且在iOS中 绘制图片也有个限制。所有显示在屏幕上面的图片最终都是转换成 OpenGL texture 而opengl 纹理有最大尺寸限制。之前也提到过 一般式 2048*2048 或者 4096 * 4096 取决于不同的设备。
 
    如果你显示一张尺寸超过限制的图片。即使这个图片已近读取到内存里面去了。仍然会需要很多性能极差的操作Core Animation  会参与进来处理图片。而不再是速度快很多的GPU绘制。
 CATiledLayer 是用来解决大图片显示问题的layer
 */
#import "CATiledLayerVC.h"

@interface CATiledLayerVC()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableDictionary *samllImage;
@property(nonatomic,strong)CATiledLayer *tileLayer;
@end
@implementation CATiledLayerVC
-(void)viewDidLoad{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.samllImage = [NSMutableDictionary dictionary];
    self.scrollView.contentSize =CGSizeMake(6000, 6000);
    /**
     *  这里 小图的逻辑应该是提前准备好的。显示的效果类似各种地图软件
     */
    [self showCATiledLayer];
    /**
     *  这里在iphone6 运行起来还是可以的 不过内存耗费掉143M.
     */
//    [self showImageView];

}

-(void)showImageView{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6000, 6000)];
     UIImage *image = [UIImage imageNamed:@"big"];
    imageview.image = image;
    [self.scrollView addSubview:imageview];
}

-(void)showCATiledLayer{
    //add the tiled layer
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6000, 6000)];
    self.tileLayer = [CATiledLayer layer];
    self.tileLayer.frame = CGRectMake(0, 0, 6000, 6000);
    
    self.tileLayer.delegate = self;
    
//    view.layer.delegate = nil; //我不知道为什么不把他设置为nil 返回 释放vc 的时候就会崩溃 或者在界面消失前 将 self.tileLayer.delegate = nil
    [view.layer addSublayer:self.tileLayer];

    [self.scrollView addSubview:view];
    
    //configure the scroll view
    
    
    [self cutSmallImage];
    //draw layer
    [self.tileLayer setNeedsDisplay];
}

-(void)dealloc{
     self.tileLayer.delegate = nil;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}

-(void)cutSmallImage{
    UIImage *image = [UIImage imageNamed:@"big"];
    CGImageRef imageRef = image.CGImage;
    CGSize size = image.size;
//    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
//    CGImageRef imageRef = [image CGImageForProposedRect:&rectcontext:NULL hints:nil];
    //calculate rows and columns
    CGFloat tileSize = 256;
    NSInteger rows = ceil(size.height / tileSize);
    NSInteger cols = ceil(size.width / tileSize);
    //generate tiles
    for (int y = 0; y < rows; ++y) {
        for (int x = 0; x < cols; ++x) {
            //extract tile image
            CGRect tileRect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
            CGImageRef tileImage = CGImageCreateWithImageInRect(imageRef, tileRect);
            //convert to jpeg data
            [self.samllImage setObject:[UIImage imageWithCGImage:tileImage] forKey:[NSString stringWithFormat:@"%d-%d",y,x]];
            
    
            CGImageRelease(imageRef);

    } }
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    //load tile image
    
    UIImage *tileImage =[self.samllImage objectForKey:[NSString stringWithFormat:@"%d-%d",y,x]];
                           //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}
@end
