//
//  OrderRecordResultModel.h
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import "QDBaseResultModel.h"
#import "QDPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDOrderRecordResultModel : QDBaseResultModel

@property(nonatomic, copy) NSArray* data;
@property(nonatomic, strong) QDPageModel* page_info;

@end

NS_ASSUME_NONNULL_END
