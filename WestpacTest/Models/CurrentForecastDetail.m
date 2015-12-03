//
//  CurrentForecastDetail.m
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import "CurrentForecastDetail.h"

@implementation CurrentForecastDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return @{@"apparentTemperature": @"apparentTemperature",
			 @"temperature": @"temperature",
			 @"humidity": @"humidity",
			 @"summary": @"summary",
			 @"icon": @"icon"};
}

@end
