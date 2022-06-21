//
//  QDAddressItem.h
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDAddressItem : NSObject

@property (nonatomic, copy, readonly) NSString * _Nonnull hostName;
/// average delay time
@property (nonatomic, assign, readonly) double delayMillSeconds;

@property (nonatomic, strong) NSMutableArray * _Nullable delayTimes;

- (instancetype _Nonnull )initWithHostName:(NSString *_Nullable)hostName;

@end

NS_ASSUME_NONNULL_END
