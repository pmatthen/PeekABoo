//
//  MapViewController.m
//  PeekABoo
//
//  Created by Apple on 01/02/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
{
    __weak IBOutlet MKMapView *myMapView;
}

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    CLGeocoder*  geoCoder = [CLGeocoder new];
    
    [geoCoder geocodeAddressString:_addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark;
        placemark = placemarks[0];
        CLLocation *location = placemark.location;
        
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.title = _addressString;
        NSLog(@"address = %@", _addressString);
        annotation.coordinate = location.coordinate;
        [myMapView addAnnotation:annotation];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.0001, 0.0001);
        MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, span);
        
        [myMapView setRegion:region animated:animated];

    }];

}

@end
