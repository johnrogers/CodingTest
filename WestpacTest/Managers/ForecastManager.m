//
//  ForecastManager.m
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import "ForecastManager.h"

#import <AFNetworking/AFNetworking.h>
#import <INTULocationManager/INTULocationManager.h>

#import "CurrentForecastDetail.h"
#import "NSError+WestpacTest.h"

static NSString *const kForecastIOBaseUrl = @"https://api.forecast.io/forecast";
static NSString *const kForecastIOAPIKey = @"7fb0d7ad0eb8de8fbe447287c61c848e";

@interface ForecastManager ()

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;

@end

@implementation ForecastManager

+ (instancetype)sharedManager
{
	static ForecastManager *shared;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[ForecastManager alloc] init];
	});
	return shared;
}

- (instancetype)init
{
	if ((self = [super init])) {
		// Setup AFNetworking to receive JSON
		NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kForecastIOBaseUrl, kForecastIOAPIKey]];
		
		_httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
		self.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
	}
	return self;
}

#pragma mark - Retrieving weather forecast

- (void)retrieveForecastForCurrentLocationWithCompletion:(ForecastCompletion)completion
{
	INTULocationManager *manager = [INTULocationManager sharedInstance];
	[manager requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
																	 timeout:30
														delayUntilAuthorized:YES
																	   block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
																		   if (status == INTULocationStatusSuccess) {
																			   // Location has been retrieved - grab the forecast data
																			   [self requestForecastDataForLocation:currentLocation withCompletion:completion];
																		   }
																		   else {
																			   // Something went wrong with the location services
																			   if (completion) {
																				   completion(nil, nil, [NSError locationServicesIssueError]);
																			   }
																		   }
																	   }];
}

#pragma mark - Forecast.io API 

- (void)requestForecastDataForLocation:(CLLocation *)location withCompletion:(nonnull ForecastCompletion)completion;
{
	NSParameterAssert(completion);
	
	if (location.coordinate.latitude && location.coordinate.longitude) {
		NSString *locationSubstring = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
		NSString *urlString = [self.httpSessionManager.baseURL.absoluteString stringByAppendingFormat:@"%@", locationSubstring];
		
		[self.httpSessionManager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
			if (responseObject[@"currently"]) {
				NSDictionary *currentForecastData = responseObject[@"currently"];
				NSError *mtlError;
				
				// Construct a forecast model from the response
				CurrentForecastDetail *detail = [MTLJSONAdapter modelOfClass:[CurrentForecastDetail class] fromJSONDictionary:currentForecastData error:&mtlError];
				
				if (completion) {
					completion(detail, location, nil);
				}
			}
			else {
				// No current forecast data received
				if (completion) {
					completion(nil, location, [NSError noCurrentForecaseReceivedError]);
				}
			}
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			if (completion) {
				completion(nil, location, error);
			}
		}];
	}
}

@end
