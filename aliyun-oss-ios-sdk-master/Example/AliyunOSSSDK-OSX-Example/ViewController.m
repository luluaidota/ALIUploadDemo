//
//  ViewController.m
//  AliyunOSSSDK-OSX-Example
//
//  Created by huaixu on 2017/11/28.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ViewController.h"
#import <AliyunOSSOSX/AliyunOSSiOS.h>

@interface ViewController (){
    OSSClient *_client;
}

@end

@implementation ViewController

NSString * const BUCKET_NAME = @"sample-bucket";
NSString * const DOWNLOAD_OBJECT_KEY = @"object-key";
NSString * const endPoint = @"http://oss-cn-hangzhou.aliyuncs.com";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    OSSPlainTextAKSKPairCredentialProvider *provider = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"AK" secretKey:@"SK"];
    
    [OSSLog enableLog];
    _client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:provider];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}
- (IBAction)getObjectButtonClicked:(id)sender {
    OSSGetObjectRequest * getRequest = [OSSGetObjectRequest new];
    getRequest.bucketName = BUCKET_NAME;
    getRequest.objectKey = DOWNLOAD_OBJECT_KEY;
    OSSTask * task = [_client getObject:getRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSLogVerbose(@"Get image success!");
        } else {
            OSSLogVerbose(@"Get image failed!\nErrorMsg: %@",task.error);
        }
        return nil;
    }];
}

@end
