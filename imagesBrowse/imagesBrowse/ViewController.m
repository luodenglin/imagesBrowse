//
//  ViewController.m
//  imagesBrowse
//
//  Created by luodl on 2021/8/28.
//

#import "ViewController.h"
#import "BrowseImageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"打开大图浏览" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake((self.view.bounds.size.width-200)/2, 100, 200, 50);
    [button addTarget:self action:@selector(openImagesBrowse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)openImagesBrowse{
    CATransition *transitionAnmation = [CATransition animation];
    transitionAnmation.duration = 0.3;
    transitionAnmation.type = kCATransitionFade;
    [self.view.window.layer addAnimation:transitionAnmation forKey:kCATransition];
    NSArray *imagesArr = @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201312%2F28%2F124740dp1gp9ip9mzwpxlw.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1632364394&t=5cfec9f0748101ea645a477fe514a8ca",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbenyouhuifile.it168.com%2Fforum%2F201304%2F06%2F11435052yrezzae1bua8ee.jpg&refer=http%3A%2F%2Fbenyouhuifile.it168.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1632364394&t=9732f7779bcab3d765c233ddf882af47",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201408%2F20%2F20140820214016_kTHCC.png&refer=http%3A%2F%2Fcdn.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1632364394&t=dce023af675f7f92dc3b6380095944e7"];
    BrowseImageViewController *broseImageVC = [[BrowseImageViewController alloc] init];
    broseImageVC.imagesArr = imagesArr;
    broseImageVC.curretnItem = 0;
    broseImageVC.currentZoomScale = 1.0;
    broseImageVC.maximumZoomScale = 2.5;
    broseImageVC.minimumZoomScale = 1.0;
    broseImageVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:broseImageVC animated:NO completion:nil];
}

@end
