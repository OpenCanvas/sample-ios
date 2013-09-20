//
//  Route.h
//  RoutesSample
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class Place;

@interface Route : NSObject

@property (nonatomic, assign) NSInteger routeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *routeDescription;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) NSUInteger placeCount;
@property (nonatomic, assign) NSUInteger distance;
@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, assign) NSUInteger viewCount;
@property (nonatomic, assign) NSUInteger likeCount;
@property (nonatomic, assign) NSUInteger lastModified;
@property (nonatomic, strong) NSString *polyline;

+ (id)routeWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary;


@end
