//
//  GLVODUpload.m
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import "GLVODUpload.h"
#import <VODUpload/VODUploadClient.h>
#import "NSString+AlivcHelper.h"
#import "DemoApi.h"
#import "GLUploadDataManager.h"

static VODUploadClient *Uploader;

@interface GLVODUpload()


@end

@implementation GLVODUpload

+ (instancetype)sharedInstance {
    static GLVODUpload *g_manager = nil;
    static dispatch_once_t onceToken;
    
    if (!g_manager) {
        dispatch_once(&onceToken, ^{
            g_manager = [GLVODUpload new];
            Uploader = [[VODUploadClient alloc] init];
            
            [Uploader init:[GLUploadDataManager shareInstance].accessKeyId accessKeySecret:[GLUploadDataManager shareInstance].accessKeySecret secretToken:[GLUploadDataManager shareInstance].securityToken expireTime:[GLUploadDataManager shareInstance].expirationTime listener:[g_manager structureListener]];
//            [Uploader init:@"STS.NJ1HQ6jMJ5XDmiFF8utkEVaUH" accessKeySecret:@"ArfTJqot786MYNiVUTW6mqrSiX334LXc6yjw1zYPk3Yj" secretToken:@"CAIS9wF1q6Ft5B2yfSjIr4mEA+uCh5Jrgpqvb0/3ojggeORpuaT+qjz2IHFFdHVhAukWv/wwmm1Y7fwZlqNNTJN+SFffbMx2tlW3N4hWJtivgde8yJBZoqDHcDHhM3yW9cvWZPqDArG5U/yxalfCuzZuyL/hD1uLVECkNpv77/wKcNMbDEvaAD1dH4UUXHwAzvUXLnzML/2gHwf3i27LdipStxF7lHl05NbUoKTeyGKH0weim7VI99mqfMf8NZMyBvolDYfpht4RX7HazStd5yJN8KpLl6Fe8V/FxIrMUgkNsk7fY7uMrYMyfFQjPbJRBalIvEIiOCTUdwO4GoABBx4scU9Kuk42HgX6RLTg2GeS4VEa6bmJiwUt2hu+mSs5n+C0kxm8nVF0jP+egOByskc8GhuakMIshPIOB+bcZdcHPfdlbdfKZqCK1QNjm+iltGbEir4XPUuAc4o92Wzj2WqyCvjjqaULDoLzwupt3nfBhVinDbQc3yNKXlwyBdw=" expireTime:@"2019-04-08T10:08:18Z" listener:[g_manager structureListener]];
        });
    }
    
    return g_manager;
}

//监听者
- (VODUploadListener *)structureListener {
    
    __weak VODUploadClient *weakClient = Uploader;
    
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
        [[GLUploadDataManager shareInstance] getVODCredentialsCompleteHandle:^(BOOL isSuccess) {
            if (isSuccess) {
                //获取成功
                [weakClient resumeWithToken:[GLUploadDataManager shareInstance].accessKeyId accessKeySecret:[GLUploadDataManager shareInstance].accessKeySecret secretToken:[GLUploadDataManager shareInstance].securityToken expireTime:[GLUploadDataManager shareInstance].expirationTime];
                
            }else {
                //获取失败
            }
        }];
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


- (void)uploadFileWithFilePath:(NSString *)filePath videoInfo:(VodInfo *)vodInfo {
    [Uploader addFile:filePath vodInfo:vodInfo];
    
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

@end
