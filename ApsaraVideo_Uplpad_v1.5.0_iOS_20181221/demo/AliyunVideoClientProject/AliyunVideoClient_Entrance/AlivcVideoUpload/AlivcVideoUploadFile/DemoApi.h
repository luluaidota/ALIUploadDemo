//
//  DemoApi.h
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import <Foundation/Foundation.h>

@interface DemoApi : NSObject
+ (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler;

+ (void)requestOSSSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime, NSString *prefix ,NSString *endpoint ,NSString *bucket, NSError * error))handler;

+ (void)createUploadVideoWithTitle:(NSString *)title
                          fileName:(NSString *)fileName
                           handler:(void (^)(NSString *UploadAddress, NSString* UploadAuth,NSString *VideoId, NSString *RequestId, NSError * error))handler;

@end
