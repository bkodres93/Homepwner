//
//  BNRPopoverBackground.m
//  Homepwner
//
//  Created by Benjamin Kodres-O'Brien on 12/26/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRPopoverBackground.h"

// CONSTANTS
#define ARROW_BASE 30.0f
#define ARROW_HEIGHT 30.0f
#define BORDER 0.0f

@interface BNRPopoverBackground ()

@property (nonatomic, strong) UIImageView *arrowImageView;

- (UIImage *)drawArrowImage:(CGSize)size;

@end


@implementation BNRPopoverBackground

// must synthesize the properties or an exception is thrown.
@synthesize arrowDirection;
@synthesize arrowOffset;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 * Overriden init method
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.arrowImageView];
    }
    return self;
}

/**
 * Overridden methods from UIPopoverBackgroundView
 */
+ (CGFloat)arrowBase
{
    return ARROW_BASE;
}

+ (CGFloat)arrowHeight
{
    return ARROW_HEIGHT;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(BORDER, BORDER, BORDER, BORDER);
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

- (UIImage *)drawArrowImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath, NULL, (size.width / 2.0f), size.height);
    CGPathAddLineToPoint(arrowPath, NULL, size.width, 0.0f);
    CGPathAddLineToPoint(arrowPath, NULL, 0.0f, 0.0f);
    CGPathCloseSubpath(arrowPath);
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);
    
    UIColor *fillColor = [UIColor grayColor];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class] arrowHeight]);
    
    self.arrowImageView.image = [self drawArrowImage:arrowSize];
    
    self.arrowImageView.frame = CGRectMake(self.bounds.origin.x + arrowSize.width / 4,
                                           self.bounds.size.height - arrowSize.height,
                                           arrowSize.width,
                                           arrowSize.height);
}




@end
