//
//  GLFileManager.h
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLFileManager : NSObject

+ (instancetype) shareInstance;

/**
 *  设置头像
 *
 *  @param image 图片
 */
- (NSString *)setImage:(UIImage *)image forKey:(NSString *)key;

/**
 *  读取图片
 *
 */
- (UIImage *)imageForKey:(NSString *)key;

/**
 生成当前时间的文件路径
 
 @param key 视频：mp4  音频：amr、mav   图片：png、jpg
 @return 路径
 */
- (NSString *)filePathWithKey:(NSString *)key;

//删除某个路径下的文件
- (void)removeFileWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
