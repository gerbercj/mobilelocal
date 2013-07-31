//
//  Weather.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/16/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "Weather.h"

// You can provide your Weather Underground API key here:
// #define WUNDERGROUND_API_KEY @"YOUR_API_KEY"

@implementation Weather

- (BOOL)processPayload:(NSDictionary *)payload;
{
    NSDictionary *current_observation = [payload objectForKey:@"current_observation"];
    if (current_observation)
    {
        NSString *timeString = [current_observation objectForKey:@"observation_time_rfc822"];
        NSString *temp_f = [current_observation objectForKey:@"temp_f"];
        NSString *temp_c = [current_observation objectForKey:@"temp_c"];
        NSString *icon = [current_observation objectForKey:@"icon"];

        if (timeString && temp_f && temp_c && icon)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
            _observationTime = [dateFormatter dateFromString:timeString];
            _condition = [current_observation objectForKey:@"weather"];
            _tempF = [NSString stringWithFormat:@"%0.1f°", [temp_f floatValue]];
            _tempC = [NSString stringWithFormat:@"%0.1fC", [temp_c floatValue]];
            _imageName = [self imageForCondition:icon atTime:self.observationTime];
            _imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/%@", _imageName]];
            return YES;
        }
    }
    return NO;
}

- (void)refreshWithLocation:(NSString *)location withCallback:(WeatherRefreshCompleteBlock)callback;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", WUNDERGROUND_API_KEY, location]];
                  
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSDictionary *jsonPayload = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        callback([self processPayload:jsonPayload]);
    }];
}

- (BOOL)isNight:(NSDate *)time;
{
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:time];
    int hour = [timeComponents hour];
    
    // This maps 7PM to 7AM as night time, returning YES in that case
    return ((hour + 5) % 24 < 12);
}

- (NSString *)imageForCondition:(NSString *)condition atTime:(NSDate *)time;
{
    // TODO: It might be nice to move these to a plist...
    NSDictionary *conditionMap = @{
        @"chanceflurries": @"snow",
        @"chancerain": @"rain",
        @"chancesleet": @"sleet",
        @"chancesnow": @"snow",
        @"chancetstorms": @"tstorms",
        @"clear": @"clear",
        @"cloudy": @"cloudy",
        @"flurries": @"snow",
        @"fog": @"fog",
        @"hazy": @"fog",
        @"mostlycloudy": @"partlycloudy",
        @"mostlysunny": @"partlycloudy",
        @"partlycloudy": @"partlycloudy",
        @"partlysunny": @"partlycloudy",
        @"rain": @"rain",
        @"sleet": @"sleet",
        @"snow": @"snow",
        @"sunny": @"clear",
        @"tstorms": @"tstorms",
        @"nt_chanceflurries": @"snow",
        @"nt_chancerain": @"rain",
        @"nt_chancesleet": @"sleet",
        @"nt_chancesnow": @"snow",
        @"nt_chancetstorms": @"tstorms",
        @"nt_clear": @"nt_clear",
        @"nt_cloudy": @"cloudy",
        @"nt_flurries": @"snow",
        @"nt_fog": @"fog",
        @"nt_hazy": @"fog",
        @"nt_mostlycloudy": @"nt_partlycloudy",
        @"nt_mostlysunny": @"nt_partlycloudy",
        @"nt_partlycloudy": @"nt_partlycloudy",
        @"nt_partlysunny": @"nt_partlycloudy",
        @"nt_rain": @"rain",
        @"nt_sleet": @"sleet",
        @"nt_snow": @"snow",
        @"nt_sunny": @"nt_clear",
        @"nt_tstorms": @"tstorms"
    };
    
    NSString *format = [self isNight:time] ? @"nt_%@" : @"%@";
    
    return [NSString stringWithFormat:@"%@.gif", [conditionMap objectForKey:[NSString stringWithFormat:format, [condition lowercaseString]]]];
}

@end
