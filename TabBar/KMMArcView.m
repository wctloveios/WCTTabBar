//
//  KMMArcView.m
//  Maintenance
//
//  Created by kmcompany on 2017/8/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMArcView.h"

@implementation KMMArcView

- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, RGB(200, 200, 200).CGColor);
    
    
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    CGContextBeginPath(context);
  //  CGFloat lineMargin =self.width*0.5f;
    
    //1px线，偏移像素点
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    
    
    
    CGFloat yPos = self.width*0.5f - pixelAdjustOffset;
    
    CGFloat xPos = self.width*0.5f - pixelAdjustOffset;
    
    CGContextAddArc(context, xPos, yPos, self.width*0.5f, M_PI, 0, 0);
    
    
    CGContextStrokePath(context);
    
    
}

@end
