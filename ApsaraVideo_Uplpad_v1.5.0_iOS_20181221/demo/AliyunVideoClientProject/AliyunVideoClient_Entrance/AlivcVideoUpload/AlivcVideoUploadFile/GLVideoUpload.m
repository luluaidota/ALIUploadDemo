//
//  GLVideoUpload.m
//  gali
//
//  Created by Lucky on 2019/4/2.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import "GLVideoUpload.h"
#import <VODUpload/VODUploadClient.h>
#import "NSString+AlivcHelper.h"
#import "DemoApi.h"

static NSString *const Endpoint   = @"http://oss-cn-shenzhen.aliyuncs.com";
static NSString *const BucketName = @"gali-pub";
static NSString *haojiAccessKey = @"LTAITvfYgG2rSoI9";
static NSString *haojiAccessSecret = @"6SxOjOSLmqMI4VSnihF7wQKkD2cuEb";

static VODUploadClient *Uploader = nil;

@interface GLVideoUpload()



@property (nonatomic, assign) BOOL isFirst;

@end

@implementation GLVideoUpload

+ (instancetype)sharedInstance {
    static GLVideoUpload *g_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        g_manager = [[GLVideoUpload alloc] init];
        Uploader = [[VODUploadClient alloc] init];
        __weak VODUploadClient *weakClient = Uploader;
//        [Uploader init:[g_manager structureListener]];
//        获取凭证，并且初始化Uploader
//        BOOL hh = [Uploader init:haojiAccessKey accessKeySecret:haojiAccessSecret listener:[g_manager structureListener]];
//        int i = 0;
        [DemoApi requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
            if (!error) {
                BOOL hh = [weakClient resumeWithToken:keyId accessKeySecret:keySecret secretToken:token expireTime:expireTime];
            }
        }];
    });
    
    return g_manager;
    
}

- (instancetype)init {
    
    if (self = [super init]) {
        _isFirst = YES;
        [self initPublishManager];
//        [self initClient];
    }
    return self;
}

- (void)initPublishManager {
//    _manager = [AliyunPublishManager new];
//    _manager.exportCallback = self;
//    _manager.transcode = NO;
}

//- (void)initClient {
//
//
//    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
//        // 您需要在这里实现获取一个FederationToken，并构造成OSSFederationToken对象返回
//        // 如果因为某种原因获取失败，可直接返回nil
//        __block OSSFederationToken *token;
//        // 下面是一些获取token的代码，比如从您的server获取
//        OSSTaskCompletionSource *tcs = [OSSTaskCompletionSource taskCompletionSource];
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
//
//        [tcs.task waitUntilFinished];
//        if (tcs.task.result) {
//            return token;
//        }else {
//            return nil;
//        }
//    }];
//
//    _client = [[OSSClient alloc] initWithEndpoint:Endpoint credentialProvider:credential];
//
//}
//
////上传普通的图片头像或者封面图
//- (void)uploadNormalImageWithType:(UploadNormalType)type filePath:(NSString *)filePath {
//
//    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
//    put.bucketName = BucketName;
//    put.objectKey = [self createImageNameWithFilePath:filePath type:type];
//    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
////    put.uploadingData
//    OSSTask *putTask = [self.client putObject:put];
//
//    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
//        if (!task.error) {
//            DLog(@"上传成功");
//        }else {
//
//            DLog(@"上传失败=== %@",task.error.localizedDescription);
//        }
//        return nil;
//    }];
//    //等待任务完成
////    [putTask waitUntilFinished];
//}

//生成一个类型
//- (NSString *)createImageNameWithFilePath:(NSString *)filePath type:(UploadNormalType)type{
//
//    //当前时间
//    NSInteger time = (int)([[NSDate date] timeIntervalSince1970]);
//    NSString *name = [NSString stringWithFormat:@"%@%ld%@",filePath,time,[AliyunPathManager randomString]];
//
//    NSString *md5Str = [NSString aliyun_MD5:name];
//    if (type == UploadHeadImage) {
//        //头像
//        md5Str = [NSString stringWithFormat:@"avatar/%@",md5Str];
//    }else if (type == UploadCoverImage) {
//        //封面
//        md5Str = [NSString stringWithFormat:@"user_cover/%@",md5Str];
//    }else {
//
//    }
//
//    if ([self isExistFileWithFileName:md5Str]) {
//        //再循环一遍
//        return [self createImageNameWithFilePath:filePath type:type];
//    }else {
//        return md5Str;
//    }
//}

//判断是否存在当前文件
//- (BOOL)isExistFileWithFileName:(NSString *)fileName {
//    NSError *error = nil;
//    BOOL isExist = [self.client doesObjectExistInBucket:BucketName objectKey:fileName error:&error];
//    if (!error) {
//        return isExist;
//    }else {
//        //判断出错
//        
//        return YES;
//    }
//}

//上传视频/图片/音频
- (void)uploadVideoWithFilePath:(NSString *)filePath videoInfo:(VodInfo *)vodInfo {
    [Uploader addFile:filePath vodInfo:vodInfo];
    [Uploader start];
}

- (VODUploadListener *)structureListener {
    
    
    
    //上传失败。可恢复型的错误会自动断点续传，例如：网络异常、超时等。不可恢复类型的错误会导致失败，例如：上传凭证错误、文件不存在等
    OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        NSLog(@"failed code = %@, error message = %@", code, message);
    };
    
    //上传进度汇报。在分片上传成功时触发
    OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        NSLog(@"progress uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
        
//        if (self.CallbackUploadingBlock) {
//
//            NSNumber *longNumber = [NSNumber numberWithLong:uploadedSize/totalSize];
//            NSLog(@"++++++++++++%ld",uploadedSize/totalSize);
//            NSDictionary *dic=@{@"result":@"proportion",
//                                @"schedule":longNumber
//                                };
//            self.CallbackUploadingBlock(dic);
//        }
        
    };
    
    //上传凭证超时。需要从服务重新获取新的上传凭证，并调用resumeUploadWithAuth函数恢复上传
    OnUploadTokenExpiredListener testTokenExpiredCallbackFunc = ^{
//        [weakSelf getCredentialsWithCompleteHandle:^(BOOL isSuccess) {
//            if (isSuccess) {
//                //获取成功
//                [Uploader resumeWithToken:weakSelf.accessKeyId accessKeySecret:weakSelf.accessKeySecret secretToken:weakSelf.securityToken expireTime:weakSelf.expirationTime];
//            }else {
//                //获取失败
//
//            }
//        }];
    };
    
    //上传过程中，状态由正常切换为异常时触发。例如：网络异常，超时等（JavaScript版本不支持）
    OnUploadRertyListener testRetryCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
        
    };
    
    //上传过程中，状态由异常中恢复时触发
    OnUploadRertyResumeListener testRetryResumeCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    //每个文件开始上传时都会触发。需要在这里调用setUploadAuthAndAddress设置当前文件的上传地址和上传凭证
    OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"upload started .");
        
    };
    
    //上传成功
    OnUploadFinishedListener testFinishCallbackFunc = ^(UploadFileInfo* fileInfo,  VodUploadResult* result){
        
        
        int i = 0;
//        if (self.CallbackUploadingBlock) {
//            if(result.videoId){
//                [self NotificationServer:result.videoId VodInfo:_VodInfoDic[@"VodInfo"]];
//                NSDictionary *dic=@{@"result":@"ok",
//                                    @"type" :@"video",
//                                    @"filePath":fileInfo.filePath,
//                                    @"videoId":result.videoId
//                                    };
//                //视频上传成功，将它从保存的数组中删除
//                UserManager *userManager = [UserManagerTool userManager];
//                NSMutableArray *arry=[[NSMutableArray alloc] init];
//
//                for (NSMutableDictionary *dic in userManager.UploadedVideos) {
//                    if (![dic[@"taskPath"] isEqualToString:_VodInfoDic[@"taskPath"]]) {
//                        [arry addObject:dic];
//                    }
//                }
//
//                userManager.UploadedVideos=arry;
//                [UserManagerTool saveUserManager:userManager];
//                _VodInfoDic=nil;//置空
//                if(arry.count>0){
//                    //队列中还有没有处理完的视频
//                    [self addVideoSynthesisFile:arry[0]];
//                }
//                self.CallbackUploadingBlock(dic);
//            }else if(result.imageUrl){
//                NSDictionary *dic=@{@"result":@"ok",
//                                    @"type" :@"CoverImage",
//                                    @"filePath":fileInfo.filePath,
//                                    @"imageUrl":result.imageUrl
//                                    };
//
//                //上传视频成功，完善视频上传信息中的封面地址
//                VodInfo *vodInfo=(VodInfo *)_VodInfoDic[@"VodInfo"];
//                vodInfo.coverUrl=result.imageUrl;
//
//                UserManager *userManager = [UserManagerTool userManager];
//                NSMutableArray *arry=userManager.UploadedVideos;
//                for (NSMutableDictionary *dic in userManager.UploadedVideos) {
//                    if ([dic[@"taskPath"] isEqualToString:_VodInfoDic[@"taskPath"]]) {
//                        dic[@"VodInfo"]=vodInfo;
//                    }
//                }
//
//                userManager.UploadedVideos=arry;
//                [UserManagerTool saveUserManager:userManager];
//
//                [uploader addFile:_VodInfoDic[@"outputPath"] vodInfo:vodInfo];
//                self.CallbackUploadingBlock(dic);
//            }else{
//                NSDictionary *dic=@{@"result":@"ok",
//                                    @"type" :@"HeadImage",
//                                    @"filePath":fileInfo.filePath
//                                    };
//                self.CallbackUploadingBlock(dic);
//            }
//        }
    };
    
    //创建VODUploadListerner
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.failure = testFailedCallbackFunc;
    listener.progress = testProgressCallbackFunc;
    listener.expire = testTokenExpiredCallbackFunc;
    listener.retry = testRetryCallbackFunc;
    listener.retryResume = testRetryResumeCallbackFunc;
    listener.started = testUploadStartedCallbackFunc;
    listener.finish = testFinishCallbackFunc;
    
    return listener;
}

//删除最后一个上传
- (void)deleteFile {
    NSMutableArray<UploadFileInfo *> *list = [Uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = [Uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [Uploader deleteFile:index];
    NSLog(@"Delete file: %@", fileName);
}

//取消最后一个上传
- (void)cancelFile {
    NSMutableArray<UploadFileInfo *> *list = [Uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = [Uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [Uploader cancelFile:index];
    NSLog(@"cancelFile file: %@", fileName);
    
}

//恢复列表中的单个文件上传
- (void)resumeFile {
    NSMutableArray<UploadFileInfo *> *list = [Uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = [Uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [Uploader resumeFile:index];
    NSLog(@"resumeFile file: %@", fileName);
    
}

//获取上传文件列表
- (NSMutableArray<UploadFileInfo *> *)listFiles {
    return [Uploader listFiles];
}

//清理上传文件列表
- (void) clearList {
    [Uploader clearFiles];
}

//开始上传
- (void) start {
    [Uploader start];
}

//停止上传
- (void) stop {
    [Uploader stop];
}

//暂停上传
- (void) pause {
    [Uploader pause];
}

//恢复上传
- (void) resume {
    [Uploader resume];
}

//获取凭证
- (void)getCredentialsWithCompleteHandle:(handleBlock)block {
    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval time = [date timeIntervalSinceNow];
//
//    if (self.expirationTime.length > 0) {
//        NSTimeInterval expirationTime = [NSString getLocalFromUTC:self.expirationTime];
//        if (expirationTime - time > 360) {
//            block(YES);
//            return;
//        }
//    }
//
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
//            if (weakSelf.isFirst) {
//                weakSelf.isFirst = NO;
//                //OSS直接上传:STS方式，安全但是较为复杂，建议生产环境下使用。
//                //临时账号过期时，在onUploadTokenExpired事件中，用resumeWithToken更新临时账号，上传会续传。
//                BOOL isSucess = [Uploader init:weakSelf.accessKeyId accessKeySecret:weakSelf.accessKeySecret secretToken:weakSelf.securityToken expireTime:weakSelf.expirationTime listener:[weakSelf structureListener]];
//                int i = 0;
//            }
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
