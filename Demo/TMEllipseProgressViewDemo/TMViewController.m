//
//  TMViewController.m
//  TMEllipseProgressViewDemo
//
//  Created by Takahiro Matsunaga on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TMViewController.h"

@interface TMViewController ()

@end

@implementation TMViewController
@synthesize selectedIndex = _selectedIndex;
@synthesize ellipseProgress = _ellipseProgress;
@synthesize progress = _progress;
@synthesize timer = _timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ellipseProgress = [[TMEllipseProgressView alloc]init];
    _progress = 0.0;
    [_ellipseProgress setProgress:_progress];
    
    switch (_selectedIndex) {
        case 0:
            [_ellipseProgress setFrame:CGRectMake(10, 10, 200, 200)];
            break;
        case 1:
            [_ellipseProgress setFrame:CGRectMake(10, 10, 300, 200)];
            break;
        case 2:
            [_ellipseProgress setFrame:CGRectMake(10, 10, 200, 300)];
            [_ellipseProgress setProgressTintColor:[UIColor redColor]];
            [_ellipseProgress setTrackTintColor:[UIColor greenColor]];
            [_ellipseProgress setBarSize:20.0];
            [_ellipseProgress setStartAngle:-M_PI_4];
            break;
        default:
            break;
    }
    
    [[self view]addSubview:_ellipseProgress];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action methods

- (IBAction)refreshAction:(id)sender {
    _progress = 0.0;
    [_ellipseProgress setProgress:_progress];
}

- (IBAction)pauseAction:(id)sender {
    [_timer invalidate];
}

- (IBAction)playAction:(id)sender {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];
}

#pragma mark - Private methods


- (void)showActivity {
    if (_progress < 1.0) {
        _progress += 0.05;
        [_ellipseProgress setProgress:_progress animated:YES];
    } else {
        [_timer invalidate];
    }
}

@end
