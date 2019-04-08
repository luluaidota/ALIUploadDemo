//
//  GLUploadDataManager.h
//  gali
//
//  Created by Lucky on 2019/4/4.
//  Copyright © 2019 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//请求凭证是否返回成功
typedef void(^handleBlock)(BOOL isSuccess);

@interface GLUploadDataManager : NSObject


@property (nonatomic, copy) NSString *accessKeyId; //VOD角色id
@property (nonatomic, copy) NSString *accessKeySecret; //VOD角色Secret
@property (nonatomic, copy) NSString *securityToken; //VOD验证token
@property (nonatomic, copy) NSString *expirationTime; //VOD token有效时间

//单例
+ (instancetype)shareInstance;

//获取上传文件的凭证
- (void)getVODCredentialsCompleteHandle:(handleBlock)block;

@end

NS_ASSUME_NONNULL_END
