//
//  STSViewController.h
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UploadTypeVOD,
    UploadTypeSVideo,
} UploadType;

@interface STSViewController : UIViewController
@property (nonatomic, assign) UploadType type;
@end
