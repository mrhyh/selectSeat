//
//  KyoScrollView.m
//  test
//
//  Created by Kyo on 29/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoCinameSeatScrollView.h"
#import "KyoRowIndexView.h"
#import "KyoCenterLineView.h"

#define kRowIndexWith   16.0
#define kRowIndexSpace  2.0
#define kRowIndexViewDefaultColor   [[UIColor blackColor] colorWithAlphaComponent:0.7]
#define kCenterLineViewTail 6.0

@interface KyoCinameSeatScrollView()

@property (weak, nonatomic) id scrollViewDelegate;  //用于存储delegate，防止野指针

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) KyoRowIndexView *rowIndexView;
@property (strong, nonatomic) KyoCenterLineView *centerLineView;

@property (strong, nonatomic) NSMutableDictionary *dictSeat;

- (void)btnSeatTouchIn:(UIButton *)btn;
- (void)addObserver;
- (void)removeObserver;

@end

@implementation KyoCinameSeatScrollView



#pragma mark --------------------
#pragma mark - CycLife

- (id)init {
    self = [super init];
    if (self) {
        [self addObserver];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver];
}

- (void)drawRect:(CGRect)rect {
    //计算并设置contentsize
    self.contentSize = CGSizeMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) * self.zoomScale,(self.seatTop + self.row * self.seatSize.height + self.seatBottom) * self.zoomScale);
    
//    if (!self.contentView) {
//        self.contentView = [[UIView alloc] init];
//        self.contentView.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.contentView];
//    } else {
//        self.contentView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
//    }
    
    if (!self.contentView) {
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
    }
    self.contentView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    //画座位
    if (!self.dictSeat) self.dictSeat = [NSMutableDictionary dictionary];
    
    CGFloat x = self.seatLeft + (self.showRowIndex ? kRowIndexSpace * 2 : 0);
    CGFloat y = self.seatTop;
    for (NSInteger row = 0; row < self.row; row++) {
        
        NSMutableArray *arraySeat = self.dictSeat[@(row)] ? : [NSMutableArray array];
        
        for (NSInteger column = 0; column < self.column; column++) {
            
            UIButton *btnSeat = nil;
            if (arraySeat.count <= column) {
                btnSeat = [UIButton buttonWithType:UIButtonTypeCustom];
                btnSeat.tag = row;  //tag纪录行数
                [btnSeat addTarget:self action:@selector(btnSeatTouchIn:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:btnSeat];
                //[self addSubview:btnSeat];
                [arraySeat addObject:btnSeat];
            } else {
                btnSeat = arraySeat[column];
            }
            
            btnSeat.frame = CGRectMake(x, y, self.seatSize.width, self.seatSize.height);
            if (self.kyoCinameSeatScrollViewDelegate &&
                [self.kyoCinameSeatScrollViewDelegate respondsToSelector:@selector(kyoCinameSeatScrollViewSeatStateWithRow:withColumn:)]) {
                
                KyoCinameSeatState state = [self.kyoCinameSeatScrollViewDelegate kyoCinameSeatScrollViewSeatStateWithRow:row withColumn:column];
                
                [btnSeat setImage:[self getSeatImageWithState:state] forState:UIControlStateNormal];
            } else {
                [btnSeat setImage:self.imgSeatNormal forState:UIControlStateNormal];
            }
            
            x += self.seatSize.width;
        }
        
        y += self.seatSize.height;
        x = self.seatLeft + (self.showRowIndex ? kRowIndexSpace * 2 : 0);
        
        [self.dictSeat setObject:arraySeat forKey:@(row)];
    }
    
    
    //画座位行数提示
    if (!self.rowIndexView) {
        self.rowIndexView = [[KyoRowIndexView alloc] init];
        self.rowIndexView.backgroundColor = self.rowIndexViewColor ? : kRowIndexViewDefaultColor;
        [self.contentView addSubview:self.rowIndexView];
        //[self addSubview:self.rowIndexView];
    }
    if (self.showRowIndex) {
        [self.contentView bringSubviewToFront:self.rowIndexView];
        self.rowIndexView.row = self.row;
        self.rowIndexView.width = kRowIndexWith;
        self.rowIndexView.rowIndexViewColor = self.rowIndexViewColor;
        self.rowIndexView.frame = CGRectMake((kRowIndexSpace + (self.rowIndexStick ? self.contentOffset.x : 0)) / self.zoomScale, self.seatTop, kRowIndexWith, self.row * self.seatSize.height);
        self.rowIndexView.rowIndexType = self.rowIndexType;
        self.rowIndexView.arrayRowIndex = self.arrayRowIndex;
        self.rowIndexView.hidden = NO;
    } else {
        self.rowIndexView.hidden = YES;
    }
    
    //画中线
    if (!self.centerLineView) {
        self.centerLineView = [[KyoCenterLineView alloc] init];
        self.centerLineView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.centerLineView];
    }
    if (self.showCenterLine) {
        [self.contentView bringSubviewToFront:self.centerLineView];
        if (self.showRowIndex) {
            self.centerLineView.frame = CGRectMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) / 2 + kRowIndexSpace * 2, self.seatTop - kCenterLineViewTail, 1, self.row * self.seatSize.height + kCenterLineViewTail * 2);
        } else {
            self.centerLineView.frame = CGRectMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) / 2, self.seatTop - kCenterLineViewTail, 1, self.row * self.seatSize.height + kCenterLineViewTail * 2);
        }
        
        if (self.row > 0 && self.column > 0) {
            self.centerLineView.hidden = NO;
        } else {
            self.centerLineView.hidden = YES;
        }
    } else {
        self.centerLineView.hidden = YES;
    }
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    
    if (self.rowIndexView) {
        [self.rowIndexView setNeedsDisplay];
    }
    
    if (self.centerLineView) {
        [self.centerLineView setNeedsDisplay];
    }
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    [super setDelegate:delegate];
    self.scrollViewDelegate = delegate;
}

#pragma mark --------------------
#pragma mark - Events

- (void)btnSeatTouchIn:(UIButton *)btn {
    
    NSLog(@"btnSeatTouchIn-btn.tag=%ld",(long)btn.tag);
    if (self.kyoCinameSeatScrollViewDelegate &&
        [self.kyoCinameSeatScrollViewDelegate respondsToSelector:@selector(kyoCinameSeatScrollViewDidTouchInSeatWithRow:withColumn:)]) {
        
        NSArray *arraySeat = self.dictSeat[@(btn.tag)];
        NSUInteger column = [arraySeat indexOfObject:btn];
        [self.kyoCinameSeatScrollViewDelegate kyoCinameSeatScrollViewDidTouchInSeatWithRow:btn.tag withColumn:column];
        
        [self setNeedsDisplay];
        
    }
    
}

#pragma mark --------------------
#pragma mark - Methods

- (UIImage *)getSeatImageWithState:(KyoCinameSeatState)state {
    if (state == KyoCinameSeatStateHadBuy) {
        return self.imgSeatHadBuy;
    } else if (state == KyoCinameSeatStateNormal) {
        return self.imgSeatNormal;
    } else if (state == KyoCinameSeatStateSelected) {
        return self.imgSeatSelected;
    } else if (state == KyoCinameSeatStateUnexist) {
        return self.imgSeatUnexist;
    } else if (state == KyoCinameSeatStateLoversLeftNormal) {
        return self.imgSeatLoversLeftNormal;
    } else if (state == KyoCinameSeatStateLoversLeftHadBuy) {
        return self.imgSeatLoversLeftHadBuy;
    } else if (state == KyoCinameSeatStateLoversLeftSelected) {
        return self.imgSeatLoversLeftSelected;
    } else if (state == KyoCinameSeatStateLoversRightNormal) {
        return self.imgSeatLoversRightNormal;
    } else if (state == KyoCinameSeatStateLoversRightHadBuy) {
        return self.imgSeatLoversRightHadBuy;
    } else if (state == KyoCinameSeatStateLoversRightSelected) {
        return self.imgSeatLoversRightSelected;
    } else {
        return self.imgSeatNormal;
    }
}

- (void)addObserver {
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

//显示中心位置
- (void)displaySeatCenter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat offerX = self.contentSize.width / 2  - self.bounds.size.width / 2;
        offerX += (self.seatLeft - self.seatRight) / 2;
        if (self.showRowIndex) {
            offerX += kRowIndexSpace * 2;
        }
        if (offerX < 0 && self.contentInset.left < fabs(offerX)) {
            self.contentInset = UIEdgeInsetsMake(self.contentInset.top, fabs(offerX), self.contentInset.bottom, self.contentInset.right);
        } else {
            [self setContentOffset:CGPointMake(offerX, 0) animated:YES];
        }
    });
}

//返回缩小放大的view
- (UIView *)getZoomView {
    return self.contentView;
}

//返回左边现实row的视图
- (UIView *)getRowIndexView {
    return self.rowIndexView;
}

#pragma mark --------------------
#pragma mark - KVC/KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat zoomScale = self.scrollViewDelegate ? self.zoomScale : 1;   //判断一下是否为空，防止直接调用self.zoomSalce导致的野指针(delegate为野指针)
    if (self.rowIndexStick && self.rowIndexView && self.row > 0 && self.column > 0) {
        
        self.rowIndexView.frame = CGRectMake((kRowIndexSpace + (self.rowIndexStick ? self.contentOffset.x : 0)) / zoomScale, self.seatTop, kRowIndexWith, self.row * self.seatSize.height);
    }
    //[self getZoomView];
}


@end
