//
//  BillboardrView.m
//  ScrollerView
//
//  Created by slcf888 on 2017/12/15.
//  Copyright © 2017年 slcf888. All rights reserved.
//

#import "BillboardrView.h"
#import "NSTimer+KNTimer.h"
#import <ImageIO/ImageIO.h>
#define DEFAULTTIME 3
#define DEFAULTPOTINT 10
#define VERMARGIN 5
#define DEFAULTHEIGT 20
@interface BillboardrView()<UIScrollViewDelegate>

@property(nonatomic, strong)UILabel *descLable;
@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, strong)NSMutableArray *images;
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)UIImageView *currImageView;
@property(nonatomic, strong)UIImageView *otherImageView;
@property(nonatomic, assign)NSInteger currIndex;
@property(nonatomic, assign)NSInteger nextIndex;
@property(nonatomic, assign)CGSize pageImageSize;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSOperationQueue *queue;
@property(nonatomic, strong)UIImage *placeholdImage;

@end
static NSString *cache;

@implementation BillboardrView
//缓存图片的文件夹
+(void)initialize
{
    cache =[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"KNCarousel"];
    BOOL isDir = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cache isDirectory:&isDir];
    if (!isExists || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (instancetype)initBillboadrViewWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray andDescArray:(NSArray *)descArray andplaceholdImage:(UIImage *)placeholdImage
{
    self =[super initWithFrame:frame];
    if (self) {
        self.placeholdImage =placeholdImage? :[UIImage new];
        self.imageArray = imageArray;
        self.titles =descArray.count >0?[NSMutableArray arrayWithArray:descArray]:nil;
        
        [self initView];
    }
    return self;
}
- (void)initView{
    self.autoCache =YES;
    [self addSubview:self.scrollView];
    [self addSubview:self.descLable];
    [self addSubview:self.pageControl];
    [self setImageForArray];//设置图片
    [self setDescribe];//设置标题
}
- (CGFloat)height{
    return self.scrollView.frame.size.height;
}
- (CGFloat)width{
    return self.scrollView.frame.size.width;
}
#pragma 布控子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.contentInset =UIEdgeInsetsZero;
    self.scrollView.frame =self.bounds;
    self.descLable.frame =CGRectMake(0,self.height-DEFAULTHEIGT, self.width, DEFAULTHEIGT);
    self.pageControllPosition =_pageControllPosition;
    
    [self setScrollViewContentSize];//设置scrollerview的位置
}
//设置图片数组
- (void)setImageForArray
{
    if (!self.imageArray.count) {
        return;
    }
    for (int i=0; i<self.imageArray.count; i++) {
        if ([self.imageArray[i] isKindOfClass:[UIImage class]]) {
            [self.images addObject:self.imageArray[i]];
        }else if ([self.imageArray[i] isKindOfClass:[NSString class]]){
            //若是网络图片添加占位图，下载后替换掉
            [self.images addObject:self.placeholdImage];
//            [self downloadImages:i];//下载图片
        }
    }
    if (_currIndex>=self.images.count) {
        _currIndex =self.images.count-1;
    }
    self.currImageView.image =self.images[_currIndex];
    self.pageControl.numberOfPages =self.images.count;
    [self layoutSubviews];
}
//设置描述
- (void)setDescribe
{
    if (!self.titles.count) {
        self.titles =nil;
        self.descLable.hidden =YES;
    }else{
        if (self.titles.count<self.imageArray.count) {
            NSMutableArray *describes =[NSMutableArray arrayWithArray:self.titles];
            for (NSInteger i=self.titles.count; i<self.imageArray.count; i++) {
                [describes addObject:@""];
            }
            self.titles =describes;
        }
        self.descLable.hidden =NO;
        self.descLable.text =self.titles[_currIndex];
    }
    //重新复制
    self.pageControllPosition =_pageControllPosition;
}

#pragma 设置pageControl的位置
- (void)setPageControllPosition:(PageControllPosion)pageControllPosition
{
    _pageControllPosition =pageControllPosition;
    //设置隐藏模式
    _pageControl.hidden =(_pageControllPosition ==PositionHide)||(self.images.count ==1);
    if (_pageControl.hidden) {
        return;
    }
    
    CGSize size;
    if (!_pageImageSize.width) { //没有设置图片
        size =[_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        size.height =8;
    }else{ //设置图片
        size =CGSizeMake(_pageImageSize.width*(_pageControl.numberOfPages*2.5), _pageImageSize.height);
    }
    _pageControl.frame =CGRectMake(0, 0, size.width, size.height);
    
    CGFloat centerY =self.height -size.height*0.5-VERMARGIN -(self.descLable.hidden? 0:DEFAULTHEIGT);
    CGFloat pointY =self.height -size.height -VERMARGIN -(self.descLable.hidden? 0:DEFAULTHEIGT);
    if (_pageControllPosition ==PositionDefalut || _pageControllPosition ==PostionBottomCenter) {
        _pageControl.center =CGPointMake(self.width/2, centerY);
    }else if (_pageControllPosition == PositionBottomLeft){
        _pageControl.frame =CGRectMake(DEFAULTPOTINT, pointY, size.width, size.height);
    }else{
        _pageControl.frame =CGRectMake(self.width -DEFAULTPOTINT -size.width, pointY, size.width, size.height);
    }
    if (!CGPointEqualToPoint(_pageOffset, CGPointZero)) {
        self.pageOffset =_pageOffset;
    }
}

#pragma ---设置scrollerview的contentsize---
- (void)setScrollViewContentSize
{
    if (self.images.count >1) {
        self.scrollView.contentSize =CGSizeMake(self.width *5, 0);
        self.scrollView.contentOffset =CGPointMake(self.width *2, 0);
        self.currImageView.frame =CGRectMake(self.width *2, 0, self.width, self.height);
        //淡入淡出模式
        if (_changeMode ==ChangeModeFade) {
            _currImageView.frame =CGRectMake(0, 0, self.width, self.height);
            _otherImageView.frame =self.currImageView.frame;
            _otherImageView.alpha =0;
            [self insertSubview:self.currImageView atIndex:0];
            [self insertSubview:self.otherImageView atIndex:1];
        }
        [self startTimer];
    }else{
        //一张图片时，scrollerview不可滚动且关闭定时器
        self.scrollView.contentSize =CGSizeZero;
        self.scrollView.contentOffset =CGPointZero;
        self.currImageView.frame =CGRectMake(0, 0, self.width, self.height);
        [self stopTimer];
    }
}

#pragma 图片滚动过半时就修改当前页码
- (void)changeCurrentPageWithOffset:(CGFloat)offsetX
{
    if (offsetX <self.width *1.5) {
        NSInteger index =self.currIndex -1;
        if (index <0) {
            index =self.images.count -1;
            _pageControl.currentPage =index;
        }
    }else if (offsetX >self.width *2.5){
        _pageControl.currentPage =(self.currIndex +1) % self.images.count;
    }else{
        _pageControl.currentPage =self.currIndex;
    }
}
#pragma 切换图片
- (void)changeToNext
{
    if (_changeMode == ChangeModeFade) {
        self.currImageView.alpha =1;
        self.otherImageView.alpha =0;
    }
    //切换
    self.currImageView.image =self.otherImageView.image;
    self.scrollView.contentOffset =CGPointMake(self.width *2, 0);
    [self.scrollView layoutSubviews];
    self.currIndex =self.nextIndex;
    self.pageControl.currentPage =self.nextIndex;
    self.descLable.text =self.titles[self.currIndex];
}

#pragma -----UIScrollerViewDelegate-----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (CGSizeEqualToSize(CGSizeZero, scrollView.contentSize)) {
        return;
    }
    CGFloat offsetX =scrollView.contentOffset.x;
    //判断gif的动画方式
    if (_gifPlayMode ==GifPlayModePauseWhenScroll) {
        [self gifAnimatig:(offsetX ==self.width *2)];
    }
    //滚动过程，改变当前页码
    [self changeCurrentPageWithOffset:offsetX];
    //判断向右滚动
    if (offsetX <self.width *2) {
        if (_changeMode ==ChangeModeFade) {
            self.currImageView.alpha =offsetX /self.width -1;
            self.otherImageView.alpha =2 -offsetX /self.width;
        }else{
            self.otherImageView.frame =CGRectMake(self.width, 0, self.width, self.height);
        }
        self.nextIndex =self.currIndex -1;
        if (self.nextIndex <0)self.nextIndex =self.images.count -1;
        self.otherImageView.image =self.images[self.nextIndex];
        if (offsetX <=self.width) {
            [self changeToNext];
        }
    }else if (offsetX >self.width *2){
        if (_changeMode == ChangeModeFade) {
            self.otherImageView.alpha =offsetX /self.width -2;
            self.currImageView.alpha =3 -offsetX /self.width;
        }else{
            self.otherImageView.frame =CGRectMake(CGRectGetMaxX(_currImageView.frame), 0, self.width, self.height);
        }
        self.nextIndex =(self.currIndex +1) % self.images.count;
        self.otherImageView.image =self.images[self.nextIndex];
        if (offsetX >=self.width *3) {
            [self changeToNext];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
// 修复滚动过快导致分页异常
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_changeMode == ChangeModeFade) {
        return;
    }
    CGPoint currPointInSelf =[_scrollView convertPoint:_currImageView.frame.origin toView:self];
    if (currPointInSelf.x >= -self.width /2 && currPointInSelf.x <= self.width /2) {
        [self.scrollView setContentOffset:CGPointMake(self.width *2, 0) animated:YES];
    }else{
        [self changeToNext];
    }
}
//  下一页
- (void)nextPage{
    if (_changeMode == ChangeModeFade) {
        self.nextIndex = (self.currIndex +1) % self.images.count;
        self.otherImageView.image =self.images[self.nextIndex];
        [UIView animateWithDuration:1.2 animations:^{
            self.currImageView.alpha =0;
            self.otherImageView.alpha =1;
            self.pageControl.currentPage =_nextIndex;
        } completion:^(BOOL finished) {
            [self changeToNext];
        }];
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.width *3, 0) animated:YES];
    }
}
- (void)startTimer
{
    if (self.imageArray.count <=1) return;
    if (self.timer) [self stopTimer]; //定时器开启，先停止再重新开启
    __weak typeof (self)weakSelf = self;
    self.timer =[NSTimer kn_TimerWithTimeInterval:_time <1 ? DEFAULTTIME:_time repeats:YES block:^(NSTimer *timer) {
        [weakSelf nextPage];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
// --------------下载网络图片
- (void)downloadImages:(int)index{
    NSString *urlString =self.imageArray[index];
    NSString *imageName =[urlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *path =[cache stringByAppendingPathComponent:imageName];
    //判断开启缓存，从沙盒取图片
    if (_autoCache) {
        NSData *data =[NSData dataWithContentsOfFile:path];
        if (data) {
            _images[index] =[YYImage imageWithData:data];
            return;
        }
    }
    //下载
    NSBlockOperation *doenload =[NSBlockOperation blockOperationWithBlock:^{
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (!data) return ;
        UIImage *image =[YYImage imageWithData:data];
        if (image) {       //  判断
            self.images[index] =image;
            //
            if (_currIndex == index) {
                [self.currImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            }
            if (_autoCache) {  //  若是开启缓存则写入文件夹
                [data writeToFile:path atomically:YES];
            }
        }
    }];
    [self.queue addOperation:doenload];   //加入队列
}
#pragma ----清除沙盒中的图片缓存----
+ (void)clearDiskCache
{
    NSArray *contents =[[NSFileManager defaultManager] contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *fileName in contents) {
        [[NSFileManager defaultManager] removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:nil];
    }
}
#pragma 设置定时器时间
- (void)setTime:(NSTimeInterval)time
{
    _time =time;
    [self startTimer];
}
- (void)stopTimer
{
    [self.timer invalidate];   // 清除
    self.timer =nil;
}
#pragma 图片点击事件
- (void)imageClick
{
    ([_delegate respondsToSelector:@selector(BillboardrView:ClickImageForIndex:)]);
    [_delegate BillboardrView:self ClickImageForIndex:self.currIndex];
}
- (void)gifAnimatig:(BOOL)b
{
    [self gifAnimating:b view:self.currImageView];
    [self gifAnimating:b view:self.otherImageView];
}
- (void)gifAnimating:(BOOL)isPlay view:(UIImageView *)imageV
{
    if (isPlay) {   // 定时器
        CFTimeInterval pausedTime =[imageV.layer timeOffset];
        imageV.layer.speed =1.0;
        imageV.layer.timeOffset =0.0;
        imageV.layer.beginTime =0.0;
        CFTimeInterval timeSincePause =[imageV.layer convertTime:CACurrentMediaTime() fromLayer:nil] -pausedTime;
        imageV.layer.beginTime =timeSincePause;
    }else{
        CFTimeInterval pausedTime =[imageV.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        imageV.layer.speed =0.0;
        imageV.layer.timeOffset =pausedTime;
    }
}

- (void)setGifPlayMode:(GifPlayMode)gifPlayMode
{
    if (_changeMode == ChangeModeFade) return;
    _gifPlayMode = gifPlayMode;
    
    if (gifPlayMode == GifPlayModeAlways) {
        [self gifAnimatig:YES];
    }else if (gifPlayMode == GifPlayModeNever){
        [self gifAnimatig:NO];
    }
}
- (void)setDescLableFont:(UIFont *)descLableFont
{
    _descLableFont =descLableFont;
    self.descLable.font =descLableFont;
}
- (void)setDescLableColor:(UIColor *)descLableColor
{
    _descLableColor =descLableColor;
    self.descLable.textColor =descLableColor;
}
- (void)setDescLableBackgroundColor:(UIColor *)descLableBackgroundColor
{
    _descLableBackgroundColor =descLableBackgroundColor;
    self.descLable.backgroundColor =descLableBackgroundColor;
}

#pragma 设置pagecontrol的指示器图片
- (void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor
{
    self.pageControl.pageIndicatorTintColor =color;
    self.pageControl.currentPageIndicatorTintColor =currentColor;
}
- (void)setPageimage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage
{
    if (!image || !currentImage) return;
    self.pageImageSize =image.size;
    [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [self.pageControl setValue:image forKey:@"_pageImage"];
}
- (void)setChangeMode:(ChangeMode)changeMode
{
    _changeMode =changeMode;
    if (changeMode == ChangeModeFade) {
        _gifPlayMode =GifPlayModeAlways;
    }
}
- (void)setPageOffset:(CGPoint)pageOffset
{
    _pageOffset =pageOffset;
    CGRect frame =_pageControl.frame;
    frame.origin.x += pageOffset.x;
    frame.origin.y += pageOffset.y;
    _pageControl.frame = frame;
}

#pragma 懒加载
- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue =[[NSOperationQueue alloc]init];
    }
    return _queue;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =[[UIScrollView alloc]init];
        _scrollView.scrollsToTop =NO;
        _scrollView.pagingEnabled =YES;
        _scrollView.bounces =NO;
        _scrollView.showsVerticalScrollIndicator =NO;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.delegate =self;
        UITapGestureRecognizer *imageClick =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
        [_scrollView addGestureRecognizer:imageClick];
        [_scrollView addSubview:self.currImageView];
        [_scrollView addSubview:self.otherImageView];
    }
    return _scrollView;
}
- (UIImageView *)currImageView
{
    if (!_currImageView) {
        _currImageView =[[YYAnimatedImageView alloc]init];
        _currImageView.clipsToBounds =YES;
    }
    return _currImageView;
}
- (UIImageView *)otherImageView
{
    if (!_otherImageView) {
        _otherImageView =[[YYAnimatedImageView alloc]init];
        _otherImageView.clipsToBounds =YES;
    }
    return _otherImageView;
}
- (UILabel *)descLable
{
    if (!_descLable) {
        _descLable =[[UILabel alloc]init];
        _descLable.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        _descLable.textColor =[UIColor whiteColor];
        _descLable.textAlignment =NSTextAlignmentCenter;
        _descLable.font =[UIFont systemFontOfSize:13];
        _descLable.hidden =YES;
    }
    return _descLable;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl =[[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled =YES;
    }
    return _pageControl;
}
- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray =[NSArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)images
{
    if (!_images) {
        _images =[NSMutableArray array];
    }
    return _images;
}
/*http://www.jianshu.com/p/79836f12045c 各种定时器
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
