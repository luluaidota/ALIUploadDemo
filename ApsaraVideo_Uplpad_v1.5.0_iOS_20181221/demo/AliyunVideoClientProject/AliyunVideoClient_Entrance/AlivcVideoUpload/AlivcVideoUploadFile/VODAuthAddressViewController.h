//
//  ViewController.h
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import <UIKit/UIKit.h>
/**
 使用点播凭证方式上传到点播服务
 */
@interface VODAuthAddressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy) NSString *uploadAuth;
@property(nonatomic, copy) NSString *uploadAddress;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *expireTime;
@end

