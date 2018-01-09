//
//  GIFController.m
//  ScrollerView
//
//  Created by slcf888 on 2017/12/19.
//  Copyright © 2017年 slcf888. All rights reserved.
//

#import "GIFController.h"
#import <UIImage+GIF.h>

@interface GIFController ()

@end

@implementation GIFController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 288)];
//    [webView setCenter:self.view.center];
//    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"2" ofType:@"gif"]];
//    webView.userInteractionEnabled = NO;
//    [webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:nil];
//    //设置webview背景透明，能看到gif的透明层
//    webView.backgroundColor = [UIColor blackColor];
//    webView.opaque = NO;
//    [self.view addSubview:webView];
    
    UIWebView *webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 288)];
//    [webView setCenter:self.view.center];
    [self.view addSubview:webView];
    NSString *path =[[NSBundle mainBundle] pathForResource:@"2" ofType:@"gif"];
    NSURL *url =[NSURL URLWithString:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self loadUI];

    // Do any additional setup after loading the view.
}
- (void)loadUI
{
    NSURL *url =[NSURL URLWithString:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"];
    NSData *data =[NSData dataWithContentsOfURL:url];
    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(0, 370, self.view.frame.size.width, 180)];
    image.backgroundColor =[UIColor yellowColor];
    image.image =[UIImage sd_animatedGIFWithData:data];
    [self.view addSubview:image];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
