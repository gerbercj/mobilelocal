//
//  NewsArticle.h
//  Mobile Local
//
//  Created by Chris Gerber on 7/28/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsArticle : NSObject

@property (nonatomic, strong) NSString* headline;
@property (nonatomic, strong) NSURL* url;

- (id)initWithHeadline:(NSString *)headline andURL:(NSURL *)url;

@end
