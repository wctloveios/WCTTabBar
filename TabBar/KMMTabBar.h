//
//  KMMTabBar.h
//  Maintenance
//
//  Created by kmcompany on 2017/8/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMMTabBar;

//自定义按钮点击事件代理
@protocol KMMTabBarViewDelegate <NSObject>

- (void)tabbar:(KMMTabBar *)tabbar clickWithTag:(NSInteger)tag;


@end

@interface KMMTabBar : UITabBar

@property(nonatomic,weak) id<KMMTabBarViewDelegate> tabbarDelegate;

@end
