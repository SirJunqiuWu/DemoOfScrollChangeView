//
//  ScrollHeaderContentView.m
//  DomeOfScrollHeader
//
//  Created by 吴 吴 on 15/9/28.
//  Copyright © 2015年 吴 吴. All rights reserved.
//

#import "ScrollHeaderContentView.h"

@implementation ScrollHeaderContentView
@synthesize headerIcon,titleLbl;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    headerIcon.backgroundColor = [UIColor clearColor];
    headerIcon.backgroundColor = [UIColor yellowColor];
    [self addSubview:headerIcon];
    
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, headerIcon.frame.size.height-20, headerIcon.frame.size.width, 20)];
    titleLbl.textColor = [UIColor redColor];
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"吴俊秋";
    [self addSubview:titleLbl];

}
@end
