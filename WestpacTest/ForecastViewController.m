//
//  ForecastViewController.m
//  WestpacTest
//
//  Created by John Rogers on 3/12/2015.
//  Copyright © 2015 John Rogers. All rights reserved.
//

#import "ForecastViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "ForecastManager.h"
#import "CurrentForecastDetail.h"

#import "NSError+WestpacTest.h"

@interface ForecastViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *apparentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (strong, nonatomic) NSNumberFormatter *temperatureUnitNumberFormatter;
@property (strong, nonatomic) NSNumberFormatter *humidityNumberFormatter;

@end

@implementation ForecastViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Setup the temperature number formatter
	_temperatureUnitNumberFormatter = [NSNumberFormatter new];
	self.temperatureUnitNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
	self.temperatureUnitNumberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
	self.temperatureUnitNumberFormatter.minimumFractionDigits = 1;
	self.temperatureUnitNumberFormatter.maximumFractionDigits = 1;
	
	// Setup the humidity number formatter
	_humidityNumberFormatter = [NSNumberFormatter new];
	self.humidityNumberFormatter.numberStyle = NSNumberFormatterPercentStyle;
	
	[self retrieveForecast];
}

#pragma mark - View updates

- (void)updateForForecastDetail:(CurrentForecastDetail *)forecastDetail
{
	NSNumber *temperatureInCelcius = [self convertUnitToCelciusFromFahrenheitTemperature:forecastDetail.temperature];
	NSNumber *apparentTemperatureInCelcius = [self convertUnitToCelciusFromFahrenheitTemperature:forecastDetail.apparentTemperature];
	
	NSString *temperatureString = [[self.temperatureUnitNumberFormatter stringFromNumber:temperatureInCelcius] stringByAppendingString:@"°c"];
	NSString *apparentTemperatureString = [[self.temperatureUnitNumberFormatter stringFromNumber:apparentTemperatureInCelcius] stringByAppendingString:@"°c"];
	NSString *humidityString = [self.humidityNumberFormatter stringFromNumber:forecastDetail.humidity];
	
	self.conditionImageView.image = [UIImage imageNamed:forecastDetail.icon];
	self.temperatureLabel.text = temperatureString;
	self.apparentTemperatureLabel.text = [@"Feels like: " stringByAppendingString:apparentTemperatureString];
	self.summaryLabel.text = forecastDetail.summary;
	self.humidityLabel.text = [@"Humidity: " stringByAppendingString:humidityString];
}

- (void)showLoadingView:(BOOL)showLoadingView
{
	[UIView animateWithDuration:0.3f animations:^{
		self.loadingView.alpha = showLoadingView ? 1.f : 0.f;
	}];
}

#pragma mark - Data retrieval

- (void)retrieveForecast
{
	[self showLoadingView:YES];
	[[ForecastManager sharedManager] retrieveForecastForCurrentLocationWithCompletion:^(CurrentForecastDetail *_Nonnull forecastDetail,
																						CLLocation *_Nonnull forecastLocation,
																						NSError *_Nonnull error) {
		if (error != nil) {
			NSString *actionTitle = NSLocalizedString(@"Retry", nil);
			NSString *message;
			UIAlertAction *retryAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[self retrieveForecast];
			}];
			
			if (error.domain == kForecastManagerErrorDomain) {
				if (error.code == ForecastManagerErrorNoCurrentForecastReceived) {
					// Got location, and forecast, but no current forecast information
					message = NSLocalizedString(@"No current forecast information to display.",
												@"ForecastViewController - Alert message - No current forecast info to display");
				}
				else if (error.code == ForecastManagerErrorLocationServicesIssue) {
					// Location services issue
					message = NSLocalizedString(@"Location services unavailable. Please ensure they are enabled in iOS' Settings.",
												@"ForecastViewController - Alert message - Location services unavailable");
				}
			}
			else {
				// Network-related issue
				message = NSLocalizedString(@"Network unavailable. Please ensure the internet is available and try again.",
											@"ForecastViewController - Alert message - Network unavailable");
			}
			
			NSString *alertTitle = NSLocalizedString(@"Error Retrieving Forecast", @"ForecastViewController - Alert controller title - Error retrieving forecast");
			UIAlertController *ac = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
			[ac addAction:retryAction];
			[self presentViewController:ac animated:YES completion:nil];
		}
		else {
			// Reverse-Geocode the location to display where the forecast's for
			CLGeocoder *geocoder = [CLGeocoder new];
			[geocoder reverseGeocodeLocation:forecastLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
				if (placemarks && placemarks.count) {
					CLPlacemark *placemark = placemarks.firstObject;
					
					self.locationLabel.text = [placemark.locality stringByAppendingFormat:@", %@", placemark.administrativeArea];
				}
				else {
					self.locationLabel.text = @"Unknown Location";
				}
			}];
			
			// Update the view with the received data
			[self updateForForecastDetail:forecastDetail];
			[self showLoadingView:NO];
		}
	}];
}

#pragma mark - Helpers

- (NSNumber *)convertUnitToCelciusFromFahrenheitTemperature:(NSNumber *)fahrenheitTemperature
{
	CGFloat fahrenheitTempFloat = [fahrenheitTemperature floatValue];
	return @((fahrenheitTempFloat - 32.f) * (5.f / 9.f));
}

@end
