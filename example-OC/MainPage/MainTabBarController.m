//
//  MainTabBarController.m
//  example-OC
//
//  Created by Murphy on 2022/4/11.
//

#import "MainTabBarController.h"

#import "HomePage/HomeViewController.h"
#import "HomePage/MomentViewController.h"
#import "HomePage/MyViewController.h"
#import "BaseNavigationController/BaseNavigationViewController.h"
#import <YYKit/YYKit.h>


@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTabViewControllers];
}

- (void)setTabViewControllers {
    HomeViewController *home = [[HomeViewController alloc] init];
    BaseNavigationViewController *homeNav = [self navWithTitle:@"首页" viewController:home];
    
    MomentViewController *moment = [[MomentViewController alloc] init];
    BaseNavigationViewController *momentNav = [self navWithTitle:@"动态" viewController:moment];
    
    MyViewController *my = [[MyViewController alloc] init];
    BaseNavigationViewController *myNav = [self navWithTitle:@"我的" viewController:my];
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.viewControllers = @[homeNav, momentNav, myNav];
    
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
}

- (BaseNavigationViewController *)navWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
    nav.tabBarItem = item;
    return nav;
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
