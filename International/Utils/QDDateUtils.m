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
    //  ????????????NSDateComponents??????????????????????????????
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
    // ?????????0???0?????????
    zerocompents.hour=0;
    zerocompents.minute=0;
    zerocompents.second=0;
    
    // NSdatecomponents???NSdate??????
    NSDate* newdate= [cal dateFromComponents:zerocompents];
    //?????????????????????????????????(?????????????????????????????????????????????)
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
    
    // ???????????????
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
    // ??????????????????
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    // ??????????????????????????????????????? UTC/GMT???
    NSDate *nowDate = [NSDate date];
    // ?????????????????????????????????
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // ????????????????????? GMT ??????????????????
    NSInteger interval = [zone secondsFromGMT];
    // ??? GMT ??????????????????????????????????????????????????????
    nowDate = [nowDate dateByAddingTimeInterval:interval];

    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];

    return nowDateString;
}

@end
