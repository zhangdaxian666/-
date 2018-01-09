//
//  VideoController.m
//  ScrollerView
//
//  Created by slcf888 on 2017/12/19.
//  Copyright © 2017年 slcf888. All rights reserved.
//  http://www.jianshu.com/p/f0530a75c7af 加载gif

#import "VideoController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "GIFController.h"

@interface VideoController ()

@property (nonatomic, strong)AVPlayerViewController *AVPlayer;

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self setMoviePlayer];
    // Do any additional setup after loading the view.
}
- (void)setMoviePlayer
{
//    NSString *str = [[NSBundle mainBundle] resourcePath];
//    NSString *filePath = [NSString stringWithFormat:@"%@%@",str,@"/movie.mp4"];
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"movie.mp4" ofType:nil];
    NSURL *movieURL =[NSURL fileURLWithPath:filePath];
//    AVAsset *movie =[AVURLAsset URLAssetWithURL:movieURL options:nil];
    self.AVPlayer =[[AVPlayerViewController alloc]init];
    self.AVPlayer.allowsPictureInPicturePlayback =NO; //多分屏功能取消
    self.AVPlayer.showsPlaybackControls =false; //是否显示媒体播放组件
    
    AVPlayerItem *item =[[AVPlayerItem alloc]initWithURL:movieURL];
//    AVPlayerItem *item =[AVPlayerItem playerItemWithAsset:movie];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *layer =[AVPlayerLayer playerLayerWithPlayer:player];
//    [layer setFrame:[UIScreen mainScreen].bounds];
    [layer setFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    layer.videoGravity =AVLayerVideoGravityResizeAspect; //填充模式
    
    self.AVPlayer.player = player;
    [self.view.layer addSublayer:layer];
    [self.AVPlayer.player play];       // 开始播放
    
    // 设置重复播放
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    //  定时器
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(setupLoginView) userInfo:nil repeats:YES];
}

- (void)playDidEnd:(NSNotification *)Notification
{
    // 播放完成后，设置播放进度为0 。
    [self.AVPlayer.player seekToTime:CMTimeMake(0, 1)];
    [self.AVPlayer.player play];     // 开始播放
}
- (void)setupLoginView
{
    UIButton *enterMainButton =[[UIButton alloc]init];
    enterMainButton.frame =CGRectMake(24, [UIScreen mainScreen].bounds.size.height-32-48, [UIScreen mainScreen].bounds.size.width -48, 48);
    enterMainButton.layer.borderWidth =1;
    enterMainButton.layer.cornerRadius =24;
    enterMainButton.alpha =0;
    enterMainButton.backgroundColor =[UIColor greenColor];
    enterMainButton.layer.borderColor =[UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    [self.view addSubview:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        enterMainButton.alpha =1;
    }];
}

- (void)enterMainAction:(UIButton *)btn
{
    GIFController *vc =[[GIFController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
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
