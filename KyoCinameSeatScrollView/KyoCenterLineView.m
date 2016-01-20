//
//  KyoCenterLineView.m
//  test
//
//  Created by Kyo on 30/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoCenterLineView.h"

#define kKyoCenterLineViewColor [UIColor redColor]

@implementation KyoCenterLineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);    //设置画笔为1像素
    CGContextSetStrokeColorWithColor(context, kKyoCenterLineViewColor.CGColor);   //设置画笔颜色
    CGFloat lengths[] = {6,3};  //绘制虚线的像素和间隙（4像素实线，2像素空白）  http://blog.csdn.net/zhangao0086/article/details/7234859
    CGContextSetLineDash(context, 0, lengths,2);  
    
    CGContextMoveToPoint(context, 0, 0);    //设置开始坐标
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);   //设置结束坐标
    CGContextStrokePath(context);   //开始画到画布上
}

@end
