//
//  MomentListCell.h
//  example-OC
//
//  Created by Murphy on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ListViewProtocol;

@interface MomentListCell : UITableViewCell

@property (nonatomic, readonly) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy) NSArray<id<ListViewProtocol>> *viewArray;

@end

NS_ASSUME_NONNULL_END
