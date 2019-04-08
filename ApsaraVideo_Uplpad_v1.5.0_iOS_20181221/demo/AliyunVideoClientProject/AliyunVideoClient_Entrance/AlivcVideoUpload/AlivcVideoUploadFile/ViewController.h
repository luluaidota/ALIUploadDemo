//
//  ViewController.h
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableFiles;

@end

