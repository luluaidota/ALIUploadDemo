//
//  GLOssUpload.h
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UploadHeadImage,    //头像
    UploadCoverImage,   //封面图
} UploadNormalType;

@interface GLOssUpload : NSObject

//单例
+ (instancetype)sharedInstance;

//上传普通的图片头像或者封面图
- (void)uploadNormalImageWithType:(UploadNormalType)type filePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
