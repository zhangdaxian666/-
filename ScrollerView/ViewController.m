//
//  ViewController.m
//  ScrollerView
//
//  Created by slcf888 on 2017/12/15.
//  Copyright © 2017年 slcf888. All rights reserved.
//

#import "ViewController.h"
#import "BillboardrView.h"
#import "VideoController.h"

#import "LocationController.h"

@interface ViewController ()<BillboardrViewDelegate>

@property (nonatomic, strong)BillboardrView *billboarderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imageArray = @[
                            [YYImage imageNamed:@"3.jpg"],
                            @"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif",
                            //使用本地gif图片的时候。需要调用这个方法
                            [YYImage imageNamed:@"2.gif"],
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510747412310&di=308b1b2e2d6ccb6a35796275fc185eaf&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f90e593a4ad4a8012193a3dcf03d.gif"
                            ];
    NSArray *descArray =@[@"本地",@"网络",@"本地GIF",@"网络gif"];
    
    //  广告栏
    _billboarderView =[[BillboardrView alloc]initBillboadrViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) andImageArray:imageArray andDescArray:descArray andplaceholdImage:[UIImage imageNamed:@"KNBilboardDefalutImge.png"]];
    // 设置代理
    _billboarderView.delegate =self;
    _billboarderView.pageControllPosition =PositionBottomLeft;
    [_billboarderView setPageimage:[UIImage imageNamed:@"4"] andCurrentPageImage:[UIImage imageNamed:@"5"]];
    _billboarderView.time =5.f;
    //设置滑动时gif停止播放
    _billboarderView.gifPlayMode =GifPlayModePauseWhenScroll;
    [self.view addSubview:_billboarderView];
    
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 450, self.view.frame.size.width, 100);
    btn.backgroundColor =[UIColor greenColor];
    [btn setTitle:@"播放器" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(qiehuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)qiehuan
{
    VideoController *vc =[[VideoController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)BillboardrView:(BillboardrView *)BillboadrView ClickImageForIndex:(NSInteger)index
{
    NSLog(@"xxxxx");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    LocationController *vc =[[LocationController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
