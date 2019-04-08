//
//  GLUploadDataManager.m
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import "GLUploadDataManager.h"
#import "NSString+AlivcHelper.h"
#import "DemoApi.h"

@implementation GLUploadDataManager

//单例
+ (instancetype)shareInstance {
    static GLUploadDataManager *dataManager = nil;
    if (dataManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dataManager = [GLUploadDataManager new];
        });
    }
    
    return dataManager;
}

- (void)getVODCredentialsCompleteHandle:(handleBlock)block {
    
    __weak typeof(self) weakSelf = self;
    
    [DemoApi requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
        if (error == nil) {
            block(YES);
            weakSelf.accessKeyId = keyId;
            weakSelf.accessKeySecret = keySecret;
            weakSelf.securityToken = token;
            weakSelf.expirationTime = expireTime;
        }else {
            block(NO);
        }
    }];
}
@end
