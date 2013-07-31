//
//  LocationViewController.h
//  Mobile Local
//
//  Created by Chris Gerber on 7/28/13.
//  Copyright (c) 2013 Chris Gerber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end
