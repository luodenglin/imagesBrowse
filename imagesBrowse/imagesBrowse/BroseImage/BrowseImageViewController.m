//
//  BrowseImageViewController.m
//  EmpBridge
//
//  Created by luodl on 2021/8/19.
//  Copyright © 2021 Luodl. All rights reserved.
//

#import "BrowseImageViewController.h"
#import "ImagesCollectionViewCell.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import "UIImageView+WebCache.h"

@interface BrowseImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ImagesCollectionCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic, strong) UIView *sheetView;
@end

@implementation BrowseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.view.bounds.size;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ImagesCollectionViewCell class] forCellWithReuseIdentifier:@"browseImagesCell"];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.curretnItem inSection:0]
        animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    [self.view addSubview:self.collectionView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-35, self.view.bounds.size.width, 20)];
    self.pageControl.enabled = NO;
    self.pageControl.numberOfPages = self.imagesArr.count;
    self.pageControl.currentPage = self.curretnItem;
    [self.view addSubview:self.pageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/self.collectionView.bounds.size.width;
    if(currentPage != self.pageControl.currentPage){
        self.pageControl.currentPage = currentPage;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"browseImagesCell" forIndexPath:indexPath];
    cell.backScrollView.zoomScale = self.currentZoomScale;
    cell.backScrollView.minimumZoomScale = self.minimumZoomScale;
    cell.backScrollView.maximumZoomScale = self.maximumZoomScale;
    cell.delegate = self;
    __weak typeof(ImagesCollectionViewCell *) weakCell = cell;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[self.imagesArr objectAtIndex:indexPath.item]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat imageViewHeight = weakCell.contentView.bounds.size.width/image.size.width*image.size.height;
        if(imageViewHeight > weakCell.contentView.bounds.size.height){
            imageViewHeight = weakCell.contentView.bounds.size.height;
        }
        weakCell.iconImageView.frame = CGRectMake(0, (weakCell.contentView.bounds.size.height-imageViewHeight)/2, weakCell.contentView.bounds.size.width, imageViewHeight);
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagesCollectionViewCell *imagesCell = (ImagesCollectionViewCell *)cell;
    imagesCell.backScrollView.zoomScale = self.currentZoomScale;
}

- (void)cellSingleTap{
    if(self.sheetView){
        [self hiddenSheetView];
    }else{
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.type = kCATransitionFade;
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)cellLongPressClick:(UIImage *)saveImage{
    self.saveImage = saveImage;
    [self showSheetView];
}

//展示底部弹框
- (void)showSheetView{
    self.sheetView = [[UIView alloc] initWithFrame:CGRectMake(2, self.view.bounds.size.height, self.view.bounds.size.width-4, 120)];
    self.sheetView.backgroundColor = [UIColor whiteColor];
    self.sheetView.layer.cornerRadius = 5.0;
    self.sheetView.clipsToBounds = YES;
    [self.view addSubview:self.sheetView];
    
    UIButton * saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveImageBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    [saveImageBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveImageBtn setTitleColor:[UIColor colorWithRed:0.17f green:0.17f blue:0.17f alpha:1.00f] forState:UIControlStateNormal];
    [saveImageBtn addTarget:self action:@selector(saveImageToPhoto) forControlEvents:UIControlEventTouchUpInside];
    saveImageBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.sheetView addSubview:saveImageBtn];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [self.sheetView addSubview:lineView1];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 51, self.view.bounds.size.width, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.17f green:0.17f blue:0.17f alpha:1.00f] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenSheetView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.sheetView addSubview:cancelBtn];
    [UIView animateWithDuration:0.25 animations:^{
        self.sheetView.frame = CGRectMake(2, self.view.bounds.size.height-120, self.view.bounds.size.width-4, 120);
    }completion:nil];
    
}

//隐藏底部弹框
- (void)hiddenSheetView{
    [UIView animateWithDuration:0.25 animations:^{
        self.sheetView.frame = CGRectMake(2, self.view.bounds.size.height, self.view.bounds.size.width-4, 120);
    }completion:^(BOOL finished) {
        [self.sheetView removeFromSuperview];
        self.sheetView = nil;
    }];
}

- (void)showToat:(NSString *)toastMessage{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-120)/2, (self.view.bounds.size.height-60)/2, 120, 60)];
    titleLabel.backgroundColor = [UIColor colorWithRed:0.54f green:0.55f blue:0.54f alpha:1.00f];
    titleLabel.text = toastMessage;
    titleLabel.numberOfLines = 2;
    titleLabel.tag = 300;
    titleLabel.alpha = 0.0;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.layer.cornerRadius = 5.0;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [UIView animateWithDuration:0.2 animations:^{
        titleLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self hiddenToast];
    }];
}

- (void)hiddenToast{
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.2 delay:1.5 options:0 animations:^{
            titleLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [titleLabel removeFromSuperview];
    }];
}

//保存图片到相册
- (void)saveImageToPhoto{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {//权限判断
            PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
            [library performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:self.saveImage];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hiddenSheetView];
                        [self showToat:@"已保存到系统相册"];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hiddenSheetView];
                        [self showToat:@"图片保存失败"];
                    });
                }
            }];
        }
    }];
}

-(void)dealloc{
    NSLog(@"vc销毁了");
}




@end
