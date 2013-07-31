//
//  Mobile_LocalTests.m
//  Mobile LocalTests
//
//  Created by Chris Gerber on 7/16/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "Mobile_LocalTests.h"
#import "Weather.h"

@interface Mobile_LocalTests ()

@property (nonatomic, strong) Weather *weather;

@end

@implementation Mobile_LocalTests

- (void)setUp
{
    [super setUp];

    _weather = [[Weather alloc] init];
}

- (void)tearDown
{
    // Tear-down code would go here, if we needed it
    
    [super tearDown];
}

- (void)testExample
{
    // Test isNight: for Weather class
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    
    // Check night hours at boundaries
    for (NSString* hour in @[@"19", @"20", @"6"])
    {
        NSDate *night = [dateFormatter dateFromString:hour];
        STAssertTrue([_weather isNight:night], @"isNight: when hour is %@", hour);
    }
    
    // Check day hours at boundaries
    for (NSString* hour in @[@"7", @"8", @"18"])
    {
        NSDate *day = [dateFormatter dateFromString:hour];
        STAssertFalse([_weather isNight:day], @"isNight: when hour is %@", hour);
    }
    
    // What happens if we pass in nil?
}

@end
