//
//  CYButton.m
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYButton.h"
#import "CYTabBarConfig.h"
@interface CYButton()

@end

@implementation CYButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[CYTabBarConfig shared].textColor forState:UIControlStateNormal];
        [self setTitleColor:[CYTabBarConfig shared].selectedTextColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.superview.frame.size.height;
    if (width!=0 && height!=0)
    {
        self.titleLabel.frame = CGRectMake(0, height-16, width, 16);
        self.imageView.frame = CGRectMake(0 , 0, width, 35);
    }
}






- (void)setHighlighted:(BOOL)highlighted{
}

@end
