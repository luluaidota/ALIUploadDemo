//
//  AlivcStringConvertTool.h
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/6/5.
//  Copyright © 2018年 Alibaba. All rights reserved.
//
//字符串解析
#import <Foundation/Foundation.h>

@interface AlivcStringConvertTool : NSObject
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSString *)getJsonStringWithArray:(NSArray *)array;
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
