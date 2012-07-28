//
//  TMViewController.h
//  TMEllipseProgressViewDemo
//
//  Created by Takahiro Matsunaga on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMEllipseProgressView.h"

@interface TMViewController : UIViewController

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, readonly) TMEllipseProgressView *ellipseProgress;
@property (nonatomic, readonly) float progress;
@property (nonatomic, readonly) NSTimer *timer;

- (IBAction)refreshAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)playAction:(id)sender;

@end
