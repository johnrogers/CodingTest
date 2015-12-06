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

#pragma mark ForecastManager Errors: kForecastManagerErrorDomain

+ (instancetype)noCurrentForecastReceivedError;
+ (instancetype)locationServicesIssueError;

@end
