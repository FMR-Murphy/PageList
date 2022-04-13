//
//  RootViewController.m
//  example-OC
//
//  Created by Murphy on 2022/3/22.
//

#import "RootViewController.h"
#import "MainTabBarController.h"

@interface RootViewController ()

@property (nonatomic) UINavigationController *rootNavigationController;
// 添加 app 入口页
@property (nonatomic) void(^addChildViewController)(void);

@end

@implementation RootViewController

// 重写初始化方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        __block __weak UIViewController *splash = nil;
        
        __weak typeof(self) weakSelf = self;
        // 创建 splash 页，业务处理前都展示 launchScreen的内容
        self.addChildViewController = ^{
            __strong typeof(self) strongSelf = weakSelf;
            // 这里可以搞个不一样的，看一下效果
            UIViewController *splashViewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            splash = splashViewController;
            [strongSelf addChildViewController:splashViewController];
            [strongSelf.view addSubview:splashViewController.view];
            [splashViewController didMoveToParentViewController:strongSelf];
            [strongSelf setNeedsStatusBarAppearanceUpdate];
        };
        
        dispatch_queue_t queue = dispatch_queue_create("login", DISPATCH_QUEUE_SERIAL);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
        
        // 模拟异步请求 登录等业务逻辑
        dispatch_after(time, queue, ^{
//            {
//                //监听，退出登录之后重回登录页
//                UIViewController *login = [RootViewController loginViewController];
//                [self.rootNavigationController setViewControllers:@[login] animated:YES];
//            }
            
            // 创建入口视图控制器
            UIViewController *(^createViewController)(void) = nil;
            
            // 创建首页
            UIViewController *(^createHomeViewController)(void) = ^UIViewController *{
                MainTabBarController *home = [[MainTabBarController alloc] init];
                return home;
            };
            
            BOOL isLogin = YES;
            if (isLogin) {
                // 本地 token 正常，登录成功
                createViewController = createHomeViewController;
                
            } else {
                // token 失效，重新登录
                createViewController = ^UIViewController * {
                    return [RootViewController loginViewController];
                };
            }
            
            // 回主线程
            [self dispatch_main_async_safe:^{
                void(^addRootNavigationController)(void) = ^{
                    __strong typeof(self) strongSelf = weakSelf;
                    // createViewController() 或首页，或登录页
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createViewController()];
                    navigationController.title = @"123";
                    [navigationController setNavigationBarHidden:NO];
                    [strongSelf addChildViewController:navigationController];
                    [strongSelf.view addSubview:navigationController.view];
                    navigationController.view.frame = [UIScreen mainScreen].bounds;
                    [navigationController didMoveToParentViewController:strongSelf];
                    [strongSelf setNeedsStatusBarAppearanceUpdate];
                    strongSelf.rootNavigationController = navigationController;
                };
                
                if (self.isViewLoaded) {
                    // 说明 self.addChildViewController 已经执行，splash 已经添加，需要过渡，渐出渐入
                    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        addRootNavigationController();
                    } completion:^(BOOL finished) {
                        
                    }];
                } else {
                    // 未执行 self.addChildViewController，则直接重新赋值，执行
                    self.addChildViewController = addRootNavigationController;
                }
            }];
            
        });
    }
    return self;
}

- (void)dispatch_main_async_safe:(void(^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (UIViewController *)loginViewController {
    UIViewController *login = [[UIViewController alloc] init];
    login.view.backgroundColor = [UIColor yellowColor];
    return login;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.addChildViewController();
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.childViewControllers.lastObject;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.childViewControllers.lastObject;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
