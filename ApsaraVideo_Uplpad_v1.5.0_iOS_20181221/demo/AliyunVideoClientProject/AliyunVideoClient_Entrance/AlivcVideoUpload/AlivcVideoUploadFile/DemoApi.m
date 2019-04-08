//
//  DemoApi.m
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import "DemoApi.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation DemoApi
+ (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler {
    // 测试用请求地址
    NSString *params = [NSString stringWithFormat:@"BusinessType=vodai&TerminalType=iphone&DeviceModel=%@&UUID=%@&AppVersion=1.0.0", [self getDeviceId], [self getDeviceModel]];
    NSString *testRequestUrl = [NSString stringWithFormat:@"https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/CreateSecurityToken?%@",params];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:testRequestUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            handler(nil,nil,nil,nil, error);
            return ;
        }
        if (data == nil) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            handler(nil,nil,nil,nil, error);
            return;
        }
        NSDictionary *dict = [jsonObj objectForKey:@"SecurityTokenInfo"];
        NSString *keyId = [dict valueForKey:@"AccessKeyId"];
        NSString *keySecret = [dict valueForKey:@"AccessKeySecret"];
        NSString *token = [dict valueForKey:@"SecurityToken"];
        NSString *expireTime = [dict valueForKey:@"Expiration"];
        if (!keyId || !keySecret || !token || !expireTime) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        handler(keyId, keySecret, token, expireTime, error);
    }];
    [task resume];
}

+ (void)requestOSSSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime, NSString *prefix ,NSString *endpoint ,NSString *bucket, NSError * error))handler {
    // 测试用请求地址
    NSString *params = [NSString stringWithFormat:@"BusinessType=vodai&TerminalType=iphone&DeviceModel=%@&UUID=%@&AppVersion=1.0.0&UploadType=oss", [self getDeviceId], [self getDeviceModel]];
    NSString *testRequestUrl = [NSString stringWithFormat:@"https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/CreateSecurityToken?%@",params];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:testRequestUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            handler(nil,nil,nil,nil,nil,nil,nil, error);
            return ;
        }
        if (data == nil) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil,nil,nil,nil, emptyError);
            return ;
        }
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            handler(nil,nil,nil,nil,nil,nil,nil, error);
            return;
        }
        NSDictionary *dict = [jsonObj objectForKey:@"SecurityTokenInfo"];
        NSString *keyId = [dict valueForKey:@"AccessKeyId"];
        NSString *keySecret = [dict valueForKey:@"AccessKeySecret"];
        NSString *token = [dict valueForKey:@"SecurityToken"];
        NSString *expireTime = [dict valueForKey:@"Expiration"];
        
        NSDictionary *addDict = [jsonObj objectForKey:@"UploadAddress"];
        NSString *prefix = [addDict valueForKey:@"Prefix"];
        NSString *endpoint = [addDict valueForKey:@"Endpoint"];
        NSString *bucket = [addDict valueForKey:@"Bucket"];
        
        
        if (!keyId || !keySecret || !token || !expireTime
            || !prefix || !endpoint || !bucket
            ) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil,nil,nil,nil, emptyError);
            return ;
        }
        handler(keyId, keySecret, token, expireTime, prefix,endpoint,bucket, error);
    }];
    [task resume];
}


+ (void)createUploadVideoWithTitle:(NSString *)title
                          fileName:(NSString *)fileName
                           handler:(void (^)(NSString *UploadAddress, NSString* UploadAuth,NSString *VideoId, NSString *RequestId, NSError * error))handler {
    // 测试用请求地址
    NSString *params = [NSString stringWithFormat:@"Title=%@&FileName=%@&BusinessType=vodai&TerminalType=iphone&DeviceModel=%@&UUID=%@&AppVersion=1.0.0",title,fileName, [self getDeviceId], [self getDeviceModel]];
    NSString *testRequestUrl = [NSString stringWithFormat:@"https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/CreateUploadVideo?%@",params];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:testRequestUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            handler(nil,nil,nil,nil, error);
            return ;
        }
        if (data == nil) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            handler(nil,nil,nil,nil, error);
            return;
        }
        NSDictionary *UploadAddress = [jsonObj objectForKey:@"UploadAddress"];
        NSString *UploadAuth = [jsonObj valueForKey:@"UploadAuth"];
        NSString *VideoId = [jsonObj valueForKey:@"VideoId"];
        NSString *RequestId = [jsonObj valueForKey:@"RequestId"];
      ;
        if (!UploadAddress || !UploadAuth||!VideoId || !RequestId) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        handler(UploadAddress, UploadAuth, VideoId, RequestId, error);
    }];
    [task resume];
}

+ (NSString *)getDeviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*)getDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}
@end
