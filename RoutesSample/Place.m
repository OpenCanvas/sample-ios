//
//  Place.m
//  RoutesSample
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import "Place.h"
@interface Place ()  {
@private
    CLRegion *_region;
    NSMutableArray *_geofenceCoordinates;
}

@property (nonatomic, strong, readwrite) NSMutableArray *geofenceCoordinates;

- (void)addCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end

@implementation Place

@synthesize placeID = _placeID;
@synthesize name = _name;
@synthesize coordinate = _coordinate;
@synthesize geofenceCoordinates = _geofenceCoordinates;
@synthesize cover = _cover;
@synthesize storyCount = _storyCount;
@synthesize alerts = _alerts;
@synthesize showOnMap = _showOnMap;
@synthesize pin = _pin;
@synthesize isUnlocked = _isUnlocked;
@synthesize shape = _shape;
@synthesize radius = _radius;
@synthesize distanceFromCurrentLocation = _distanceFromCurrentLocation;

+ (id)placeWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"id"]) {
            self.placeID = [NILIFNULL(obj) integerValue];
        } else if ([key isEqualToString:@"name"]) {
            self.name = NILIFNULL(obj);
        } else if ([key isEqualToString:@"lat"]) {
            self.coordinate = CLLocationCoordinate2DMake([NILIFNULL(obj) doubleValue], [NILIFNULL([dictionary objectForKey:@"lon"]) doubleValue]);
        } else if ([key isEqualToString:@"lon"]) {
            // Ignore, handled under lat
        } else if ([key isEqualToString:@"geoFence"]) {
            self.shape = ObjectPolygonShape;
            self.geofenceCoordinates = [NSMutableArray array];
            // Add coordinates
            NSString *geofence = NILIFNULL(obj);
            NSArray *coordinates = [geofence componentsSeparatedByString:@":"];
            for (NSString *coordinate in coordinates) {
                NSArray *comps = [coordinate componentsSeparatedByString:@","];
                if ([comps count] == 2) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[comps objectAtIndex:0] doubleValue], [[comps objectAtIndex:1] doubleValue]);
                    [self addCoordinate:coord];
                }
            }
        } else if ([key isEqualToString:@"cover"]) {
            self.cover = NILIFNULL(obj);
        } else if ([key isEqualToString:@"storyCount"]) {
            self.storyCount = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"lastModified"]) {
            self.lastModified = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"isMapPoint"]) {
            self.showOnMap = [NILIFNULL(obj) boolValue];
        } else if ([key isEqualToString:@"pin"]) {
            self.pin = NILIFNULL(obj);
        } else if ([key isEqualToString:@"isLocked"]) {
            self.isUnlocked = ![NILIFNULL(obj) boolValue];
        } else {
           // NSLog(@"%@: Unknown key '%@' with value '%@'.", NSStringFromClass([self class]), key, obj);
        }
    }];
}

#pragma mark - MKAnnotation
- (NSString *)title {
    return self.name;
}


- (void)addCoordinate:(CLLocationCoordinate2D)newCoordinate {
    NSValue *coordValue = [NSValue valueWithBytes:&newCoordinate objCType:@encode(CLLocationCoordinate2D)];
    [_geofenceCoordinates addObject:coordValue];
}

@end
