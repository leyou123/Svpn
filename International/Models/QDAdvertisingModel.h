//
//  QDAdvertisingModel.h
//  International
//
//  Created by hzg on 2021/6/17.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDAdvertisingModel : NSObject

@property(nonatomic, copy) NSString* background_image_url;
@property(nonatomic, copy) NSString* icon;
@property(nonatomic, copy) NSString* skip_url;
@property(nonatomic, copy) NSString* des;
@property(nonatomic, assign) int status;

@end

NS_ASSUME_NONNULL_END
