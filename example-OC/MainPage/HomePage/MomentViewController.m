//
//  MomentViewController.m
//  example-OC
//
//  Created by Murphy on 2022/4/11.
//

#import "MomentViewController.h"
#import "MomentListCell/MomentListCell.h"
#import "ListView/ListViewController.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>


#define kStatusBarHeight ((UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject).statusBarManager.statusBarFrame.size.height

static CGFloat const kScrollViewHeight = 200;
static CGFloat const kSelectTabHeight = 44;

@interface MomentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray<id<ListViewProtocol>> *listArray;

@end

@implementation MomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self createUI];
    NSLog(@"%@",@(kStatusBarHeight));
    NSLog(@"%@",@(self.tabBarController.tabBar.frame.size.height));
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kSelectTabHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [self viewWithColor:[UIColor grayColor]];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MomentListCell class])];
    cell.flowLayout.itemSize = CGSizeMake(kScreenWidth, [self viewHeight]);
    cell.viewArray = self.listArray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self viewHeight];
}

- (CGFloat)viewHeight {
    return kScreenHeight - kStatusBarHeight - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - kSelectTabHeight;
}

- (ListViewController *)listVCWithNumber:(NSInteger)number {
    ListViewController *listVC = [[ListViewController alloc] init];
    listVC.itemNumber = number;
    @weakify(self);
    listVC.didScroll = ^(UIScrollView * _Nonnull scrollView) {
        @strongify(self);
        CGFloat offsetY = scrollView.contentOffset.y;
        if (self.tableView.contentOffset.y < kScrollViewHeight) {
            CGPoint offset = self.tableView.contentOffset;
            offset.y = MAX(0, MIN(offset.y + offsetY, kScrollViewHeight));
            self.tableView.contentOffset = offset;
            if (self.tableView.contentOffset.y > 0) {
                scrollView.contentOffset = CGPointZero;
            }
        } else {
            NSLog(@"%@",@(offsetY));
            self.tableView.contentOffset = CGPointMake(0, MIN(MAX(0, scrollView.contentOffset.y + kScrollViewHeight), kScrollViewHeight));
        }
    };
    [self addChildViewController:listVC];
    return listVC;
}

#pragma mark - UI
- (void)createUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UIView *headerView = [self viewWithColor:[UIColor redColor]];
        headerView.frame = CGRectMake(0, 0, kScreenWidth, kScrollViewHeight);
        _tableView.tableHeaderView = headerView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderTopPadding = 0;
        [_tableView registerClass:[MomentListCell class] forCellReuseIdentifier:NSStringFromClass([MomentListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray<id<ListViewProtocol>> *)listArray {
    if (!_listArray) {
        _listArray = @[[self listVCWithNumber:20], [self listVCWithNumber:30]];
    }
    return _listArray;
}

- (UIView *)viewWithColor:(UIColor *)color {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
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
