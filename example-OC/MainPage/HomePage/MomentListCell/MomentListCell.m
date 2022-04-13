//
//  MomentListCell.m
//  example-OC
//
//  Created by Murphy on 2022/4/11.
//

#import "MomentListCell.h"
#import <Masonry/Masonry.h>
#import "ListViewController.h"

#define kStatusBarHeight ((UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject).statusBarManager.statusBarFrame.size.height


@interface MomentListCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation MomentListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self createUI];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionListCell" forIndexPath:indexPath];
    UIView * view = self.viewArray[indexPath.row].scrollView;
    [cell.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)createUI {
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - lazy
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionListCell"];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
