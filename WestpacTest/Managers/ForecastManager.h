//
//  ForecastManager.h
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CurrentForecastDetail, CLLocation;

typedef void (^ForecastCompletion)(CurrentForecastDetail *_Nullable forecastDetail,
								   CLLocation *_Nullable forecastLocation,
								   NSError *_Nullable error);

@interface ForecastManager : NSObject

+ (nonnull instancetype)sharedManager;

/**
 * Retireves the weather forecast for the current location.
 * Completion handler is called upon success or failure. Upon failure,
 * the error message will contain a suitable error domain and description.
 */
- (void)retrieveForecastForCurrentLocationWithCompletion:(nonnull ForecastCompletion)completion;

/**
 * The last retrieved forecast detail. Nil if none.
 */
@property (strong, nonatomic) CurrentForecastDetail *_Nullable lastRetrievedForecastDetail;

@end
