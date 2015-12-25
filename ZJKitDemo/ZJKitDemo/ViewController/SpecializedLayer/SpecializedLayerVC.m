//
//  SpecializedLayerVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/23.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "SpecializedLayerVC.h"
@interface SpecializedLayerVC ()
@property(nonatomic,strong)NSMutableArray *tableData;
@end
@implementation SpecializedLayerVC
-(void)viewDidLoad{
    self.tableData = [NSMutableArray array];

    [self addCell:@"CAShapeLayerVC" andClassName:@"CAShapeLayerVC"];
    [self addCell:@"CATextLayerVC" andClassName:@"CATextLayerVC"];
    [self addCell:@"CATransformLayerVC" andClassName:@"CATransformLayerVC"];
    [self addCell:@"CAGradientLayerVC" andClassName:@"CAGradientLayerVC"];
     [self addCell:@"CAReplicatorLayerVC" andClassName:@"CAReplicatorLayerVC"];
    [self addCell:@"CATiledLayerVC" andClassName:@"CATiledLayerVC"];
    
    
    //
    
    
    
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
