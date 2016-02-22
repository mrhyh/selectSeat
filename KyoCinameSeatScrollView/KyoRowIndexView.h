//
//  KyoRowIndexView.h
//  test
//
//  Created by Kyo on 30/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//  座位号左边行号提示

#import <UIKit/UIKit.h>
#import "KyoCinameSeatScrollView.h"

@interface KyoRowIndexView : UIView

@property (nonatomic, assign) NSUInteger row;
@property (assign, nonatomic) CGFloat width;
@property (weak, nonatomic) UIColor *rowIndexViewColor;
@property (assign, nonatomic) KyoCinameSeatRowIndexType rowIndexType;
@property (strong, nonatomic) NSArray *arrayRowIndex; //座位号左边行号提示（用它则忽略rowindextype）

@end
