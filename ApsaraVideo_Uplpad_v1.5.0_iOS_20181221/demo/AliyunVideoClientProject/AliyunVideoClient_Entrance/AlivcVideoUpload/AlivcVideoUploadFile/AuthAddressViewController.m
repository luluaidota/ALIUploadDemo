//
//  STSViewController.m
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import "AuthAddressViewController.h"
#import "DemoApi.h"
#import "VODAuthAddressViewController.h"

@interface AuthAddressViewController ()

@end

@implementation AuthAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *fetch = [UIButton buttonWithType:UIButtonTypeSystem];
    fetch.frame = CGRectMake(100, 100, 100, 44);
    [fetch setTitle:@"获取点播凭证" forState:UIControlStateNormal];
    [fetch addTarget:self action:@selector(fetchClicked) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fetch];
}


- (void)fetchClicked {
    // 演示demo使用的点播凭证请求
    // 真实应用场景需要开发者的AppServer端提供点播凭证请求接口
    [DemoApi createUploadVideoWithTitle:@"testtitle" fileName:@"testfilename.mp4" handler:^(NSString *UploadAddress, NSString *UploadAuth, NSString *VideoId, NSString *RequestId, NSError *error) {
        if (error) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            VODAuthAddressViewController *vc = [VODAuthAddressViewController new];
            vc.uploadAuth = UploadAuth;
            vc.uploadAddress = UploadAddress;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    }];
}

@end
