//
//  NSError+WestpacTest.m
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import "NSError+WestpacTest.h"

NSString *const kForecastManagerErrorDomain = @"com.WestpacTest.ForecastManagerErrorDomain";

@implementation NSError (WestpacTest)

#pragma mark - ForecastManager Errors: kForecastManagerErrorDomain

+ (instancetype)noCurrentForecaseReceivedError
{
	return [NSError errorWithDomain:kForecastManagerErrorDomain
							   code:ForecastManagerErrorNoCurrentForecastReceived
						   userInfo:@{NSLocalizedDescriptionKey: @"No current forecast information received",
									  NSLocalizedRecoverySuggestionErrorKey: @"Ensure correct location information was given"}];
}

+ (instancetype)locationServicesIssueError
{
	return [NSError errorWithDomain:kForecastManagerErrorDomain
							   code:ForecastManagerErrorLocationServicesIssue
						   userInfo:@{NSLocalizedDescriptionKey: @"Location services issue - location not found",
									  NSLocalizedRecoverySuggestionErrorKey: @"Ensure location services is enabled in settings and device is able to get a location"}];
}

@end
