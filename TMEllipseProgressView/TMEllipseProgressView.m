//
//  TMEllipseProgressView.m
//  TMEllipseProgressView
//
//  Created by Takahiro Matsunaga on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TMEllipseProgressView.h"

#define kBarSize 10.0
#define kLineSize 1.0
#define kLineColor [[UIColor grayColor]CGColor]
#define kStartAngle 0.0

@interface TMEllipseProgressLayer : CALayer

@property (nonatomic) float progress;
@property (nonatomic, retain) UIColor *progressTintColor;
@property (nonatomic, retain) UIColor *trackTintColor;
@property (nonatomic) float barSize;
@property (nonatomic) float startAngle;

@end

@implementation TMEllipseProgressLayer
@synthesize progress = _progress;
@synthesize progressTintColor = _progressTintColor;
@synthesize trackTintColor = _trackTintColor;
@synthesize barSize = _barSize;
@synthesize startAngle = _startAngle;

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[self class]]) {
            [self setProgress:[layer progress]];
            [self setProgressTintColor:[layer progressTintColor]];
            [self setTrackTintColor:[layer trackTintColor]];
            [self setBarSize:[layer barSize]];
            [self setStartAngle:[layer startAngle]];
        }
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGRect rect = [self bounds];
    CGFloat radius = MIN(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat barSize = _barSize ? _barSize : kBarSize;
    
    CGPoint center = CGPointMake(radius, radius);
    CGFloat outerRadius = radius - (kLineSize / 2);
    CGFloat innerRadius = outerRadius - barSize;
    
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetShouldAntialias(ctx, true);
    
    CGContextScaleCTM(ctx, CGRectGetMidX(rect) / radius, CGRectGetMidY(rect) / radius);
    
    [self drawTrackInContext:ctx rect:rect];
    [self drawProgressInContext:ctx rect:rect];
    
    // clear
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextAddArc(ctx, center.x, center.y, innerRadius, 0, 2 * M_PI, 0);
    CGContextFillPath(ctx);
    
    // border
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    
    CGContextSetLineWidth(ctx, kLineSize);
    CGContextSetStrokeColorWithColor(ctx, kLineColor);
    CGContextAddArc(ctx, center.x, center.y, outerRadius, 0, 2 * M_PI, 0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx, center.x, center.y, innerRadius, 0, 2 * M_PI, 0);
    CGContextStrokePath(ctx);
}

#pragma mark - Private methods

- (void)drawTrackInContext:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat radius = MIN(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat barSize = _barSize ? _barSize : kBarSize;
    
    CGPoint center = CGPointMake(radius, radius);
    CGFloat midRadius = radius - (kLineSize / 2) - (barSize / 2);
    
    CGColorRef tintColor = [(_trackTintColor ? _trackTintColor : [UIColor whiteColor])CGColor];
    
    CGContextSaveGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    
    CGContextSetLineWidth(ctx, barSize);
    CGContextSetStrokeColorWithColor(ctx, tintColor);
    CGContextAddArc(ctx, center.x, center.y, midRadius, 0, 2 * M_PI, 0);
    CGContextStrokePath(ctx);
    
    [self drawGradientInContext:ctx rect:rect white:0.0];
    
    CGContextRestoreGState(ctx);
}

- (void)drawProgressInContext:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat radius = MIN(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat barSize = _barSize ? _barSize : kBarSize;
    
    CGPoint center = CGPointMake(radius, radius);
    CGFloat midRadius = radius - (kLineSize / 2) - (barSize / 2);
    
    CGFloat startAngle = _startAngle ? _startAngle : kStartAngle;
    CGFloat endAngle = _progress * (M_PI * 2) + startAngle;
    
    CGColorRef tintColor = [(_progressTintColor ? _progressTintColor : [UIColor blueColor])CGColor];
    
    CGContextSaveGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    
    CGContextSetLineWidth(ctx, barSize);
    CGContextSetStrokeColorWithColor(ctx, tintColor);
    CGContextAddArc(ctx, center.x, center.y, midRadius, startAngle, endAngle, 0);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    [self drawGradientInContext:ctx rect:rect white:1.0];
    
    CGContextRestoreGState(ctx);
}

- (void)drawGradientInContext:(CGContextRef)ctx rect:(CGRect)rect white:(CGFloat)white {
    CGFloat radius = MIN(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat barSize = _barSize ? _barSize : kBarSize;
    
    CGPoint center = CGPointMake(radius, radius);
    CGFloat endRadius = radius - (kLineSize / 2);
    CGFloat startRadius = endRadius - barSize;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {
        white, white, white, 1.0,
        white, white, white, 0.0,
        white, white, white, 0.0,
        white, white, white, 1.0,
    };
    static CGFloat locations[] = {0.0, 0.4, 0.6, 1.0};
    size_t count = sizeof(components) / (sizeof(CGFloat) * 4);
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
    
    CGContextDrawRadialGradient(ctx, gradient, center, startRadius, center, endRadius, kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
}

@end


@implementation TMEllipseProgressView

+ (Class)layerClass {
    return [TMEllipseProgressLayer class];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

- (float)progress {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    return [layer progress];
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (progress < 0.0) {
        progress = 0.0;
    } else if (progress > 1.0) {
        progress = 1.0;
    }
    
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        [animation setDuration:0.25];
        [animation setFromValue:[NSNumber numberWithFloat:[layer progress]]];
        [animation setToValue:[NSNumber numberWithFloat:progress]];
        
        [layer addAnimation:animation forKey:@"progressAnimation"];
        [layer setProgress:progress];
    } else {
        [layer setProgress:progress];
        [layer setNeedsDisplay];
    }
}

- (UIColor *)progressTintColor {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    return [layer progressTintColor];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    [layer setProgressTintColor:progressTintColor];
    [layer setNeedsDisplay];
}

- (UIColor *)trackTintColor {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    return [layer trackTintColor];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    [layer setTrackTintColor:trackTintColor];
    [layer setNeedsDisplay];
}

- (float)barSize {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    return [layer barSize];
}

- (void)setBarSize:(float)barSize {
    if (barSize < 0.0) {
        barSize = 0.0;
    }
    
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    [layer setBarSize:barSize];
    [layer setNeedsDisplay];
}

- (float)startAngle {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    return [layer startAngle];
}

- (void)setStartAngle:(float)startAngle {
    TMEllipseProgressLayer *layer = (TMEllipseProgressLayer *)[self layer];
    [layer setStartAngle:startAngle];
    [layer setNeedsDisplay];
}

#pragma  mark - Private methods

- (void)initValues {
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
