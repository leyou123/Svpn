//
//  QuestionRequestModel.h
//  vpn
//
//  Created by hzg on 2020/12/29.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDQuestionRequestModel : QDBaseRequestModel

@property(nonatomic, copy) NSString* describe;
@property(nonatomic, copy) NSString* mail;

@end

NS_ASSUME_NONNULL_END
