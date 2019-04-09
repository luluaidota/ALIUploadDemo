//
//  GLVODUpload.h
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadClient.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLVODUpload : NSObject

//单例
+ (instancetype)sharedInstance;

//上传视频/图片/音频文件
- (void)uploadFileWithFilePath:(NSString *)filePath videoInfo:(VodInfo *)vodInfo;


//开始上传
- (void)start;
//停止上传
- (void)stop;
//暂停上传
- (void)pause;
//恢复上传
- (void)resume;

//删除最后一个上传
- (void)deleteFile;
//取消最后一个上传
- (void)cancelFile;
//恢复列表的单个文件上传
- (void)resumeFile;

//上传文件的列表
- (NSMutableArray<UploadFileInfo *> *)listFiles;
//清空列表
- (void)clearList;



@end

NS_ASSUME_NONNULL_END
