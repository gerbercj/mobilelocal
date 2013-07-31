//
//  Location.h
//  Mobile Local
//
//  Created by Chris Gerber on 7/30/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (atomic, strong) NSString *zipcode;

+(Location *)singleton;

@end
