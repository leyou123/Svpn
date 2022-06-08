//
//  QDActivityResultModel.h
//  International
//
//  Created by hzg on 2022/1/17.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QDActivityResultModel : NSObject

@property (nonatomic, assign) NSInteger todayZeroTime; //当日活动的0点时间戳

@property (nonatomic, assign) long watchAdTimes;       //看广告次数

@property (nonatomic, assign) BOOL isBindEmail;        //是否绑定邮箱

@end

