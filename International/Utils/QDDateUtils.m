//
//  DateUtils.m
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import "QDDateUtils.h"

@implementation QDDateUtils

+ (NSString*)timespToUTCFormat:(NSString* )timesp {
    NSString *timeString = [timesp stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (timeString.length >= 10) {
        NSString *second = [timeString substringToIndex:10];
        NSString *milliscond = [timeString substringFromIndex:10];
        NSString * timeStampString = [NSString stringWithFormat:@"%@.%@",second,milliscond];
        NSTimeInterval _interval=[timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return nil;
}

+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcStr;
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *utcDate = [format dateFromString:utcStr];
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}

+ (NSString *)getLocalDateFormateUTCDate1:(NSString *)utcStr;
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *utcDate = [format dateFromString:utcStr];
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}

// yyyy/MM/dd
+ (NSString *)getLocalDateFormateUTCTimestamp:(long)timestamp {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}

// yyyy-MM-dd HH:mm:ss
+ (NSString *)formatYYMMDDHHMMSSFromUTCTimestamp:(long)timestamp {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}

+ (NSString *)formatHHMMFromUTCTimestamp:(long)timestamp {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm";
    NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}

+(long) getNowUTCTimeTimestamp{
    NSDate *datenow = [NSDate date];
    return (long)[datenow timeIntervalSince1970];
}

+ (NSString *)getTime: (NSInteger)hour andMinute:(NSInteger)minute {
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [greCalendar setTimeZone: timeZone];

    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:[NSDate date]];
    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:hour];
    [dateComponentsForDate setMinute:minute];

    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    long timesp = (long)[dateFromDateComponentsForDate timeIntervalSince1970]*1000;
    return [self formatHHMMFromUTCTimestamp:timesp];
}

+ (long) getLocalZeroTimestamp {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* zerocompents = [cal components:unitFlags fromDate:now];
    // 转化成0晨0点时间
    zerocompents.hour=0;
    zerocompents.minute=0;
    zerocompents.second=0;
    
    // NSdatecomponents转NSdate类型
    NSDate* newdate= [cal dateFromComponents:zerocompents];
    //时间转毫秒的时间戳格式(该时间已经是当天凌晨零点的时刻)
    NSTimeInterval zerointerval = [newdate timeIntervalSince1970];
    return (long) zerointerval;
}

+ (NSString*) formatTimeWithSeconds:(long)seconds {
    NSString* text = @"";
    
    long h = seconds / (60*60);
    long d = seconds / (24*60*60);
 
    NSString* day = NSLocalizedString(@"Time_Days", nil);
    if (d < 2) day = NSLocalizedString(@"Time_Day", nil);
    NSString* hour = NSLocalizedString(@"Time_Hours", nil);
    if (h < 2) hour = NSLocalizedString(@"Time_Hour", nil);
    
    // 分情况显示
    if (d > 0) {
        text = [NSString stringWithFormat:@"%ld %@", d, day];
    } else {
        text = [NSString stringWithFormat:@"%ld %@", h, hour];
    }
    return text;
}

+ (long long)getDurationWithStartTIme:(long long)startTime endTime:(long long)endTime {

    NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:startTime];

    NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
    
    return duration;
}

+ (NSString *)getNowDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]  init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc]  initWithLocaleIdentifier:[[NSLocale preferredLanguages]  objectAtIndex:0]];
    [dateFormatter setLocale:locale];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];

    return dateStr;
}

+ (NSString *)getNowDateTimestamp {
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    // 获取指定时间所在时区与UTC时区的间隔秒数
    NSInteger seconds = [zone secondsFromGMTForDate:[NSDate date]];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] - seconds];
    return timeSp;
}

@end
