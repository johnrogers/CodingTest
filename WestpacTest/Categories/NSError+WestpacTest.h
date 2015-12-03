//
//  NSError+WestpacTest.h
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kForecastManagerErrorDomain;

typedef NS_ENUM(NSInteger, ForecastManagerError) {
	ForecastManagerErrorNoCurrentForecastReceived,
	ForecastManagerErrorLocationServicesIssue
};

@interface NSError (WestpacTest)

#pragma mark ForecastManager Errors: kForecastManagerErrorDomain;

+ (instancetype)noCurrentForecaseReceivedError;
+ (instancetype)locationServicesIssueError;

@end

// Error domains

//FOUNDATION_EXPORT NSString *const kAOTGAPICommunicationManagerErrorDomain;
//
//typedef NS_ENUM(NSInteger, AOTGAPICommunicationManagerError) {
//	AOTGAPICommunicationManagerErrorEmptyResponse,
//	AOTGAPICommunicationManagerErrorInvalidLogin,
//	AOTGAPICommunicationManagerErrorAnswersSubmissionUnsuccessful
//};
//
//@interface NSError (AOTG)
//
//#pragma mark APICommunicationManager Errors: kAOTGAPICommunicationManagerErrorDomain
//
//+ (instancetype)emptyResponseError;
//+ (instancetype)invalidLoginError;
//+ (instancetype)answersSubmissionUnsuccessfulError;