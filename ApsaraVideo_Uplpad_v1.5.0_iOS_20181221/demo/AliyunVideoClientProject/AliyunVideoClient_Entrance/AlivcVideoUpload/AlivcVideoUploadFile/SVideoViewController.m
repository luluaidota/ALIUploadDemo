//
//  TestViewController.m
//  VODUploadDemo
//
//  Created by Worthy on 2017/11/9.
//

#import "SVideoViewController.h"
#import <VODUpload/VODUploadSVideoClient.h>
#import <sys/utsname.h>
#import "DemoApi.h"

@interface SVideoViewController () <VODUploadSVideoClientDelegate>
@property (nonatomic, strong) VODUploadSVideoClient *client;
@property (nonatomic, strong) UILabel *label;
@end

@implementation SVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubviews];
    
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate = self;
    
}

- (void)uploadClicked {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    VodSVideoInfo *info = [VodSVideoInfo new];
    info.title = @"hello test video";

    [_client uploadWithVideoPath:videoPath imagePath:imagePath svideoInfo:info accessKeyId:_keyId accessKeySecret:_keySecret accessToken:_token];
}
- (void)pauseClicked {
    [_client pause];
}
- (void)resumeClicked {
    [_client resume];
}
- (void)cancelClicked {
    [_client cancel];
}
- (void)closeClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - callback

-(void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
    _label.text = [NSString stringWithFormat:@"failed:%@",message];
        });
}

-(void)uploadSuccessWithResult:(VodSVideoUploadResult *)result {
    NSLog(@"wz successvid:%@, imageurl:%@",result.videoId, result.imageUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = [NSString stringWithFormat:@"success:%@",result.videoId];
    });
}


-(void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = [NSString stringWithFormat:@"%d %%",(int)(uploadedSize * 100/totalSize)];
    });
}

-(void)uploadTokenExpired {
    NSLog(@"uploadTokenExpired");
    [DemoApi requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
        if (!error) {
            [_client refreshWithAccessKeyId:_keyId accessKeySecret:_keySecret accessToken:_token expireTime:_expireTime];
        }
    }];
}

-(void)uploadRetry {
    NSLog(@"uploadRetry");
}

-(void)uploadRetryResume {
    NSLog(@"uploadRetryResume");
}

#pragma mark - setup view

- (void)setupSubviews {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(16, 80, 260, 40)];
    _label.textColor = [UIColor blackColor];
    [self.view addSubview:_label];
    
    UIButton *upload = [UIButton buttonWithType:UIButtonTypeSystem];
    upload.frame = CGRectMake(100, 100, 44, 44);
    [upload setTitle:@"上传" forState:UIControlStateNormal];
    [upload addTarget:self action:@selector(uploadClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upload];
    
    UIButton *pause = [UIButton buttonWithType:UIButtonTypeSystem];
    pause.frame = CGRectMake(100, 150, 44, 44);
    [pause setTitle:@"暂停" forState:UIControlStateNormal];
    [pause addTarget:self action:@selector(pauseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause];
    
    UIButton *resume = [UIButton buttonWithType:UIButtonTypeSystem];
    resume.frame = CGRectMake(100, 200, 44, 44);
    [resume setTitle:@"继续" forState:UIControlStateNormal];
    [resume addTarget:self action:@selector(resumeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resume];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.frame = CGRectMake(100, 250, 44, 44);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
