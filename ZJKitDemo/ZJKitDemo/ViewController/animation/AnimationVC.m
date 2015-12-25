//
//  AnimationVC.m
//  ZJKitDemo
//
//  Created by xiezhaojun on 15/12/24.
//  Copyright © 2015年 xiezhaojun. All rights reserved.
//

#import "AnimationVC.h"
@interface AnimationVC ()
@property(nonatomic,strong)NSMutableArray *tableData;
@end
@implementation AnimationVC
-(void)viewDidLoad{
    self.tableData = [NSMutableArray array];
    [self addCell:@"ImplicitAnimationsVC" andClassName:@"ImplicitAnimationsVC"];
    [self addCell:@"ExplicitAnimationVC" andClassName:@"ExplicitAnimationVC"];
    
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
