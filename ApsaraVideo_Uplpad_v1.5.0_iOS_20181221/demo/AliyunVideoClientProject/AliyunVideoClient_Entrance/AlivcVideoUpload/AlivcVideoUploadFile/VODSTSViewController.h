//
//  ViewController.h
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import <UIKit/UIKit.h>
/**
 使用sts方式上传到点播服务
 */
@interface VODSTSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy) NSString *keyId;
@property(nonatomic, copy) NSString *keySecret;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *expireTime;
@end

