//
//  TestViewController.m
//  aliyunTest
//
//  Created by Lucky on 2019/4/9.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import "TestViewController.h"
#import <VODUpload/VODUploadClient.h>

@interface TestViewController (){
    
    VODUploadClient *uploader;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.redColor;
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [addBtn setTitle:@"上传" forState:UIControlStateNormal];
    addBtn.backgroundColor = UIColor.blueColor;
    [addBtn addTarget:self action:@selector(addFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    uploader = [VODUploadClient new];
    __weak VODUploadClient *weakClient = uploader;
    
    // callback functions and listener
    OnUploadFinishedListener testFinishCallbackFunc = ^(UploadFileInfo* fileInfo,  VodUploadResult* result){
        NSLog(@"wz on upload finished videoid:%@, imageurl:%@", result.videoId, result.imageUrl);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        //            [weakTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        //        });
    };
    
    OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        NSLog(@"failed code = %@, error message = %@", code, message);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        //            [weakTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        //        });
    };
    
    OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        NSLog(@"progress uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
        //        UploadFileInfo* info;
        //        int i = 0;
        //        for(; i<[[weakClient listFiles] count]; i++) {
        //            info = [[weakClient listFiles] objectAtIndex:i];
        //            if (info == fileInfo) {
        //                break;
        //            }
        //        }
        //        if (nil == info) {
        //            return;
        //        }
        //
        //        [weakList setObject:[NSString stringWithFormat:@"%ld", uploadedSize*100/totalSize] atIndexedSubscript:i];
        //
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        //            [weakTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        //        });
    };
    
    OnUploadTokenExpiredListener testTokenExpiredCallbackFunc = ^{
        NSLog(@"token expired.");
        //        [DemoApi requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
        //            if (!error) {
        //                [weakClient resumeWithToken:keyId accessKeySecret:keySecret secretToken:token expireTime:expireTime];
        //            }
        //        }];
    };
    
    OnUploadRertyListener testRetryCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    OnUploadRertyResumeListener testRetryResumeCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"upload started .");
        // Warning:每次上传都应该是独立的uploadAuth和uploadAddress
        // Warning:demo为了演示方便，使用了固定的uploadAuth和uploadAddress
        //        [weakClient setUploadAuthAndAddress:fileInfo uploadAuth:weakSelf.uploadAuth uploadAddress:weakSelf.uploadAddress];
    };
    
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.finish = testFinishCallbackFunc;
    listener.failure = testFailedCallbackFunc;
    listener.progress = testProgressCallbackFunc;
    listener.expire = testTokenExpiredCallbackFunc;
    listener.retry = testRetryCallbackFunc;
    listener.retryResume = testRetryResumeCallbackFunc;
    listener.started = testUploadStartedCallbackFunc;
    // 点播上传。每次上传都是独立的鉴权，所以初始化时，不需要设置鉴权
    //    [uploader init];
    [uploader init:listener];
    
//    [[GLUploadDataManager shareInstance] getVODCredentialsCompleteHandle:^(BOOL isSuccess) {
//        if (isSuccess) {
//            [uploader init:[GLUploadDataManager shareInstance].accessKeyId accessKeySecret:[GLUploadDataManager shareInstance].accessKeySecret secretToken:[GLUploadDataManager shareInstance].securityToken expireTime:[GLUploadDataManager shareInstance].expirationTime listener:listener];
//
//            [self addFile];
//        }
//    }];
    
    [uploader init:@"STS.NH91yjHdoxdu1hK4761t5pMsx" accessKeySecret:@"D72kpWwXsuckFke298hsRi2PDUGQw2uL1r7pQt15oC1Y" secretToken:@"CAIS9wF1q6Ft5B2yfSjIr4uMesPepbtOz6aeM0760DdjPfsZn4jYmjz2IHFFdHVhAukWv/wwmm1Y7fwZlqNNTJN+SFffbMx2tmnOQetpJtivgde8yJBZoqDHcDHhM3yW9cvWZPqDArG5U/yxalfCuzZuyL/hD1uLVECkNpv77/wKcNMbDEvaAD1dH4UUXHwAzvUXLnzML/2gHwf3i27LdipStxF7lHl05NbUoKTeyGKH0weim7VI99mqfMf8NZMyBvolDYfpht4RX7HazStd5yJN8KpLl6Fe8V/FxIrMUgkNsk7fY7uMrYMyfFQjPbJRBalIvEIiOCTUdwO4GoABSy3W1x7qpDLozID+NzQ48B37rdSxtMaLHr5DE0vG5nulCZHcFBXcXBoWOr10LfP12cQEEWumeVskuZMjX4vbno/KH3PvSznigiBEa6mXyB+nQmvvhx2FCXcsxGyX9AmbM3atBwzy7rY0cCUgQ6/qkWO8CUg+71lmwvYOGTw9wZQ=" expireTime:@"2019-04-09T03:13:37Z" listener:listener];
    
//    [self addFile];
    
}

- (void)addFile {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@"mp4"];
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"default_pictureIconhhhh" ofType:@"png"];
    
    //    NSString *ossObject = [NSString stringWithFormat:@"uploadtest/%ld.ios.demo.mp4", pos];
    
    VodInfo *vodInfo = [[VodInfo alloc] init];
    vodInfo.cateId = @(19);
    
    [uploader addFile:filePath vodInfo:vodInfo];
    [uploader start];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
