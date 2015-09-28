//
//  ScrollheaderView.h
//  DomeOfScrollHeader
//
//  Created by 吴 吴 on 15/9/28.
//  Copyright © 2015年 吴 吴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollHeaderContentView.h"

@interface ScrollheaderView : UIView

/**
 *  滑动列表
 */
@property (nonatomic, strong) UITableView* infoTable;

/**
 *  顶部拉动变化视图
 */
@property (nonatomic, strong) ScrollHeaderContentView *headerImageView;

/**
 *  scrollView
 */
@property (nonatomic, strong) UIScrollView * baseSV;
@property (nonatomic, strong) UIView* scrollContentView;
@property (nonatomic, assign) CGFloat scrollContentHeight;


/**
 *  重写初始化方法 - 列表滑动顶部视图变化
 *
 *  @param frame  自身视图大小
 *  @param height 顶部视图滑动范围
 *
 *  @return 返回自身视图
 */
- (id)initTableWithFrame:(CGRect)frame CoverHeight:(CGFloat)height;

/**
 *  重写初始化方法 - scrollView滑动顶部视图变化
 *
 *  @param frame  自身视图大小
 *  @param height 顶部视图滑动范围
 *
 *  @return 返回自身视图
 */
- (id)initScrollViewWithFrame:(CGRect)frame CoverHeight:(CGFloat)height;

/**
 *  数据源方法
 *
 *  @param dic 数据源字典
 */
- (void)initViewWithDic:(NSDictionary  *)dic;

@end


@interface UIImage (Blur)

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end
