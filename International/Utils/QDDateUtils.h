//
//  DateUtils.h
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDDateUtils : NSObject

+ (NSString*)timespToUTCFormat:(NSString* )timesp;

// yyyy-MM-dd HH:mm:ss
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

// yyyy-MM-dd HH:mm
+ (NSString *)getLocalDateFormateUTCDate1:(NSString *)utcDate;

// yyyy/MM/dd
+ (NSString *)getLocalDateFormateUTCTimestamp:(long)timestamp;

// yyyy-MM-dd HH:mm:ss
+ (NSString *)formatYYMMDDHHMMSSFromUTCTimestamp:(long)timestamp;

// HH:mm
+ (NSString *)formatHHMMFromUTCTimestamp:(long)timestamp;

+ (long) getNowUTCTimeTimestamp;

+ (NSString *)getTime: (NSInteger)hour andMinute:(NSInteger)minute;

+ (long) getLocalZeroTimestamp;

+ (NSString*) formatTimeWithSeconds:(long)seconds;

+ (long long)getDurationWithStartTIme:(long long)startTime endTime:(long long)endTime;

+ (NSString *)getNowDateString;

@end

NS_ASSUME_NONNULL_END
