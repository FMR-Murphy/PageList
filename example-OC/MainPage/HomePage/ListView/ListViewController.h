//
//  ListViewController.h
//  example-OC
//
//  Created by Murphy on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ListViewProtocol <NSObject>

- (UIScrollView *)scrollView;

@end

@interface ListViewController : UIViewController <ListViewProtocol>

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic) NSInteger itemNumber;

@property (nonatomic) void(^didScroll)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
