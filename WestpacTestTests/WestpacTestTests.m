//
//  WestpacTestTests.m
//  WestpacTestTests
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ForecastManager.h"
#import "NSError+WestpacTest.h"

@interface WestpacTestTests : XCTestCase

@end

@implementation WestpacTestTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testForecastRetrieval
{
	/*
	 * If given more time I would take the time to write stubs using a 
	 * library such as OHHTTPStubs to provide mock API responses to test
	 * that errors are correctly returned.
	 */
	XCTestExpectation *expectation = [self expectationWithDescription:@"Forecast is retrieved"];
	
	[[ForecastManager sharedManager] retrieveForecastForCurrentLocationWithCompletion:^(CurrentForecastDetail * _Nullable forecastDetail, CLLocation * _Nullable forecastLocation, NSError * _Nullable error) {
		XCTAssertNotNil(forecastDetail);
		[expectation fulfill];
	}];
	
	[self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
		if (error) {
			NSLog(@"Forecast not retrieved in a timely manner.");
		}
	}];
}

- (void)testNoCurrentForecastReceivedErrorReturned
{
	NSError *noCurrentForecastReceivedError = [NSError noCurrentForecastReceivedError];
	XCTAssert(noCurrentForecastReceivedError.domain == kForecastManagerErrorDomain);
	XCTAssert(noCurrentForecastReceivedError.code == ForecastManagerErrorNoCurrentForecastReceived);
}

- (void)testLocationServicesIssueErrorReturned
{
	NSError *noCurrentForecastReceivedError = [NSError locationServicesIssueError];
	XCTAssert(noCurrentForecastReceivedError.domain == kForecastManagerErrorDomain);
	XCTAssert(noCurrentForecastReceivedError.code == ForecastManagerErrorLocationServicesIssue);
}

@end
