//
//  News.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/28/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "News.h"

@implementation News

- (id)init;
{
    self = [super init];
    if (self)
    {
        _articles = nil;
    }
    return self;
}

- (BOOL)processPayload:(NSDictionary *)payload;
{
    id query = [payload objectForKey:@"query"];
    if (query)
    {
        id results = [query objectForKey:@"results"];
        if (results)
        {
            NSArray *items = [results objectForKey:@"item"];
            if (items)
            {
                _articles = nil;
                for (NSDictionary *item in items)
                {
                    NSString *headline = [item objectForKey:@"title"];
                    NSURL *url = [NSURL URLWithString:[item objectForKey:@"link"]];
                    [self addArticle:[[NewsArticle alloc] initWithHeadline:headline andURL:url]];
                }
                return YES;
            }
        }
    }
    return NO;
}

- (void)refreshWithLocation:(NSString *)location withCallback:(NewsRefreshCompleteBlock)callback;
{
    if (location)
    {
        NSString* escapedLocation = [location stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* urlString = [[@"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20rss%20where%20url%3D%22news.google.com%2Fnews%3Foutput%3Drss%26geo%3D"
                                stringByAppendingString:escapedLocation]
                                stringByAppendingString:@"%22&format=json"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            NSDictionary *jsonPayload = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            callback([self processPayload:jsonPayload]);
        }];
    }
}

- (void)addArticle:(NewsArticle *)article;
{
    if (!_articles)
        _articles = [[NSMutableArray alloc] init];
    [_articles addObject:article];
}

@end
