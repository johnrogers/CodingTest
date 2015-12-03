//
//  CurrentForecastDetail.h
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CurrentForecastDetail : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSNumber *apparentTemperature;
@property (copy, nonatomic) NSNumber *temperature;
@property (copy, nonatomic) NSNumber *humidity;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *icon;

@end
