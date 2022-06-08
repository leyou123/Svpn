//
//  GoogleOpenAd.h
//  StormVPN
//
//  Created by hzg on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleOpenAd : NSObject

+ (GoogleOpenAd *) shared;

@property(nonatomic, assign) BOOL isShow;

- (BOOL) canPresent;
- (void)requestAppOpenAd;
- (void)tryToPresentAd;

@end

NS_ASSUME_NONNULL_END
