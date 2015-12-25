//
//  DrawView.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/18.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "DrawView.h"
#define BRUSH_SIZE 32
@interface DrawView ()
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *strokes;
@end
@implementation DrawView
#pragma mark ---- 有图片需求的时候 没法使用CAShapeLayer
/**
 *  显示中很多需求 用基于向量的 layer 实现不了。比如需要绘制图片的逻辑。如下 画图路径是需要效果的（毛刷等）。用绘制图片
 这样可能只能用draw: 来实现。
 可以一样的问题。随着用的越来越多。每一次刷新都需要绘制所有的图片。到后面将没法实现。
 *
 *  @return <#return value description#>
 */
//-(instancetype)init{
//    self = [super init];
//    if(self){
//       self.strokes = [NSMutableArray array];
//    }
//    return self;
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get the starting point
//    CGPoint point = [[touches anyObject] locationInView:self];
//    //add brush stroke
//    [self addBrushStrokeAtPoint:point]; }
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get the touch point
//    CGPoint point = [[touches anyObject] locationInView:self];
//    //add brush stroke
//    [self addBrushStrokeAtPoint:point]; }
//- (void)addBrushStrokeAtPoint:(CGPoint)point {
//    //add brush stroke to array
//    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
//    //needs redraw
//    [self setNeedsDisplay]; }
//- (void)drawRect:(CGRect)rect {
//    //redraw strokes
//    for (NSValue *value in self.strokes) {
//        //get point
//        CGPoint point = [value CGPointValue];
//        //get brush rect
//        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2,
//                                      BRUSH_SIZE, BRUSH_SIZE);
//        [[UIImage imageNamed:@"3"] drawInRect:brushRect];
//    }
//}


/**
 *  可以通过刷新一块区域 来实现这个需求。这样就不需要修改该没有改变的区域了
 *
 *  @return <#return value description#>
 */
-(instancetype)init{
    self = [super init];
    if(self){
        self.strokes = [NSMutableArray array];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add brush stroke
    [self addBrushStrokeAtPoint:point]; }
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add brush stroke
    [self addBrushStrokeAtPoint:point]; }
- (void)addBrushStrokeAtPoint:(CGPoint)point {
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    //set dirty rect
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}
- (CGRect)brushRectForPoint:(CGPoint)point {
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2,
                      BRUSH_SIZE, BRUSH_SIZE);
}

- (void)drawRect:(CGRect)rect {
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        //get brush rect
        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2,
                                      BRUSH_SIZE, BRUSH_SIZE);
        //only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            //draw brush stroke
            [[UIImage imageNamed:@"3"] drawInRect:brushRect];
        }
    }
}

#pragma mark ----第二种实现 通过 CAShapeLayer
/**
 *  而core animation 提供的 CAShapeLayer 是基于硬件加速的。速度要快非常多。并且也不会创建一个非常大的 backing image
  文字使用 CATextLayer  Gradients 使用 CAGradientLayer
 *
 *  @return <#return value description#>
 */
//-(instancetype)init{
//    self = [super init];
//    if(self){
//        //create a mutable path
//        self.path = [[UIBezierPath alloc] init];
//        //configure the layer
//        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
//        shapeLayer.strokeColor = [UIColor redColor].CGColor;
//        shapeLayer.fillColor = [UIColor clearColor].CGColor;
//        shapeLayer.lineJoin = kCALineJoinRound;
//        shapeLayer.lineCap = kCALineCapRound;
//        shapeLayer.lineWidth = 5;
//    }
//    return self;
//}
//+ (Class)layerClass {
//    //this makes our view create a CAShapeLayer //instead of a CALayer for its backing layer
//    return [CAShapeLayer class];
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get the starting point
//    CGPoint point = [[touches anyObject] locationInView:self];
//    //move the path drawing cursor to the starting point
//    [self.path moveToPoint:point]; }
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get the current point
//    CGPoint point = [[touches anyObject] locationInView:self]; //add a new line segment to our path
//    [self.path addLineToPoint:point];
//    //update the layer with a copy of the path
//    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
//}



#pragma mark ----第一种实现 通过 drawRect 绘制
/**
 *  这么实现随着时间的推移 速度越来越慢 因为 path 越来越大并且每次移动手指的时候都会绘制路径。
 *
 *  @return <#return value description#>
 */
//-(instancetype)init{
//    self = [super init];
//    if(self){
//        self.path = [[UIBezierPath alloc] init];
//        self.path.lineJoinStyle = kCGLineJoinRound;
//        self.path.lineCapStyle = kCGLineCapRound;
//        self.path.lineWidth = 5;
//    }
//    return self;
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get the starting point
//    CGPoint point = [[touches anyObject] locationInView:self];
//    //move the path drawing cursor to the starting point
//    [self.path moveToPoint:point]; }
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get the current point
//    CGPoint point = [[touches anyObject] locationInView:self]; //add a new line segment to our path
//    [self.path addLineToPoint:point];
//    //redraw the view
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect {
//    //draw path
//    [[UIColor clearColor] setFill]; [[UIColor redColor] setStroke]; [self.path stroke];
//}
@end
