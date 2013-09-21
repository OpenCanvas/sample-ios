//
//  DataStore.m
//  RoutesSample
//
//  Created by Konstantinos Dimitros on 9/16/13.
//  Copyright (c) 2013 Mobzili. All rights reserved.
//

#import "DataStore.h"
#import "JSONKit.h"
#import "Route.h"
#import "Place.h"

NSString *const kHostName = @"api.opencanvas.co";
NSString *const kVersion = @"v1.0";
NSString *const kAppHeaderKey = @"X-Mobzili-App-Key";
NSString *const kAppHeaderKeyValue = @"YmU2NmY0ZmMtMDBkMy00ZTkzLWJiMWQtYTkzOWJkZGRjNWM4";

@interface DataStore ()

@property (nonatomic, retain) MKNetworkEngine *routesEngine;

@end

@implementation DataStore

- (id)init {
    self = [super init];
    if (self) {
        self.routesEngine = [[MKNetworkEngine alloc] initWithHostName:kHostName customHeaderFields:[NSDictionary dictionaryWithObject:@"gzip" forKey:@"Content-Encoding"]];
        [self.routesEngine useCache];
     }
    return self;
}

#pragma mark - Server data acquisition methods
/* GET ROUTES */
- (void)getRoutesWithCompletionHandler:(void (^)(NSArray *routes))completionHandler {
    //NSLog(@"REQUEST(Routes): %@", [NSString stringWithFormat:@"%@/%@/routes", kHostName, kVersion]);
    MKNetworkOperation *operation = [self.routesEngine operationWithPath:[NSString stringWithFormat:@"%@/routes", kVersion]];
    [operation addHeaders:[NSDictionary dictionaryWithObject:kAppHeaderKeyValue forKey:kAppHeaderKey]];
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        if (![completedOperation isCachedResponse]) {
            NSDictionary *response = [completedOperation.responseData objectFromJSONData];
            NSArray *routeDicts = [response objectForKey:@"routes"];
            if (routeDicts && [routeDicts isKindOfClass:[NSArray class]]) {
                NSMutableArray *routes = [NSMutableArray arrayWithCapacity:[routeDicts count]];
                for (NSDictionary *routeDict in routeDicts) {
                    Route *route = [Route routeWithDictionary:routeDict];
                    [routes addObject:route];
                }
                completionHandler(routes);
            } else {
                completionHandler(nil);
            }
        }
    } onError:^(NSError *error) {
        completionHandler(nil);
    }];
    [self.routesEngine enqueueOperation:operation];
}

/* GET PLACES */
- (void)getPlacesForRoute:(Route *)route completionHandler:(void (^)(NSArray *places))completionHandler {
   // NSLog(@"REQUEST(Places): %@", [NSString stringWithFormat:@"%@/%@/routes/%d/places", kHostName, kVersion, route.routeID]);
    MKNetworkOperation *operation = [self.routesEngine operationWithPath:[NSString stringWithFormat:@"%@/routes/%d/places", kVersion, route.routeID]];
    [operation addHeaders:[NSDictionary dictionaryWithObject:kAppHeaderKeyValue forKey:kAppHeaderKey]];
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        if (![completedOperation isCachedResponse]) {
            NSDictionary *response = [completedOperation.responseData objectFromJSONData];
            NSArray *placesDicts = [response objectForKey:@"places"];
            if (placesDicts && [placesDicts isKindOfClass:[NSArray class]]) {
                NSMutableArray *places = [NSMutableArray arrayWithCapacity:[placesDicts count]];
                for (NSDictionary *placeDict in placesDicts) {
                    Place *place = [Place placeWithDictionary:placeDict];
                    [places addObject:place];
                }
                completionHandler(places);
            } else {
                completionHandler(nil);
            }
        }
    } onError:^(NSError *error) {
        completionHandler(nil);
    }];
    [self.routesEngine enqueueOperation:operation]; 
}

@end
