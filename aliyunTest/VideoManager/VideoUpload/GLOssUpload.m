//
//  GLOssUpload.m
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import "GLOssUpload.h"
#import "AliyunPathManager.h"
#import "NSString+AlivcHelper.h"

static NSString *const Endpoint   = @"http://oss-cn-shenzhen.aliyuncs.com";
static NSString *const BucketName = @"gali-pub";
static NSString *haojiAccessKey = @"LTAITvfYgG2rSoI9";
static NSString *haojiAccessSecret = @"6SxOjOSLmqMI4VSnihF7wQKkD2cuEb";


@interface GLOssUpload ()

@property (nonatomic, strong) OSSClient *client;  //普通的简单上传

@end

@implementation GLOssUpload

+ (instancetype)sharedInstance {
    
    static GLOssUpload *g_manager = nil;
    static dispatch_once_t onceToken;
    
    if (!g_manager) {
        dispatch_once(&onceToken, ^{
            g_manager = [GLOssUpload new];
        });
    }
    
    return g_manager;
    
}

- (instancetype)init {
    if (self = [super init]) {
        [self initClient];
    }
    
    return self;
}

- (void)initClient {
    
    MJWeakSelf
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        // 您需要在这里实现获取一个FederationToken，并构造成OSSFederationToken对象返回
        // 如果因为某种原因获取失败，可直接返回nil
        __block OSSFederationToken *token;
        // 下面是一些获取token的代码，比如从您的server获取
        OSSTaskCompletionSource *tcs = [OSSTaskCompletionSource taskCompletionSource];
        // TODO
        //获取凭证
//        [self getCredentialsWithCompleteHandle:^(BOOL isSuccess) {
//            if (isSuccess) {
//                token = [OSSFederationToken new];
//                token.tAccessKey = weakSelf.accessKeyId;
//                token.tSecretKey = weakSelf.accessKeySecret;
//                token.tToken = weakSelf.securityToken;
//                token.expirationTimeInGMTFormat = weakSelf.expirationTime;
//
//                [tcs setResult:token];
//            }else {
//                return;
//            }
//
//        }];
        
        [tcs.task waitUntilFinished];
        if (tcs.task.result) {
            return token;
        }else {
            return nil;
        }
    }];
    
    _client = [[OSSClient alloc] initWithEndpoint:Endpoint credentialProvider:credential];
    
}

//上传普通的图片头像或者封面图
- (void)uploadNormalImageWithType:(UploadNormalType)type filePath:(NSString *)filePath {
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = BucketName;
    put.objectKey = [self createImageNameWithFilePath:filePath type:type];
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    //    put.uploadingData
    OSSTask *putTask = [self.client putObject:put];
    
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error) {
            DLog(@"上传成功");
        }else {
            
            DLog(@"上传失败=== %@",task.error.localizedDescription);
        }
        return nil;
    }];
    //等待任务完成
    //    [putTask waitUntilFinished];
}

//生成一个类型
- (NSString *)createImageNameWithFilePath:(NSString *)filePath type:(UploadNormalType)type{
    
    //当前时间
    NSInteger time = (int)([[NSDate date] timeIntervalSince1970]);
    NSString *name = [NSString stringWithFormat:@"%@%ld%@",filePath,time,[AliyunPathManager randomString]];
    
    NSString *md5Str = [NSString aliyun_MD5:name];
    if (type == UploadHeadImage) {
        //头像
        md5Str = [NSString stringWithFormat:@"avatar/%@",md5Str];
    }else if (type == UploadCoverImage) {
        //封面
        md5Str = [NSString stringWithFormat:@"user_cover/%@",md5Str];
    }else {
        
    }
    
    if ([self isExistFileWithFileName:md5Str]) {
        //再循环一遍
        return [self createImageNameWithFilePath:filePath type:type];
    }else {
        return md5Str;
    }
}

//判断是否存在当前文件
- (BOOL)isExistFileWithFileName:(NSString *)fileName {
    NSError *error = nil;
    BOOL isExist = [self.client doesObjectExistInBucket:BucketName objectKey:fileName error:&error];
    if (!error) {
        return isExist;
    }else {
        //判断出错
        DLog(@"判断是否存在当前文件出错%@",error.localizedDescription);
        return YES;
    }
}
@end
