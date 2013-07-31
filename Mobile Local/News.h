//
//  News.h
//  Mobile Local
//
//  Created by Chris Gerber on 7/28/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsArticle.h"

typedef void (^NewsRefreshCompleteBlock) (BOOL success);

@interface News : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *articles;

-(id)init;
-(void)refreshWithLocation:(NSString *)location
              withCallback:(NewsRefreshCompleteBlock)callback;

@end
