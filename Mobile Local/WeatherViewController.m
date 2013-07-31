//
//  WeatherViewController.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/16/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "WeatherViewController.h"
#import "Location.h"

@interface WeatherViewController ()

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Weather *weather;

@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *tempFLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempCLabel;

@end

@implementation WeatherViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.location = [Location singleton];
    self.weather = [[Weather alloc] init];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [self updateDisplay];
}

- (void)updateDisplay;
{
    WeatherRefreshCompleteBlock weatherCallback = ^(BOOL success)
    {
        if (success)
        {
            self.tempFLabel.text = self.weather.tempF;
            self.tempFLabel.hidden = NO;
            self.tempCLabel.text = self.weather.tempC;
            self.tempCLabel.hidden = NO;

            // Try to use local images first
            self.weatherImage.image = [UIImage imageNamed:self.weather.imageName];

            // If we couldn't load the image, we'll link to Weather Underground's on-line icon set
            if (!self.weatherImage.image)
                self.weatherImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.weather.imageURL]];
            
            self.weatherImage.hidden = NO;
        }
    };

    [self setNavTitle];
    if (self.location.zipcode)
    {
        [_weather refreshWithLocation:self.location.zipcode withCallback:weatherCallback];
    }
    else
    {
        self.tempFLabel.hidden = YES;
        self.tempCLabel.hidden = YES;
        self.weatherImage.hidden = YES;
    }
}

- (void)setNavTitle;
{
    if (self.location.zipcode)
        self.navTitle.title = [NSString stringWithFormat:@"Weather for %@", self.location.zipcode];
    else
        self.navTitle.title = @"Unknown Zipcode";
}

@end
