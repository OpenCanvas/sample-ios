//
//  RouteMapViewController.m
//  MobziliRoutes
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import "RouteMapViewController.h"
#import <MapKit/MapKit.h>
#import "DataStore.h"
#import "Route.h"
#import "Place.h"

@interface RouteMapViewController () <MKMapViewDelegate> {
    NSUInteger numberOfPoints;
}
@property (weak, nonatomic) IBOutlet MKMapView *routeMapView;

@end

@implementation RouteMapViewController

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
    
    self.routeMapView.delegate = self;
    
    // ... Load route and places from network or memory
    DataStore *dataStore = [[DataStore alloc] init];
    
    [dataStore getRoutesWithCompletionHandler:^(NSArray *routes) {
        if (routes) {
            Route *route = [routes objectAtIndex:0];
            
            [dataStore getPlacesForRoute:route completionHandler:^(NSArray *places) {
                if (places) {
                    [self.routeMapView addAnnotations:places];
                    [self.routeMapView addAnnotations:places];
                    [self zoomToFitMapAnnotations];
                    
                    MKMapPoint *poly = [self decodePolyLine:route.polyline];
                    MKPolyline* routeLine = [MKPolyline polylineWithPoints:poly count:numberOfPoints];
                    [self.routeMapView addOverlay:routeLine];
                }
            }];
        }
    }];
    
}

-(MKMapPoint *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    if (encodedStr!=nil) {
        [encoded appendString:encodedStr];
        [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
        NSInteger len = [encoded length];
        MKMapPoint *mapPointCArray = malloc(sizeof(CLLocationCoordinate2D) * len -1);
        NSInteger index = 0;
        
        NSInteger lat=0;
        NSInteger lng=0;
        NSInteger counter =0;
        while (index < len) {
            NSInteger b;
            NSInteger shift = 0;
            NSInteger result = 0;
            do {
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
            lat += dlat;
            shift = 0;
            result = 0;
            do {
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
            lng += dlng;
            NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
            NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
            
            CLLocationCoordinate2D coord;
            coord.latitude = [latitude floatValue];
            coord.longitude = [longitude floatValue];
            
            mapPointCArray[counter]=MKMapPointForCoordinate(coord);
            
            counter++;
            
        }
        numberOfPoints = counter;
        
        return mapPointCArray;
    }
    else {
        return nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRouteMapView:nil];
    [super viewDidUnload];
}

#pragma mark - MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolyline *polyLine = overlay;
	MKPolylineView *routeLineView = [[MKPolylineView alloc] initWithPolyline:polyLine];
    
    routeLineView.strokeColor = [UIColor blueColor];
    
    routeLineView.alpha = 0.8;
	routeLineView.lineWidth = 8;
	
	return routeLineView;
}

- (void)zoomToFitMapAnnotations {
    if ([self.routeMapView.annotations count] == 0) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id <MKAnnotation> annotation in self.routeMapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.09; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.09; // Add a little extra space on the sides
    
    region = [self.routeMapView regionThatFits:region];
    [self.routeMapView setRegion:region animated:YES];
}

@end
