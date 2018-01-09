//
//  BillboardrView.h
//  ScrollerView
//
//  Created by slcf888 on 2017/12/15.
//  Copyright © 2017年 slcf888. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>

@class BillboardrView;
//pageControll的显示位置
typedef NS_ENUM(NSInteger,PageControllPosion) {
    PositionDefalut, //默认值
    PositionHide,    //隐藏控件
    PositionBottomLeft, //右下
    PostionbottomRtight, //左下
    PostionBottomCenter  //中下
};
//gif播放方式
typedef NS_ENUM(NSInteger, GifPlayMode) {
    GifPlayModeAlways,             //始终播放
    GifPlayModeNever,               //从不播放
    GifPlayModePauseWhenScroll      //切换图片时不播放
};
//图片切换方式
typedef NS_ENUM(NSInteger, ChangeMode) {
    ChangeModeDefault,     //轮播滚动
    ChangeModeFade         //淡入淡出
};

@protocol BillboardrViewDelegate <NSObject>     // 代理
- (void)BillboardrView:(BillboardrView *)BillboadrView ClickImageForIndex:(NSInteger)index;
@end

@interface BillboardrView : UIView
// 位置大小。图片数组。descArray描述数组可为空，为空不显示文字。默认图，网络没加载出用
- (instancetype)initBillboadrViewWithFrame:(CGRect )frame andImageArray:(NSArray *)imageArray andDescArray:(NSArray *)descArray andplaceholdImage:(UIImage *)placeholdImage;

//其他页码颜色 。 当前页面的颜色
- (void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor;

//其他页码图片 。 当前页码图片
- (void)setPageimage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage;

//打开定时器
- (void)startTimer;
//停止定时器
- (void)stopTimer;

//清理沙盒中图片缓存
+ (void)clearDiskCache;

@property (nonatomic, assign)ChangeMode changeMode;
@property (nonatomic, assign)UIViewContentMode contentMode;
@property (nonatomic, assign)PageControllPosion pageControllPosition;
@property (nonatomic, assign)GifPlayMode gifPlayMode;
@property (nonatomic, assign)CGPoint pageOffset;
@property (nonatomic, assign)NSTimeInterval time;
@property (nonatomic, strong)UIColor *descLableColor;
@property (nonatomic, strong)UIFont *descLableFont;
@property (nonatomic, strong)UIColor *descLableBackgroundColor;
@property (nonatomic, assign)BOOL autoCache;

@property (nonatomic, weak) id<BillboardrViewDelegate>delegate;

@end
