//
//  DataStore.h
//  RoutesSample
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

@class Route;
@class Place;

@interface DataStore : NSObject

- (void)getRoutesWithCompletionHandler:(void (^)(NSArray *routes))completionHandler;
- (void)getPlacesForRoute:(Route *)route completionHandler:(void (^)(NSArray *places))completionHandler;

@end
