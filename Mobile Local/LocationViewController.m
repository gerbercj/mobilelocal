//
//  LocationViewController.m
//  Mobile Local
//
//  Created by Chris Gerber on 7/28/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import "LocationViewController.h"
#import "Location.h"

@interface LocationViewController ()

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation LocationViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];

    self.location = [Location singleton];
    self.geocoder = [[CLGeocoder alloc] init];
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated;
{
    [self updateDisplay];
}

- (void)updateDisplay;
{
    [self setNavTitle];
}

- (void)setNavTitle;
{
    if (self.location.zipcode)
        self.navTitle.title = [NSString stringWithFormat:@"Current Zipcode: %@", self.location.zipcode];
    else
        self.navTitle.title = @"Unknown Zipcode";
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
{
    [self.geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        [self centerMap:mapView atLocation:self.mapView.userLocation.location.coordinate];
        NSString *zipcode = [[placemarks objectAtIndex:0] postalCode];
        if (zipcode)
            self.location.zipcode = zipcode;
        [self updateDisplay];
    }];
}

- (void)centerMap:(MKMapView *)mapView atLocation:(CLLocationCoordinate2D)location;
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.5;
    span.longitudeDelta = 0.5;

    MKCoordinateRegion region;
    region.span = span;
    region.center = location;

    [mapView setRegion:region animated:YES];
}

@end
