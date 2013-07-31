//
//  NewsArticle.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/28/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "NewsArticle.h"

@implementation NewsArticle

- (id)initWithHeadline:(NSString *)headline andURL:(NSURL *)url;
{
    self = [super init];
    if (self)
    {
        _headline = headline;
        _url = url;
    }
    return self;
}

@end
