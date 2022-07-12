//
//  ConfigHelper.h
//  vpn
//
//  Created by hzg on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import "QDDeviceActiveModel.h"
#import "QDNodeModel.h"
#import "QDProductModel.h"

//NS_ASSUME_NONNULL_BEGIN

// 全局配置
@interface QDConfigManager : NSObject

+ (QDConfigManager *) shared;

// network isReady
@property (nonatomic, assign) BOOL isNetworkReady;

// 加密key
@property (nonatomic, copy) NSString *key;

// uuid
@property (nonatomic, copy) NSString *UUID;
// 当前的uid
@property (nonatomic, assign) long UID;
// 一键注册的uid
@property (nonatomic, assign) long local_UID;

// 安装后非第一次使用
@property(nonatomic, assign) BOOL isNoneFirstEnterApp;
// 用户是否授权
@property(nonatomic, assign) BOOL isAccepted;
// 第一次进入的用户
@property(nonatomic, assign) BOOL isNewUser;
@property(nonatomic, strong) NSMutableDictionary* userEventDict;

// 是否提交过反馈
@property(nonatomic, assign) BOOL isCommitIssue;

// 用户信息
@property (nonatomic, strong) QDDeviceActiveModel *activeModel;

// 节点信息
@property(nonatomic, strong) NSArray<QDNodeModel*>* nodes;

// 上一次选择的节点id
@property(nonatomic, strong) NSString* node_id;

// 推荐节点
@property(nonatomic, strong) QDNodeModel* node;


// 节点列表预处理
- (void) preprogressNodes;

// 设置默认节点
- (void) setDefaultNode;

// 预处理后的节点
@property(nonatomic, strong) NSArray<QDNodeModel*>* freeNodes;
@property(nonatomic, strong) NSArray<QDNodeModel*>* vipNodes;
@property(nonatomic, strong) NSMutableArray<QDNodeModel*>* otherLinesNodes;
@property(nonatomic, strong) NSMutableArray<QDNodeModel*>* allVipNodes;
@property(nonatomic, strong) NSMutableArray<QDNodeModel*>* allFreeNodes;
@property(nonatomic, strong) NSArray<QDNodeModel*>* testNodes;

// 防封机制
@property (nonatomic, assign) NSInteger failTimes;
@property (nonatomic, assign) NSInteger currentUrlIndex;
@property (nonatomic, strong, readonly) NSString* currentUrl;

// 是否是同一天，一天之内只提示一次订阅
@property (nonatomic, assign) BOOL isTodayDay;

// 剩余时间，单位分钟
@property (nonatomic,assign)long remainMins;

// 剩余时间，单位秒
@property (nonatomic,assign)long remainSeconds;

// 邮箱&密码
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;

/////////////////////////////////////////////////////////////////
// 根据ip获取三条线路
- (void)getOtherTwoLinsWith:(NSString *)ip;

// 连接失败切换下个国家
- (QDNodeModel *)connectFailUpdateLines;

// 选择的国家
@property (nonatomic, copy) NSString *defaultCountry;

// 线路页选择了线路
@property (nonatomic, assign) BOOL lineChanged;

// 是否隐藏线路 1隐藏 0不隐藏
@property (nonatomic, assign) BOOL lineHide;

// 开启全部ping
- (void)startPing:(void(^)(void))complete;

- (NSArray *)getSortArray:(NSArray *)arr hide:(BOOL)hide;

@end

//NS_ASSUME_NONNULL_END
