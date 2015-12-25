//
//  CATextLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/23.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "CATextLayerVC.h"
@interface CATextLayerVC ()

@end
@implementation CATextLayerVC

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor lightGrayColor];
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 150, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    //create a text layer 用textLayer 绘制的字的间距貌似大点
    //这些差异是因为textLayer 是基于coretext 的绘制。而 uilabel 是基于webkit 的(书上说ios6 以及6以前是的 以后的没有提及)。这里存在细微的差别
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = view.bounds;
    [view.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    /*
      Truncation modes.
    
    CA_EXTERN NSString * const kCATruncationNone
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCATruncationStart
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCATruncationEnd
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCATruncationMiddle
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    
     Alignment modes.
    
    CA_EXTERN NSString * const kCAAlignmentNatural
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCAAlignmentLeft
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCAAlignmentRight
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCAAlignmentCenter
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
    CA_EXTERN NSString * const kCAAlignmentJustified
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_3_2);
     */
    textLayer.truncationMode = kCATruncationEnd;
    textLayer.alignmentMode = kCAAlignmentNatural;
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
    //这里的string 是id 类型。可以接收AttributedString
    textLayer.string = text;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(175, 0, 150, 200)];
    label.font =[UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    [label setText:text];
    
    
    CATextLayerLabel *label2 = [[CATextLayerLabel alloc]initWithFrame:CGRectMake(0, 250, 320, 200)];
    label2.font =[UIFont systemFontOfSize:15];
//    label2.backgroundColor = [UIColor whiteColor];//为什么加了这个就便黑色的了 而且再也改变不了颜色了 只能换了名字了先
    [label2 setBackgroundColor2:[UIColor whiteColor]];
    label2.layer.backgroundColor = [UIColor whiteColor].CGColor;
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
@end


@implementation CATextLayerLabel
+ (Class)layerClass {
    //this makes our label create a CATextLayer //instead of a regular CALayer for its backing layer
    //CATextLayer
    return [CATextLayer class];
}
-(void)setBackgroundColor2:(UIColor *)backgroundColor{
    self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
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

