//
//  ListViewController.m
//  example-OC
//
//  Created by Murphy on 2022/4/11.
//

#import "ListViewController.h"
#import <Masonry/Masonry.h>

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)setItemNumber:(NSInteger)itemNumber {
    _itemNumber = itemNumber;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewListCell"];
    
    UIListContentConfiguration *config = [UIListContentConfiguration cellConfiguration];
    config.text = @(indexPath.row).stringValue;
    cell.contentConfiguration = config;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.didScroll(scrollView);
}

- (UIScrollView *)scrollView {
    return self.tableView;
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.sectionHeaderTopPadding = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
//        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewListCell"];
    }
    return _tableView;
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
