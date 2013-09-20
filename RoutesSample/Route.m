//
//  Route.m
//  RoutesSample
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import "Route.h"
#import "Place.h"

@implementation Route

@synthesize routeID = _routeID;
@synthesize name = _name;
@synthesize routeDescription = _routeDescription;
@synthesize about = _about;
@synthesize coordinate = _coordinate;
@synthesize cover = _cover;
@synthesize placeCount = _placeCount;
@synthesize distance = _distance;
@synthesize duration = _duration;
@synthesize viewCount = _viewCount;
@synthesize likeCount = _likeCount;
@synthesize lastModified = _lastModified;
@synthesize polyline = polyline_;

+ (id)routeWithDictionary:(NSDictionary *)dictionary {
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
            self.routeID = [NILIFNULL(obj) integerValue];
        } else if ([key isEqualToString:@"name"]) {
            self.name = NILIFNULL(obj);
        } else if ([key isEqualToString:@"description"]) {
            self.routeDescription = NILIFNULL(obj);
        } else if ([key isEqualToString:@"about"]) {
            self.about = NILIFNULL(obj);
        } else if ([key isEqualToString:@"lat"]) {
            self.coordinate = CLLocationCoordinate2DMake([NILIFNULL(obj) doubleValue], [[dictionary objectForKey:@"lon"] doubleValue]);
        } else if ([key isEqualToString:@"lon"]) {
            // Ignore, handled under lat
        } else if ([key isEqualToString:@"cover"]) {
            self.cover = NILIFNULL(obj);
        } else if ([key isEqualToString:@"placeCount"]) {
            self.placeCount = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"distance"]) {
            self.distance = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"duration"]) {
            self.duration = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"viewCount"]) {
            self.viewCount = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"likeCount"]) {
            self.likeCount = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"lastModified"]) {
            self.lastModified = [NILIFNULL(obj) unsignedIntegerValue];
        } else if ([key isEqualToString:@"polyline"]) {
            self.polyline = NILIFNULL(obj);
        } else {
          //  NSLog(@"%@: Unknown key '%@' with value '%@'.", NSStringFromClass([self class]), key, obj);
        }
    }];
}

@end
