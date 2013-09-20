//
//  Place.h
//  RoutesSample
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef enum {
    ObjectCircleShape,
    ObjectPolygonShape
} ObjectShape;

@interface Place : NSObject <MKAnnotation>

@property (nonatomic, assign) NSInteger placeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readonly) NSMutableArray *geofenceCoordinates;

@property (nonatomic, assign) NSUInteger storyCount;
@property (nonatomic, assign) NSUInteger lastModified;
@property (nonatomic, strong) NSArray *alerts;
@property (nonatomic, assign) BOOL showOnMap;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, assign) BOOL isUnlocked;
@property (nonatomic, readwrite) double distanceFromCurrentLocation;

@property (nonatomic) ObjectShape shape;
@property (nonatomic) CLLocationDistance radius;

+ (id)placeWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary;

- (CLRegion *)region;

@end
