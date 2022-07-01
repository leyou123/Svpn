//
//  QDLineTableViewBaseCell.h
//
//  Created by hzg on 2021/1/9.
//

#import "QDTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDLineTableViewBaseCell : QDTableViewCell

// 根据连接人数，来判断拥挤
+ (UIImage*) getDelayImage:(int)connected;

// 根据ping结果，来判断拥挤
+ (UIImage*) getSpeedImage:(int)pingResult;

@end

NS_ASSUME_NONNULL_END
