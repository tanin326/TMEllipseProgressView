//
//  TMEllipseProgressView.h
//  TMEllipseProgressView
//
//  Created by Takahiro Matsunaga on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TMEllipseProgressView : UIView<NSCoding, UIAppearanceContainer>

@property (nonatomic) float progress;
@property (nonatomic, retain) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) float barSize;
@property (nonatomic) float startAngle;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
