//
//  Weather.h
//  Mobile Local
//
//  Created by Chris Gerber on 7/16/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WeatherRefreshCompleteBlock) (BOOL success);

@interface Weather : NSObject

@property (nonatomic, strong, readonly) NSString *tempF;
@property (nonatomic, strong, readonly) NSString *tempC;
@property (nonatomic, strong, readonly) NSString *condition;
@property (nonatomic, strong, readonly) NSDate *observationTime;
@property (nonatomic, strong, readonly) NSString *imageName;
@property (nonatomic, strong, readonly) NSURL *imageURL;

- (void)refreshWithLocation:(NSString *)location
              withCallback:(WeatherRefreshCompleteBlock)callback;

- (BOOL)isNight:(NSDate *)time;

@end
