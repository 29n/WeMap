//
//  MenuViewController.m
//  WeMap
//
//  Created by mac on 14-6-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "FriendViewController.h"
#import "MineViewController.h"

@interface MenuViewController () {
    int viewControllerIndex;
    NSArray *allViewControllerKeys;
}
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *allViewControllers;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewControllerIndex = 0;
    self.allViewControllers = [[NSMutableDictionary alloc] init];
    allViewControllerKeys = [[NSArray alloc] initWithObjects:@"Home", @"Friend", @"Mine", nil];
    
    
    UINavigationController *tmpNav = (UINavigationController *)self.sideMenuViewController.contentViewController;
    [self.allViewControllers setObject:tmpNav forKey:@"Home"];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (viewControllerIndex == indexPath.row) {
        [self.sideMenuViewController hideMenuViewController];
        return;
    }
    
    if ([self.sideMenuViewController.contentViewController isKindOfClass:[HomeViewController class]]) {
        
    }
    
    UINavigationController *nav;
    NSString *viewControllerKey = nil;
    switch (indexPath.row) {
        case 0:
            viewControllerKey = @"Home";
            break;
        case 1:
            viewControllerKey = @"Friend";
            break;
        case 2:
            viewControllerKey = @"Mine";
            break;
        default:
            break;
    }
    
    if (viewControllerKey == nil) {
        return;
    }
    
    nav = [self viewControllerForKey:viewControllerKey];
    if (![self.sideMenuViewController.contentViewController isEqual:nav]) {
        [self.sideMenuViewController setContentViewController: nav
                                                     animated:YES];
    }
    [self.sideMenuViewController hideMenuViewController];
    viewControllerIndex = indexPath.row;
}

- (UINavigationController *)viewControllerForKey:(NSString *)key
{
    
    UINavigationController *nav;
    if (![self.allViewControllers objectForKey:key]) {
        if ([key isEqualToString:@"Home"]) {
            nav = [[UINavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]];
        } else if ([key isEqualToString:@"Friend"]) {
            nav = [[UINavigationController alloc] initWithRootViewController:[[FriendViewController alloc] init]];
        } else if ([key isEqualToString:@"Mine"]) {
            nav = [[UINavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]];
        }
        [self.allViewControllers setObject:nav forKey:key];
    } else {
        nav = [self.allViewControllers objectForKey:key];
    }
    return nav;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"首页", @"好友", @"个人主页", @"设置", @"退出"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

@end
