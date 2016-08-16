//
//  YTNavigationController.m
//  FullScreenGestureNavigationController
//
//  Created by Heaven on 16/8/16.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "YTNavigationController.h"

@interface YTNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation YTNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    // 2. 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    // 3. 设置手势代理，拦截手势触发
    panGesture.delegate = self;
    
    // 4. 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:panGesture];
    
    // 5. 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        // 判断子控制器的数量
        NSString *title = @"返回";

        if (self.childViewControllers.count == 1) {
            
            title = self.childViewControllers.firstObject.title;
        }
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        
        // 隐藏底部的 TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
/// 手势识别将要开始
///
/// @param gestureRecognizer 手势识别
///
/// @return 返回 NO，放弃当前识别到的手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果是根视图控制器，则不支持手势返回
    return self.childViewControllers.count > 1 ? YES : NO;
}

#pragma mark - 监听方法
/// 返回上级视图控制器
- (void)goBack {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
