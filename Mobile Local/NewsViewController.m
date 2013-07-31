//
//  NewsViewController.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/16/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "NewsViewController.h"
#import "Location.h"

@interface NewsViewController ()

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) News *news;

@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UITableView *newsTable;

@end

@implementation NewsViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.location = [Location singleton];
    self.news = [[News alloc] init];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [self updateDisplay];
}

- (void)updateDisplay;
{
    NewsRefreshCompleteBlock newsCallback = ^(BOOL success)
    {
        if (success)
            [self.newsTable reloadData];
    };
    
    [self setNavTitle];
    if (self.location.zipcode)
    {
        [self.news refreshWithLocation:self.location.zipcode withCallback:newsCallback];
    }
}

- (void)setNavTitle;
{
    if (self.location.zipcode)
        self.navTitle.title = [NSString stringWithFormat:@"News for %@", self.location.zipcode];
    else
        self.navTitle.title = @"Unknown Zipcode";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self.news articles] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];

    NSString *headline = [(NewsArticle *)[[_news articles] objectAtIndex:[indexPath row]] headline];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    [label setText:headline];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [(NewsArticle *)[[self.news articles] objectAtIndex:[indexPath row]] url];
    
    // Build the WebView we will use to display the article
    UIWebView *view = [[UIWebView alloc] initWithFrame:[self.view bounds]];
    view.delegate = self;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [view loadRequest:[NSURLRequest requestWithURL:url]];
    
    // Build a Controller to host the article's WebView
    UIViewController *webViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];    
    webViewController.view = view;
    webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissURLModal)];
    
    // Display our instantited controller
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController]
                       animated:YES completion:NULL];
}

- (void)dismissURLModal;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return NO;
}

@end
