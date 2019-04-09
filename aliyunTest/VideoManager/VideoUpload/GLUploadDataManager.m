//
//  GLUploadDataManager.m
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import "GLUploadDataManager.h"
#import "NSString+AlivcHelper.h"


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
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSinceNow];
    
    if (self.expirationTime.length > 0) {
        NSTimeInterval expirationTime = [NSString getLocalFromUTC:self.expirationTime];
        if (expirationTime - time > 360) {
            block(YES);
            return;
        }
    }
    
//    MJWeakSelf
//    CredentialsReq *credent = [CredentialsReq new];
//    credent.type = @"video";
//    [API getVideoCredentialsWithMsg:credent Complete:^(id result, Response *res) {
//        if (res.stat.err == 0) {
//            
//            CredentialsRsp *rsp = (CredentialsRsp *)result;
//            weakSelf.accessKeyId = rsp.credentials.accessKeyId;
//            weakSelf.accessKeySecret = rsp.credentials.accessKeySecret;
//            weakSelf.securityToken = rsp.credentials.securityToken;
//            weakSelf.expirationTime = rsp.credentials.expiration;
//            
//            block(YES);
//            DLog(@"获取凭证成功");
//        }else {
//            block(NO);
//            DLog(@"获取凭证失败");
//        }
//    }];
}
@end
