//
//  KMMTabBarController.m
//  Maintenance
//
//  Created by kmcompany on 2017/8/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMTabBarController.h"

#import "KMMTabBar.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface KMMTabBarController()<UITabBarControllerDelegate,CAAnimationDelegate,KMMTabBarViewDelegate>

@property (nonatomic,strong) KMMTabBar *tabbar;

@end

@implementation KMMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeControllerPage) name:@"STARTUPLOAD" object:nil];
    
    self.delegate = self;
    /************************隐藏tabbar上的黑色线条***************************/
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-_白色透明背景渐变"]];
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"首页" image:[[UIImage imageNamed:@"icon-nor-kc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item1.selectedImage = [[UIImage imageNamed:@"icon-pre-kc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:BASE_COLOR forKey:NSForegroundColorAttributeName];
    [item1 setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"icon-nor-wd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item3.selectedImage = [[UIImage imageNamed:@"icon-pre-wd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dictHome3 = [NSDictionary dictionaryWithObject:BASE_COLOR forKey:NSForegroundColorAttributeName];
    [item3 setTitleTextAttributes:dictHome3 forState:UIControlStateSelected];
    
    NSArray *controllers = @[@"KMMHomeViewController",@"KMMTempController",@"KMMeViewController"];
    for (int i = 0; i < 3; i++) {
        Class cls = NSClassFromString([NSString stringWithFormat:@"%@",controllers[i]]);
        UIViewController *controller = (UIViewController *)[[cls alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
        nc.tabBarItem = @[item1,item2,item3][i];
        [self addChildViewController:nc];
    }
    
    KMMTabBar *tabBar = [[KMMTabBar alloc] init];
    tabBar.tabbarDelegate = self;
    tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-_白色透明背景渐变"]];
    [tabBar setItems: @[item1,item2,item3]];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

- (void)changeControllerPage {
    
    if (self.selectedIndex !=0) {
        self.selectedIndex = 0;
    }
}

#pragma mark - CYTabBarDelegate
- (void)tabbar:(KMMTabBar *)tabbar clickWithTag:(NSInteger)tag {
    
    switch (tag) {
        case 0: {
            NSLog(@"点击第1个、、、、、、");
            
            [self presentViewController:[FirstViewController new] animated:YES completion:nil];
        }
            break;
        case 1: {
             NSLog(@"点击第2个、、、、、、");
            
            [self presentViewController:[SecondViewController new] animated:YES completion:nil];
        }
            break;
        case 2: {
             NSLog(@"点击第3个、、、、、、");
            
            [self presentViewController:[ThirdViewController new] animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
}

@end
