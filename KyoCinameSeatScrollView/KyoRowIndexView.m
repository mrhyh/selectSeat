//
//  KyoRowIndexView.m
//  test
//
//  Created by Kyo on 30/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoRowIndexView.h"
#import <CoreText/CoreText.h>

#define kKyoRowIndexViewFontName    @"Helvetica"
#define kKyoRowIndexViewFontSize    10
#define kKyoRowIndexViewColor    [UIColor whiteColor]

@implementation KyoRowIndexView

#pragma mark --------------------
#pragma mark - CycLife

- (void)drawRect:(CGRect)rect {
    [self setupView];
    
    if (self.row > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0.0f , self.bounds.size.height);
        CGContextScaleCTM(context, 1, -1);
        
        //字体
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)kKyoRowIndexViewFontName, kKyoRowIndexViewFontSize, NULL);
        //剧中对齐
        CTTextAlignment alignment = kCTCenterTextAlignment;
        CTParagraphStyleSetting alignmentStyle;
        alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
        alignmentStyle.valueSize=sizeof(alignment);
        alignmentStyle.value=&alignment;
        //样式设置
        CTParagraphStyleSetting settings[] = {alignmentStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 2);
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName];
        
        for (NSInteger i = 0; i < self.row; i++) {
            NSString *string = self.rowIndexType == KyoCinameSeatRowIndexTypeNumber ? [NSString stringWithFormat:@"%ld",(long)(i + 1)] : [NSString stringWithFormat:@"%C", (unichar)(i + 65)];
            if (self.arrayRowIndex && self.arrayRowIndex.count > i) {
                string = self.arrayRowIndex[i];
            }
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)kKyoRowIndexViewColor.CGColor range:NSMakeRange(0, attributedString.length)];
            [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, CGRectMake(0, self.bounds.size.height - self.bounds.size.height / self.row * (i + 1) - (self.bounds.size.height / self.row - kKyoRowIndexViewFontSize) / 4,  self.bounds.size.width, self.bounds.size.height / self.row));
            CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
            CTFrameDraw(frame, context);
            
            CFRelease(frame);
            CGPathRelease(path);
            CFRelease(framesetter);
        }
    }
}

#pragma mark --------------------
#pragma mark - Methods

- (void)setupView {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.width / 2;
    self.layer.masksToBounds = YES;
}


@end
