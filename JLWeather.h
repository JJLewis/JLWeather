//
//  JLWeather.h
//  
//
//  Created by Lewis, Jordan on 14/02/14.
//  Copyright (c) 2014 JordanLewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JLWeather : NSObject

// Properties
// ==========

// Place and time
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, readonly) CGFloat latitude;
@property (nonatomic, readonly) CGFloat longitude;
@property (nonatomic, copy, readonly) NSDate *reportTime;
@property (nonatomic, copy, readonly) NSDate *sunrise; // At GMT 0
@property (nonatomic, copy, readonly) NSDate *sunset; // At GMT 0

// Qualitative
@property (nonatomic, copy, readonly) NSArray *conditions;

// Quantitative
@property (nonatomic, readonly) NSInteger cloudCover;
@property (nonatomic, readonly) NSInteger humidity;
@property (nonatomic, readonly) NSInteger pressure;
@property (nonatomic, readonly) NSInteger rain3hours;
@property (nonatomic, readonly) NSInteger snow3hours;
@property (nonatomic, readonly) CGFloat tempCurrent;
@property (nonatomic, readonly) CGFloat tempMin;
@property (nonatomic, readonly) CGFloat tempMax;
@property (nonatomic, readonly) NSInteger windDirection;
@property (nonatomic, readonly) CGFloat windSpeed;

// Methods
// =======

-(void)getCurrentWeatherWithCityName:(NSString *)cityName withCompletion:(void (^)(BOOL success))completionBlock;
-(void)getCurrentWeatherWithLocation:(CLLocationCoordinate2D)location withCompletion:(void (^)(BOOL success))completionBlock;

@end
