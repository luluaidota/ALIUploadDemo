//
//  ViewController.m
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import "ViewController.h"
#import "VODUploadDemo.h"
#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *percentList;
    
}

@end

static VODUploadDemo *demo;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *test = [[UIButton alloc] initWithFrame:CGRectMake(240, 30, 40, 40)];
    [test setTitle:@"test" forState:UIControlStateNormal];
    [test setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [test addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
    
    percentList = [[NSMutableArray alloc] init];
    
    // callback functions.
    OnUploadSucceedListener testSuccessCallbackFunc = ^(UploadFileInfo* fileInfo){
        NSLog(@"%@", [NSString stringWithFormat:@"upload success! %@", fileInfo.filePath]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });

    };
    
    OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        NSLog(@"failed code = %@, error message = %@", code, message);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });

    };
    
    OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        NSLog(@"progress uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
        UploadFileInfo* info;
        int i = 0;
        for(; i<[[demo listFiles] count]; i++) {
            info = [[demo listFiles] objectAtIndex:i];
            if (info == fileInfo) {
                break;
            }
        }
        if (nil == info) {
            return;
        }
        
        [percentList setObject:[NSString stringWithFormat:@"%ld", uploadedSize*100/totalSize] atIndexedSubscript:i];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });

    };
    
    OnUploadTokenExpiredListener testTokenExpiredCallbackFunc = ^{
        NSLog(@"token expired.");
        // update sts token and call resumeWithToken
        NSString *auth = @"xxxyyyzzz";
        [demo resumeWithAuth:auth];
    };
    
    OnUploadRertyListener testRetryCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    OnUploadRertyResumeListener testRetryResumeCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"upload started .");
        [demo setUploadAuth:fileInfo];
    };
    
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    
    listener.success = testSuccessCallbackFunc;
    listener.failure = testFailedCallbackFunc;
    listener.progress = testProgressCallbackFunc;
    listener.expire = testTokenExpiredCallbackFunc;
    listener.retry = testRetryCallbackFunc;
    listener.retryResume = testRetryResumeCallbackFunc;
    listener.started = testUploadStartedCallbackFunc;
    
    
    demo = [[VODUploadDemo alloc] initWithListener:listener];

    // Do any additional setup after loading the view, typically from a nib.
    _tableFiles.delegate = self;
    _tableFiles.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray<UploadFileInfo *> * list = [demo listFiles];
    
    return [list count];
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [[UITableViewCell alloc] init];
    NSMutableArray<UploadFileInfo *> * list = [demo listFiles];
    UploadFileInfo *info = [list objectAtIndex:(long)indexPath.row];
    NSString * cellID = [NSString stringWithFormat:@"cell_sec_%ld", (long)indexPath.section ];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[info.filePath substringFromIndex:info.filePath.length - 14], [self convertToString:info.state]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@%%", info.object, [percentList objectAtIndex:(long)indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) convertToString:(VODUploadFileStatus) state {
    NSString *result = nil;
    
    switch(state) {
        case 0:
            result = @"Ready";
            break;
        case 1:
            result = @"Uploading";
            break;
        case 2:
            result = @"Canceled";
            break;
            
        case 3:
            result = @"Paused";
            break;
            
        case 4:
            result = @"Success";
            break;
            
        case 5:
            result = @"Failure";
            break;

        default:
            result = @"unknown";
    }
    
    return result;
}

- (IBAction)addFile:(id)sender {
    NSLog(@"addFile clicked.");
    [demo addFile];
    [percentList addObject:[NSString stringWithFormat:@"%d", 0]];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (IBAction)getList:(id)sender {
    NSLog(@"getList clicked.");
    [demo listFiles];
}

- (IBAction)clearList:(id)sender {
    NSLog(@"clearList clicked.");
    [demo clearList];
    [percentList removeAllObjects];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)deleteFile:(id)sender {
    NSLog(@"deleteFile clicked.");
    [demo deleteFile];
    if (percentList.count > 0) {
        [percentList removeObjectAtIndex:percentList.count - 1];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)cancelFile:(id)sender {
    NSLog(@"cancelFile clicked.");
    [demo cancelFile];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)resumeFile:(id)sender {
    NSLog(@"resumeFile clicked.");
    [demo resumeFile];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)startUpload:(id)sender {
    NSLog(@"startUpload clicked.");
    [demo start];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)stopUpload:(id)sender {
    NSLog(@"stopUpload clicked");
    [demo stop];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)pauseUpload:(id)sender {
    NSLog(@"pauseUpload clicked");
    [demo pause];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)resumeUpload:(id)sender {
    NSLog(@"resumeUpload clicked");
    [demo resume];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

@end
