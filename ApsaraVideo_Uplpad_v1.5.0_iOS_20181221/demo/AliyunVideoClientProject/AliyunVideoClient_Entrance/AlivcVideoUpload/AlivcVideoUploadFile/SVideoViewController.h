//
//  TestViewController.h
//  VODUploadDemo
//
//  Created by Worthy on 2017/11/9.
//

#import <UIKit/UIKit.h>
/**
 短视频场景使用sts方式上传到点播服务
 短视频场景主要差异点在于封装了视频和对应缩略图的上传，简化开发者代码调用
 短视频场景目前只支持sts方式上传
 想要使用点播凭证方式上传视频和对应缩略图可以自行实现
 */
@interface SVideoViewController : UIViewController
@property(nonatomic, copy) NSString *keyId;
@property(nonatomic, copy) NSString *keySecret;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *expireTime;
@end
