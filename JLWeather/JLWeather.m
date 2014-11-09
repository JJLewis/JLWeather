//
//  JLWeather.m
//
//
//  Created by Lewis, Jordan on 14/02/14.
//  Copyright (c) 2014 JordanLewis. All rights reserved.
//

#import "JLWeather.h"

@implementation JLWeather {
    NSDictionary *weatherServiceResponse;
}

- (id)init {
    self = [super init];
    
    weatherServiceResponse = @{};
    
    return self;
}

-(void)getCurrentWeatherWithLocation:(CLLocationCoordinate2D)location withCompletion:(void (^)(BOOL success))completionBlock {

    NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/weather";
    
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?lat=%f&lon=%f", BASE_URL_STRING, location.latitude, location.longitude];
    NSURL *weatherURL = [NSURL URLWithString:weatherURLText];
    
   // NSURL *weatherURLa = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?lat=-33.848693&lon=151.133066"];
    
    NSData* data = [NSData dataWithContentsOfURL:weatherURL];
    BOOL success;
    if (data == nil) {
        success = NO;
    } else {
        success = YES;
        NSError *error;
        weatherServiceResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self parseWeatherServiceResponse];
    }
    
    completionBlock(success);
}

-(void)getCurrentWeatherWithCityName:(NSString *)cityName withCompletion:(void (^)(BOOL success))completionBlock {
    
    NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/weather";
    
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?q=%@", BASE_URL_STRING, cityName];
    NSURL *weatherURL = [NSURL URLWithString:weatherURLText];

    NSData* data = [NSData dataWithContentsOfURL:weatherURL];
    BOOL success;
    if (data == nil) {
        success = NO;
    } else {
        success = YES;
        NSError *error;
        weatherServiceResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self parseWeatherServiceResponse];
    }
    
    completionBlock(success);
}

-(void)parseWeatherServiceResponse {
    
    // clouds
    _cloudCover = [weatherServiceResponse[@"clouds"][@"all"] integerValue];
    
    // coord
    _latitude = [weatherServiceResponse[@"coord"][@"lat"] doubleValue];
    _longitude = [weatherServiceResponse[@"coord"][@"lon"] doubleValue];
    
    // dt
    _reportTime = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"dt"] doubleValue]];
    
    // main
    _humidity = [weatherServiceResponse[@"main"][@"humidity"] integerValue];
    _pressure = [weatherServiceResponse[@"main"][@"pressure"] integerValue];
    _tempCurrent = [JLWeather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp"] doubleValue]];
    _tempMin = [JLWeather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_min"] doubleValue]];
    _tempMax = [JLWeather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_max"] doubleValue]];
    
    // name
    _city = weatherServiceResponse[@"name"];
    
    // rain
    _rain3hours = [weatherServiceResponse[@"rain"][@"3h"] integerValue];
    
    // snow
    _snow3hours = [weatherServiceResponse[@"snow"][@"3h"] integerValue];
    
    // sys
    _country = weatherServiceResponse[@"sys"][@"country"];
    NSDate *sunRiseDate = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunrise"] intValue]];
    NSDate *sunSetDate = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunset"] intValue]];

    NSTimeZone *deviceTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateToStr = [[NSDateFormatter alloc] init];
    [dateToStr setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [dateToStr setTimeZone:deviceTimeZone];
    NSDateFormatter *strToDate = [[NSDateFormatter alloc] init];
    [strToDate setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    _sunrise = [strToDate dateFromString:[dateToStr stringFromDate:sunRiseDate]];
    _sunset = [strToDate dateFromString:[dateToStr stringFromDate:sunSetDate]];
    
    // weather
    _conditions = weatherServiceResponse[@"weather"];
    
    // wind
    _windDirection = [weatherServiceResponse[@"wind"][@"dir"] integerValue];
    _windSpeed = [weatherServiceResponse[@"wind"][@"speed"] doubleValue];
    
    NSLog(@"Weather Parsed");
}

+(double)kelvinToCelsius:(double)degreesKelvin {
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}

@end
