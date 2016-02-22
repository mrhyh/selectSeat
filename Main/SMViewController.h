//
//  SMViewController.h
//  CustomScrollView
//
//  Created by smnh on 3/29/14.
//  Copyright (c) 2014 smnh. All rights reserved.
//

#import "KyoRowIndexView.h"
#import "KyoCenterLineView.h"

@protocol SMCinameSeatScrollViewDelegate;
@interface SMViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) id<SMCinameSeatScrollViewDelegate> SMCinameSeatScrollViewDelegate;

@end

@protocol SMCinameSeatScrollViewDelegate <NSObject>

@optional
- (KyoCinameSeatState)kyoCinameSeatScrollViewSeatStateWithRow:(NSUInteger)row withColumn:(NSUInteger)column;
- (void)kyoCinameSeatScrollViewDidTouchInSeatWithRow:(NSUInteger)row withColumn:(NSUInteger)column;

@end