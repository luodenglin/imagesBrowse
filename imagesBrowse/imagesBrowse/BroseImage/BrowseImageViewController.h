//
//  BrowseImageViewController.h
//  EmpBridge
//
//  Created by luodl on 2021/8/19.
//  Copyright © 2021 Luodl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrowseImageViewController : UIViewController

@property (nonatomic, strong) NSArray *imagesArr;//图片数组
@property (nonatomic, assign) NSInteger curretnItem;//当前所选下标
@property (nonatomic, assign) CGFloat minimumZoomScale;//最小缩放比例
@property (nonatomic, assign) CGFloat maximumZoomScale;//最大缩放比例
@property (nonatomic, assign) CGFloat currentZoomScale;//当前缩放比例

@end

NS_ASSUME_NONNULL_END
