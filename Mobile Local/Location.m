//
//  Location.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/30/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "Location.h"

@implementation Location

+(Location *)singleton;
{
    // This Singleton pattern comes from:
    // http://cocoasamurai.blogspot.com/2011/04/singletons-your-doing-them-wrong.html
    
    static dispatch_once_t pred;
    static Location *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[Location alloc] init];
    });
    return shared;
}

@end
