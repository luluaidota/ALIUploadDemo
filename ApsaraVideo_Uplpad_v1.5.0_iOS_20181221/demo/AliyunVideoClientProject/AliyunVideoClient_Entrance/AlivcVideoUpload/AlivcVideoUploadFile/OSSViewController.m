//
//  OSSViewController.m
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/8.
//

#import "OSSViewController.h"
#import <VODUpload/VODUploadClient.h>
#import "DemoApi.h"

//#import <VODUpload/VODOpenApi.h>

static NSString*  ossAccessKeyId = @"";
static NSString*  ossAccessKeySecret = @"";

static NSString*  ossSecretToken = @"";
static NSString*  ossExpireTime = @"";

static NSString *  ossEndPoint = @"";
static NSString *  ossBucketName = @"";

static NSString *  ossPrefix = @"";

@interface OSSViewController (){
    NSMutableArray *percentList;
    UITableView *_tableFiles;
    VODUploadClient *uploader;
    NSInteger pos;
}

@end

@implementation OSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
    percentList = [[NSMutableArray alloc] init];
    
    // uploader
    uploader = [VODUploadClient new];
    
    // weak items
    __weak UITableView *weakTable = _tableFiles;
    __weak VODUploadClient *weakClient = uploader;
    __weak NSMutableArray *weakList = percentList;
    
    // callback functions and listener
    OnUploadFinishedListener testFinishCallbackFunc = ^(UploadFileInfo* fileInfo,  VodUploadResult* result){
        NSLog(@"%@", [NSString stringWithFormat:@"upload success! %@", fileInfo.filePath]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [weakTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    
    OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString* message){
        NSLog(@"failed code = %@, error message = %@", code, message);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [weakTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    
    OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        NSLog(@"progress uploadedSize : %li, totalSize : %li", uploadedSize, totalSize);
        UploadFileInfo* info;
        int i = 0;
        for(; i<[[weakClient listFiles] count]; i++) {
            info = [[weakClient listFiles] objectAtIndex:i];
            if (info == fileInfo) {
                break;
            }
        }
        if (nil == info) {
            return;
        }
        
        [weakList setObject:[NSString stringWithFormat:@"%ld", uploadedSize*100/totalSize] atIndexedSubscript:i];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [weakTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    
    OnUploadTokenExpiredListener testTokenExpiredCallbackFunc = ^{
        NSLog(@"token expired.");
        // 通过服务端接口请求新的sts
        [weakClient resumeWithToken:@"new key id" accessKeySecret:@"new key secret" secretToken:@"new token" expireTime:@"new expire time"];
    };
    
    OnUploadRertyListener testRetryCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    OnUploadRertyResumeListener testRetryResumeCallbackFunc = ^{
        NSLog(@"manager: retry begin.");
    };
    
    OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"upload started .");
    };
    
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.finish = testFinishCallbackFunc;
    listener.failure = testFailedCallbackFunc;
    listener.progress = testProgressCallbackFunc;
    listener.expire = testTokenExpiredCallbackFunc;
    listener.retry = testRetryCallbackFunc;
    listener.retryResume = testRetryResumeCallbackFunc;
    listener.started = testUploadStartedCallbackFunc;
    // TEST
    [self getTestSTSEndpointBucketObjectWithFinishHandler:^{
        [uploader init:ossAccessKeyId accessKeySecret:ossAccessKeySecret secretToken:ossSecretToken expireTime:ossExpireTime listener:listener];
    }];
}

- (BOOL)checkSTS {
    if (!ossAccessKeyId.length || !ossAccessKeySecret.length ||
        !ossSecretToken.length  || !ossBucketName.length ||
        !ossEndPoint.length || !ossExpireTime.length) {
        return NO;
    }
    return YES;
}

#pragma mark - action

- (IBAction)addFile:(id)sender {
    NSLog(@"addFile clicked.");
    if (![self checkSTS]) {
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"缺少参数" message:@"请指定STS凭证,Bucket,Endpoint" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
       [alertView show];
        return;
    }
    
//    NSString *name = [NSString stringWithFormat:@"%ld.demo.ios.mp4", pos];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];

    VodInfo *vodInfo = [[VodInfo alloc] init];
    vodInfo.title = [NSString stringWithFormat:@"IOS标题%ld", pos];
    vodInfo.desc = [NSString stringWithFormat:@"IOS描述%ld", pos];
    vodInfo.cateId = @(19);
    vodInfo.coverUrl = [NSString stringWithFormat:@"https://www.taobao.com/IOS封面URL%ld", pos];
    vodInfo.tags = [NSString stringWithFormat:@"IOS标签1%ld, IOS标签2%ld", pos, pos];
    NSString *ossObject = [NSString stringWithFormat:@"%@%ld.ios.demo.mp4",ossPrefix,pos];
    [uploader addFile:filePath endpoint:ossEndPoint bucket:ossBucketName object:ossObject vodInfo:vodInfo];
//    [uploader addFile:filePath endpoint:ossEndPoint bucket:ossBucketName object:ossObject];
    
    [percentList addObject:[NSString stringWithFormat:@"%d", 0]];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    pos++;
}

- (IBAction)deleteFile:(id)sender {
    NSLog(@"deleteFile clicked.");
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    NSInteger index = [uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader deleteFile:(int)index];
    NSLog(@"Delete file: %@", fileName);
    if (percentList.count > 0) {
        [percentList removeObjectAtIndex:percentList.count - 1];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)cancelFile:(id)sender {
    NSLog(@"cancelFile clicked.");
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    NSInteger index = [uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader cancelFile:(int)index];
    NSLog(@"cancelFile file: %@", fileName);
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)resumeFile:(id)sender {
    NSLog(@"resumeFile clicked.");
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    NSInteger index = [uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader resumeFile:(int)index];
    NSLog(@"resumeFile file: %@", fileName);
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)getList:(id)sender {
    NSLog(@"getList clicked.");
    [uploader listFiles];
}

- (IBAction)clearList:(id)sender {
    NSLog(@"clearList clicked.");
    [uploader clearFiles];
    [percentList removeAllObjects];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)startUpload:(id)sender {
    NSLog(@"startUpload clicked.");
    [uploader start];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)stopUpload:(id)sender {
    NSLog(@"stopUpload clicked");
    [uploader stop];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)pauseUpload:(id)sender {
    NSLog(@"pauseUpload clicked");
    [uploader pause];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)resumeUpload:(id)sender {
    NSLog(@"resumeUpload clicked");
    [uploader resume];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableFiles reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - setup view

- (void)setupSubviews {
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 180, 44)];
        label.textColor = [UIColor blackColor];
        label.text = @"文件管理";
        [self.view addSubview:label];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(40, 110, 44, 44);
        [button setTitle:@"添加" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addFile:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 110, 44, 44);
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteFile:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(160, 110, 44, 44);
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelFile:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(220, 110, 44, 44);
        [button setTitle:@"恢复" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(resumeFile:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 160, 180, 44)];
        label.textColor = [UIColor blackColor];
        label.text = @"列表管理";
        [self.view addSubview:label];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(40, 210, 44, 44);
        [button setTitle:@"获取" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 210, 44, 44);
        [button setTitle:@"清除" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearList:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 260, 180, 44)];
        label.textColor = [UIColor blackColor];
        label.text = @"上传管理";
        [self.view addSubview:label];
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(40, 310, 44, 44);
        [button setTitle:@"开始" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(startUpload:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 310, 44, 44);
        [button setTitle:@"停止" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stopUpload:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(160, 310, 44, 44);
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pauseUpload:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(240, 310, 44, 44);
        [button setTitle:@"恢复" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(resumeUpload:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    _tableFiles = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.view.frame), 260)];
    _tableFiles.delegate = self;
    _tableFiles.dataSource = self;
    [self.view addSubview:_tableFiles];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray<UploadFileInfo *> * list = [uploader listFiles];
    
    return [list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray<UploadFileInfo *> * list = [uploader listFiles];
    UploadFileInfo *info = [list objectAtIndex:(long)indexPath.row];
    NSString * cellID = [NSString stringWithFormat:@"cell_sec_%ld", (long)indexPath.section ];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[info.filePath substringFromIndex:info.filePath.length - 14], [self convertToString:info.state]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%% %@", [percentList objectAtIndex:(long)indexPath.row], info.object];
    
    return cell;
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

- (void)getTestSTSEndpointBucketObjectWithFinishHandler:(void(^)())handler {
    [DemoApi requestOSSSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSString *prefix, NSString *endpoint, NSString *bucket, NSError *error) {
        if (!error) {
            ossAccessKeyId = keyId;
            ossAccessKeySecret = keySecret;
            ossSecretToken = token;
            ossExpireTime = expireTime;
            ossEndPoint = endpoint;
            ossBucketName = bucket;
            ossPrefix = prefix;
            handler();
        }
    }];
}

@end
