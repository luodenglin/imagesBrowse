//
//  ImagesCollectionViewCell.h
//  EmpBridge
//
//  Created by luodl on 2021/8/20.
//  Copyright © 2021 Luodl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagesCollectionCellDelegate <NSObject>

- (void)cellSingleTap;
- (void)cellLongPressClick:(UIImage *)saveImage;

@end

@interface ImagesCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, weak) id<ImagesCollectionCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
