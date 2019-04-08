//
//  STSViewController.m
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import "STSViewController.h"
#import "DemoApi.h"
#import "VODSTSViewController.h"
#import "SVideoViewController.h"

@interface STSViewController ()

@end

@implementation STSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *fetch = [UIButton buttonWithType:UIButtonTypeSystem];
    fetch.frame = CGRectMake(100, 100, 60, 44);
    [fetch setTitle:@"获取STS" forState:UIControlStateNormal];
    [fetch addTarget:self action:@selector(fetchClicked) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fetch];
}


- (void)fetchClicked {
    // 演示demo使用的STS请求
    // 真实应用场景需要开发者的AppServer端提供STS请求接口
    [DemoApi requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
        if (error) {
            NSLog(@"GET STS FAILED:%@", error.description);
            return;
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_type == UploadTypeSVideo) {
                SVideoViewController *vc = [SVideoViewController new];
                vc.keyId = keyId;
                vc.keySecret = keySecret;
                vc.token = token;
                vc.expireTime = expireTime;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                VODSTSViewController *vc = [VODSTSViewController new];
                vc.keyId = keyId;
                vc.keySecret = keySecret;
                vc.token = token;
                vc.expireTime = expireTime;
                [self.navigationController pushViewController:vc animated:YES];
            }
        });
    }];
}

@end
