//
//  MainViewController.m
//  VODUploadDemo
//
//  Created by Worthy on 2018/1/5.
//

#import "AlivcUploadMainViewController.h"
#import "STSViewController.h"
#import "OSSViewController.h"
#import "AuthAddressViewController.h"

@interface AlivcUploadMainViewController ()

@end

@implementation AlivcUploadMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self configBaseUI];
}

- (void)configBaseUI{
    UIButton *vodButton = [UIButton buttonWithType:UIButtonTypeSystem];;
    vodButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [vodButton setTitle:@"VOD列表上传(点播凭证方式)" forState:UIControlStateNormal];
    [vodButton addTarget:self action:@selector(vodAuthAddressUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: vodButton];
    vodButton.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2 - 32);
    
    UIButton *ossButton = [UIButton buttonWithType:UIButtonTypeSystem];;
    ossButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [ossButton setTitle:@"OSS列表上传(STS方式)" forState:UIControlStateNormal];
    [ossButton addTarget:self action:@selector(vodUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: ossButton];
    ossButton.center = CGPointMake(ScreenWidth / 2, vodButton.center.y - 66);
    
    UIButton *shortButton = [UIButton buttonWithType:UIButtonTypeSystem];;
    shortButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [shortButton setTitle:@"短视频场景上传(STS方式)" forState:UIControlStateNormal];
    [shortButton addTarget:self action:@selector(svideoUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: shortButton];
    shortButton.center = CGPointMake(ScreenWidth / 2, vodButton.center.y + 66);
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏设置
    self.navigationItem.title = @"视频上传";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (void)ossUpload:(id)sender {
    STSViewController *vc = [STSViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)vodAuthAddressUpload:(id)sender {
    AuthAddressViewController *vc = [AuthAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)vodUpload:(id)sender {
    STSViewController *vc = [STSViewController new];
    vc.type = UploadTypeVOD;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)svideoUpload:(id)sender {
    STSViewController *vc = [STSViewController new];
    vc.type = UploadTypeSVideo;
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)shouldAutorotate
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
