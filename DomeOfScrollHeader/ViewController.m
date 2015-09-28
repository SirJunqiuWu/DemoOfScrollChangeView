//
//  ViewController.m
//  DomeOfScrollHeader
//
//  Created by 吴 吴 on 15/9/28.
//  Copyright © 2015年 吴 吴. All rights reserved.
//

#import "ViewController.h"
#import "ScrollheaderView.h"

#define scrollChangeHeight         200.0

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    /**
     *  可滑动变化视图
     */
    ScrollheaderView *scrollheaderView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"滑动列表头部放大";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    /**
     *  列表
     */
    [self setupUI];
    
    /**
     *  ScrollView
     */
//    [self setupScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    scrollheaderView = [[ScrollheaderView alloc]initTableWithFrame:CGRectMake(0,64, bounds.size.width, bounds.size.height-64) CoverHeight:scrollChangeHeight];
    [scrollheaderView initViewWithDic:nil];
    scrollheaderView.infoTable.delegate = self;
    scrollheaderView.infoTable.dataSource = self;
    [self.view addSubview:scrollheaderView];
}

- (void)setupScrollView {
    CGRect bounds = [[UIScreen mainScreen]bounds];
    scrollheaderView = [[ScrollheaderView alloc]initScrollViewWithFrame:CGRectMake(0,64, bounds.size.width, bounds.size.height-64) CoverHeight:scrollChangeHeight];
    [scrollheaderView initViewWithDic:nil];
    scrollheaderView.infoTable.delegate = self;
    scrollheaderView.infoTable.dataSource = self;
    [self.view addSubview:scrollheaderView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld",indexPath.row + 1];
    return cell;
}

@end
