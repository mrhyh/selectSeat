//
//  KyoScrollView.h
//  test
//
//  Created by Kyo on 29/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KyoCinameSeatStateNormal = 0,    //正常
    KyoCinameSeatStateHadBuy = 1,   //已被购买
    KyoCinameSeatStateSelected = 2, //已选择
    KyoCinameSeatStateUnexist = 3,   //不存在
    KyoCinameSeatStateLoversLeftNormal = 4, //情侣左正常
    KyoCinameSeatStateLoversLeftHadBuy = 5, //情侣左已被购买
    KyoCinameSeatStateLoversLeftSelected = 6, //情侣左已选择
    KyoCinameSeatStateLoversRightNormal = 7, //情侣右正常
    KyoCinameSeatStateLoversRightHadBuy = 8, //情侣右已被购买
    KyoCinameSeatStateLoversRightSelected = 9 //情侣右已选择
} KyoCinameSeatState;   //座位状态

typedef enum : NSInteger {
    KyoCinameSeatRowIndexTypeNumber = 0,    //默认，显示数字
    KyoCinameSeatRowIndexTypeLetter = 1,    //显示字母
}KyoCinameSeatRowIndexType; //座位左边行号提示样式

@protocol KyoCinameSeatScrollViewDelegate;

IB_DESIGNABLE

@interface KyoCinameSeatScrollView : UIScrollView

@property (weak, nonatomic) IBOutlet id<KyoCinameSeatScrollViewDelegate> kyoCinameSeatScrollViewDelegate;

@property (nonatomic, assign) IBInspectable NSUInteger row;
@property (nonatomic, assign) IBInspectable NSUInteger column;
@property (nonatomic, assign) IBInspectable CGSize seatSize;
@property (assign, nonatomic) IBInspectable CGFloat seatTop;
@property (assign, nonatomic) IBInspectable CGFloat seatLeft;
@property (assign, nonatomic) IBInspectable CGFloat seatBottom;
@property (assign, nonatomic) IBInspectable CGFloat seatRight;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatNormal;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatHadBuy;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatSelected;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatUnexist;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatLoversLeftNormal;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatLoversLeftHadBuy;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatLoversLeftSelected;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatLoversRightNormal;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatLoversRightHadBuy;
@property (strong, nonatomic) IBInspectable UIImage *imgSeatLoversRightSelected;

@property (assign, nonatomic) IBInspectable BOOL showCenterLine;
@property (assign, nonatomic) IBInspectable BOOL showRowIndex;
@property (assign, nonatomic) IBInspectable BOOL rowIndexStick;  /**< 是否让showIndexView粘着左边 */
@property (strong, nonatomic) IBInspectable UIColor *rowIndexViewColor;
@property (assign, nonatomic) IBInspectable NSInteger rowIndexType; //座位左边行号提示样式
@property (strong, nonatomic) IBInspectable NSArray *arrayRowIndex; //座位号左边行号提示（用它则忽略rowindextype）

//增加缩放功能
@property (nonatomic, assign) CGSize prevBoundsSize;
@property (nonatomic, assign) CGPoint prevContentOffset;
@property (nonatomic, strong, readwrite) UIView *viewForZooming;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *doubleTapGestureRecognizer;

- (void)displaySeatCenter;  //显示中心位置
- (UIView *)getZoomView;   //返回缩小放大的view
- (UIView *)getRowIndexView;   //返回左边现实row的视图

@end

@protocol KyoCinameSeatScrollViewDelegate <NSObject>

@optional
- (KyoCinameSeatState)kyoCinameSeatScrollViewSeatStateWithRow:(NSUInteger)row withColumn:(NSUInteger)column;
- (void)kyoCinameSeatScrollViewDidTouchInSeatWithRow:(NSUInteger)row withColumn:(NSUInteger)column;

@end
