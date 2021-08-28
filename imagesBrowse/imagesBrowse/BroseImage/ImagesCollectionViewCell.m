//
//  ImagesCollectionViewCell.m
//  EmpBridge
//
//  Created by luodl on 2021/8/20.
//  Copyright © 2021 Luodl. All rights reserved.
//

#import "ImagesCollectionViewCell.h"

@interface ImagesCollectionViewCell ()<UIScrollViewDelegate>

@end

@implementation ImagesCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
    self.backScrollView.delegate = self;
    self.backScrollView.backgroundColor = [UIColor blackColor];
//    self.backScrollView.minimumZoomScale = 1.0;
//    self.backScrollView.maximumZoomScale = 2.5;
//    self.backScrollView.zoomScale = 1.0;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.backScrollView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.backScrollView addSubview:self.iconImageView];
    //单击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    singleTap.numberOfTapsRequired = 1;
    [self.backScrollView addGestureRecognizer:singleTap];
    //双击事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.backScrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [self.backScrollView addGestureRecognizer:longPress];
}

- (void)doubleClick:(UITapGestureRecognizer *)tap{
    if(self.backScrollView.zoomScale > 1.0){
        [self.backScrollView setZoomScale:1.0 animated:YES];
    }else{
        CGPoint touchPoint = [tap locationInView:self.iconImageView];
        CGFloat xsize = self.backScrollView.frame.size.width/self.backScrollView.maximumZoomScale;
        CGFloat ysize = self.backScrollView.frame.size.height/self.backScrollView.maximumZoomScale;
        [self.backScrollView zoomToRect:CGRectMake(touchPoint.x-xsize/2, touchPoint.y-ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{
    if(longPress.state == UIGestureRecognizerStateBegan){
        if(self.delegate && [self.delegate respondsToSelector:@selector(cellLongPressClick:)]){
            [self.delegate cellLongPressClick:self.iconImageView.image];
        }
    }
}

- (void)close{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellSingleTap)]){
        [self.delegate cellSingleTap];
    }
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  self.iconImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{

    CGFloat offsetX = (scrollView.bounds.size.width>scrollView.contentSize.width)?(scrollView.bounds.size.width-scrollView.contentSize.width)*0.5:0.0;
    CGFloat offsetY = (scrollView.bounds.size.height>scrollView.contentSize.height)?(scrollView.bounds.size.height-scrollView.contentSize.height)*0.5:0.0;
    self.iconImageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
}

-(void)dealloc{
    NSLog(@"cell销毁了");
}

@end
