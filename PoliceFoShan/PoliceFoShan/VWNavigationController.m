//
//  VWNavigationController.m
//  vWallet
//
//  Created by 汤书亚 on 2016/10/13.
//  Copyright © 2016年 vWalletChain. All rights reserved.
//

#import "VWNavigationController.h"


/** 按钮背景色*/
#define settingBtnBackcolor [UIColor colorWithRed:23.0/255.0 green:146.0/255.0 blue:156.0/255.0 alpha:1.00f]

@interface VWNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation VWNavigationController

+ (void)initialize
{
    
    if (self == [VWNavigationController class]) { // 肯定能保证只调用一次
        
        // 1.设置全局导航条外观
        [self setupNav];
        
        // 2.设置全局barButton外观
        [self setupBarButton];
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //    设置手势响应
    self.interactivePopGestureRecognizer.delegate = self;
}


#pragma mark -- 设置全导航条
+ (void)setupNav
{
    // 获取应用程序中所有的导航条
// 去除导航条下的细线

    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[VWNavigationController class]]];
//    bar.alpha = 0.0;
//    UIColor *color = [UIColor clearColor];
//    CGRect rect = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 64);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    bar.translucent = YES;
////    bar.clipsToBounds = YES;
//    [[UINavigationBar appearance] setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
//
    [bar setTintColor:settingBtnBackcolor];
    
//    UIImage *navImage = nil;
//    navImage = [UIImage imageNamed:@"nav_bg"];
    

//    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [bar setBackgroundColor:[UIColor whiteColor]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navBarhui"] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : settingBtnBackcolor,
                           NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18.0]
                           };
    [bar setTitleTextAttributes:dict];
    
    // 设置导航条的主题颜色
}

#pragma mark -- 设置全局的UIBarButton外观
+ (void)setupBarButton
{
    // 获取所有UIBarButton的外观
    
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
    
    [buttonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
}


/**
 *  重写这个方法目的：能够拦截所有pu进来的控制器
 *≥
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
//        /* 设置导航栏上面的内容 */
//        // 设置左边的返回按钮
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem vw_itemWithImage:@"back" highImage:@"back" target:settingBtnBackcolor action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
    
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效：当子控制器的个数 > 1
    return self.childViewControllers.count > 1;
}

@end
