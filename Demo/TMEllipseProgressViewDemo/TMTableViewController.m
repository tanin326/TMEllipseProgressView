//
//  TMTableViewController.m
//  TMEllipseProgressViewDemo
//
//  Created by Takahiro Matsunaga on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TMTableViewController.h"

@interface TMTableViewController ()

@end

@implementation TMTableViewController
@synthesize selectedIndex = _selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"Ellipse"]) {
        TMViewController *vc = [segue destinationViewController];
        [vc setSelectedIndex:_selectedIndex];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch ([indexPath row]) {
        case 0:
            [[cell textLabel]setText:@"Normal, Circle"];
            break;
        case 1:
            [[cell textLabel]setText:@"Normal, Ellipse"];
            break;
        case 2:
            [[cell textLabel]setText:@"Custom, Ellipse"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = [indexPath row];
    [self performSegueWithIdentifier:@"Ellipse" sender:self];
}

@end
