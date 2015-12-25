//
//  MainTableController.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/22.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//
/*
 在iOS 中。UIView 处理事件，支持基于core graphics的绘图，affine transforms（旋转 缩放）以及简单的动画比如
 滑动以及淡入淡出. 可是 实际上 绘制，布局以及动画是有一个 core animation 类叫做 CALayer 管理的。
 UIView 更总要的是处理用户交互
 而CALayer 则是处理各种视图以及效果。
 
 */
#import "MainTableController.h"
@interface MainTableController ()
@property(nonatomic,strong)NSMutableArray *tableData;
@end
@implementation MainTableController{
    
}
-(void)viewDidLoad{
    self.tableData = [NSMutableArray array];
    [self addCell:@"image contents" andClassName:@"ImageContenstVC"];
    [self addCell:@"draw layer" andClassName:@"DrawLayerVC"];
    [self addCell:@"layout" andClassName:@"LayoutVC"];
    [self addCell:@"Effect" andClassName:@"EffectVC"];
    [self addCell:@"Transforms" andClassName:@"TransformsVC"];
    [self addCell:@"SpecializedLayer" andClassName:@"SpecializedLayerVC"];
    [self addCell:@"Animation" andClassName:@"AnimationVC"];

    
    
    
}
-(void)addCell:(NSString *)title andClassName:(NSString *)className{
    NSDictionary *dic = @{@"title":title,@"className":className};
    [self.tableData addObject:dic];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aCell"];
    }
    NSDictionary *dic =  _tableData[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic =  _tableData[indexPath.row];
    NSString *className =  [dic objectForKey:@"className"];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
