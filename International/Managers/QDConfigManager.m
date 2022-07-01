//
//  ConfigHelper.m
//  vpn
//
//  Created by hzg on 2020/12/14.
//

#import "QDConfigManager.h"
#import "QDDeviceUtils.h"
#import "QDPayViewController.h"
#import "AESCipher.h"
#import "QDSupPingManager.h"
#import "NENPingManager.h"
#import "QDDateUtils.h"
#import "QDModelManager.h"
#import "QDVPNConnectCheck.h"
#import "QDNodeTestModel.h"

static NSString *const kUUIDKey = @"uuid";
static NSString *const kNodeIdKey = @"key_nodeid";
static NSString *const kTodayKey = @"key_today";
static NSString *const kCommitIssueKey = @"key_commit_issue";

// 本地一键注册的uid
static NSString *const kLocalUIDKey = @"key_local_uid";

// 邮箱&密码
static NSString *const kEmailKey    = @"key_email";
static NSString *const kPasswordKey = @"key_password";

@interface QDConfigManager()

@property (nonatomic, strong) NSMutableArray * addressList;

@property (nonatomic, strong) NSMutableArray * pingResultList;

@property (nonatomic, strong) NENPingManager * pingManager;

@end

@implementation QDConfigManager

+ (QDConfigManager *) shared {
    static dispatch_once_t onceToken;
    static QDConfigManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDConfigManager new];
        [instance loadConfig];
    });
    return instance;
}

- (void) loadConfig {
    //  @"9A62085E-7897-4CC5-A79B-2B6157C3393F"
    _UUID = [QDDeviceUtils getContentFromKeyChain:kUUIDKey];
    BOOL isEmpty = (!_UUID || _UUID.length == 0);
    if (isEmpty) {
        _UUID = [[NSUUID UUID] UUIDString];
        [QDDeviceUtils setContentFromKeyChain:_UUID forKey:kUUIDKey];
    }
    _isNewUser = isEmpty;
    _userEventDict = [NSMutableDictionary new];
    
    _isAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAccepted"];
    _isNoneFirstEnterApp = _isAccepted;
    
    _isCommitIssue = [[NSUserDefaults standardUserDefaults] boolForKey:kCommitIssueKey];
    
    self.currentUrlIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentUrlIndex"];
    
    NSString* node_id = [[NSUserDefaults standardUserDefaults] stringForKey:kNodeIdKey];
    if (node_id) {
        _node_id = node_id;
    }
    
    _key = aesEncryptString(ASE_SOLT, ASE_KEY);
    _local_UID = [[NSUserDefaults standardUserDefaults] integerForKey:kLocalUIDKey];
    if (_UID <= 0) _UID = -1;
    if (_local_UID <= 0) _local_UID = -1;
    
    _email = [[NSUserDefaults standardUserDefaults] stringForKey:kEmailKey];
    _password = [[NSUserDefaults standardUserDefaults] stringForKey:kPasswordKey];
}

- (void) setIsAccepted:(BOOL)isAccepted {
    [[NSUserDefaults standardUserDefaults] setBool:isAccepted forKey:@"isAccepted"];
    _isAccepted = isAccepted;
    _isNoneFirstEnterApp = _isAccepted;
}

- (void) setFailTimes:(NSInteger)failTimes {
    if (failTimes > 5) {
        _failTimes = 0;
        self.currentUrlIndex += 1;
    } else {
        _failTimes = failTimes;
    }
}

- (void) setCurrentUrlIndex:(NSInteger)currentUrlIndex {
    _currentUrlIndex = currentUrlIndex % HOST_URLs.count;
    [[NSUserDefaults standardUserDefaults] setInteger:_currentUrlIndex forKey:@"currentUrlIndex"];
}

- (NSString*) currentUrl {
    return HOST_URLs[self.currentUrlIndex];
}

- (void) setNode_id:(NSString *)node_id {
    _node_id = node_id;
    [[NSUserDefaults standardUserDefaults] setValue:node_id forKey:kNodeIdKey];
}

// 节点改变
- (void) setNode:(QDNodeModel *)node {
    _node = node;
    self.node_id = node.nodeid;
}

- (void)setNodes:(NSArray<QDNodeModel *> *)nodes {
    _nodes = nodes;
}

- (void)setTestNodes:(NSArray<QDNodeModel *> *)testNodes {
    _testNodes = testNodes;
}

// 节点列表预处理
- (void) preprogressNodes {
        
    [self.allVipNodes removeAllObjects];
    [self.allFreeNodes removeAllObjects];
    
    // 未激活
    if (!self.nodes || self.nodes.count == 0) {
        self.freeNodes = @[];
        self.vipNodes = @[];
        return;
    }
    
    // 开启全部ping
    [self startPing];
    
    NSMutableArray* freeNodes = [NSMutableArray new];
    NSMutableArray* vipNodes = [NSMutableArray new];
    
    // 节点分类
    for (QDNodeModel* m in self.nodes) {
        m.cell_type = 2;
        if (m.node_type == 1) {
            [self.allFreeNodes addObject:m];
        } else {
            [self.allVipNodes addObject:m];
        }
    }
    
    NSArray * freeSort = [[self getSortArray:self.allFreeNodes hide:NO] subarrayWithRange:NSMakeRange(0, 5)];
    [freeNodes addObjectsFromArray:freeSort];
    
    NSArray * vipSort = [self getSortArray:self.allVipNodes hide:QDConfigManager.shared.lineHide];
    [vipNodes addObjectsFromArray:vipSort];
    
    self.allVipNodes = vipNodes;
    
    // 添加解锁节点引导
    if (self.activeModel&&self.activeModel.member_type != 1) {
        QDNodeModel* unlockNode = [QDNodeModel new];
        unlockNode.cell_type = 5;
        [freeNodes addObject:unlockNode];
    }
    
    // 添加标题cell
    QDNodeModel* freeLineTitleNode = [QDNodeModel new];
    freeLineTitleNode.name = NSLocalizedString(@"LineAuto", nil);
    freeLineTitleNode.cell_type = 1;
    [freeNodes insertObject:freeLineTitleNode atIndex:0];
    
    self.freeNodes = freeNodes;
    if (self.freeNodes.count >= 2) {
        self.freeNodes[1].cell_type = 0;
    }
    
    // vip nodes
    NSMutableArray* arr = [NSMutableArray new];
    
    // 所有节点类型重置为normal
    for (QDNodeModel* m in vipNodes) {
        m.cell_type = 2;
    }
    
    // 快速访问节点
    NSMutableArray* quickAccessArr   = [NSMutableArray new];
    
    // other
    NSMutableArray* noquickAccessArr = [NSMutableArray new];
    
    // 塞选快速访问节点
    for (QDNodeModel* m in vipNodes) {
        if (m.quick_access == 1) {
            [quickAccessArr addObject:m];
        } else {
            [noquickAccessArr addObject:m];
        }
    }
    
    // 判断会员类型
    // 正式会员，从会员节点中选择3个排序最高的节点，除快捷访问的节点
    // 推荐节点，最多3个推荐节点
    int recommandMaxNum = 2;
    
    QDNodeModel* virtureNode = [QDNodeModel new];
    virtureNode.name = NSLocalizedString(@"LineAuto", nil);
    virtureNode.cell_type = 1;
    [arr addObject:virtureNode];
    
    // 正式会员
    NSMutableArray* recommandVipNodes = [self getNodes:noquickAccessArr num:recommandMaxNum type:2];
    for (QDNodeModel* m in recommandVipNodes) {
        m.cell_type = 0;
        [arr addObject:m];
    }
    // 删除节点
//    [noquickAccessArr removeObjectsInArray:recommandVipNodes];
    
    // 快捷访问节点
    // 塞选快速访问节点列表
    if (quickAccessArr.count > 0) {
        QDNodeModel* virtureNode = [QDNodeModel new];
        virtureNode.name = NSLocalizedString(@"LineQuickAccess", nil);
        virtureNode.cell_type = 1;
        [arr addObject:virtureNode];
        
        for (QDNodeModel* n in quickAccessArr) {
            [arr addObject:n];
        }
    }
    
    // 国家
    if (vipNodes.count > 0) {
        QDNodeModel* virtureNode = [QDNodeModel new];
        virtureNode.name = NSLocalizedString(@"LineLocations", nil);
        virtureNode.cell_type = 1;
        [arr addObject:virtureNode];
        
        // 节点按国家归拢
        NSMutableArray<QDNodeModel*>* unitedStatesArr   = [NSMutableArray new];
        NSMutableDictionary* locationDict = [NSMutableDictionary new];
        for (QDNodeModel* m in vipNodes) {
            if ([m.country isEqual:@"America"] || [m.country isEqual:@"United States"] || [m.country isEqual:@"U.S."]) {
                [unitedStatesArr addObject:m];
                continue;
            }
            NSMutableArray* country = locationDict[m.country];
            if (!country) {
                locationDict[m.country] = [NSMutableArray new];
            }
            [locationDict[m.country] addObject:m];
        }
        
        // 按国家排序，美国置顶
        NSArray* locationKeys = locationDict.allKeys;
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
            NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString *obj1,NSString *obj2){
            NSRange range = NSMakeRange(0, obj1.length);
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        };
        NSArray* sortArray = [locationKeys sortedArrayUsingComparator:sort];
        
        // 美国
        if (unitedStatesArr.count > 0) {
            QDNodeModel* virtureNode = [QDNodeModel new];
//            virtureNode.name = [NSString stringWithFormat:@"%@(%ld)", unitedStatesArr[0].country, unitedStatesArr.count];
            virtureNode.name = [NSString stringWithFormat:@"%@", unitedStatesArr[0].country];
            virtureNode.country = unitedStatesArr[0].country;
            virtureNode.circle_image_url = unitedStatesArr[0].circle_image_url;
            virtureNode.image_url = unitedStatesArr[0].image_url;
            virtureNode.cell_type = 3;
            virtureNode.subNodes = unitedStatesArr;
            [arr addObject:virtureNode];
        }
        
        // 其它国家
        for (NSString* country in sortArray) {
            NSArray<QDNodeModel*>* nodes = locationDict[country];
            QDNodeModel* virtureNode = [QDNodeModel new];
//            virtureNode.name = [NSString stringWithFormat:@"%@(%ld)", country, nodes.count];
            virtureNode.name = [NSString stringWithFormat:@"%@", country];
            virtureNode.country = country;
            virtureNode.circle_image_url = nodes[0].circle_image_url;
            virtureNode.image_url = nodes[0].image_url;
            virtureNode.cell_type = 3;
            virtureNode.subNodes = locationDict[country];
            [arr addObject:virtureNode];
        }
    }
    
    self.vipNodes  = arr;
}

- (void)startPing {
    NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ping"];
    if ([QDVPNConnectCheck isVPNOn] && arr.count > 0) {
        [self.pingResultList removeAllObjects];
        [self.pingResultList addObjectsFromArray:arr];
        return;
    }
    
    for (QDNodeModel * node in self.nodes) {
        if (node.ip) {
            [self.addressList addObject:node.ip];
        }
    }
    self.pingManager = [[NENPingManager alloc] init];
    [self.pingManager getFatestAddress:self.addressList requestTimes:3 completionHandler:^(NSString * _Nonnull host, NSArray * _Nullable hostArray) {
        
        [self.pingResultList removeAllObjects];
        [self.pingResultList addObjectsFromArray:hostArray];

        [self pingTestNode];
        
        [[NSUserDefaults standardUserDefaults] setValue:hostArray forKey:@"ping"];
        [[NSUserDefaults standardUserDefaults] setValue:@([QDDateUtils getNowUTCTimeTimestamp]) forKey:@"allpingtime"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:[self getReportData:hostArray] forKey:@"items"];
        if (QDVPNManager.shared.status != NEVPNStatusConnected) {
            [QDModelManager requestFeedBackPing:dic Completed:^(NSDictionary * _Nonnull dictionary) {
                NSLog(@"%@",dictionary);
            }];
        }
    }];
}

- (void)pingTestNode {
    
    NSMutableArray * arr = [NSMutableArray array];
    
    for (QDNodeTestModel * testNode in self.testNodes) {
        if (testNode.ip) {
            [arr addObject:testNode.ip];
        }
    }
    if (arr.count == 0) {
        return;
    }
    [self.pingManager getFatestAddress:arr requestTimes:3 completionHandler:^(NSString * _Nonnull host, NSArray * _Nullable hostArray) {
        
        NSDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:[self getTestReportData:hostArray] forKey:@"test_results"];
        if (QDVPNManager.shared.status != NEVPNStatusConnected) {
            [QDModelManager requestTestNode:dic complete:^(NSDictionary * _Nonnull dictionary) {
                
            }];
        }
    }];
}

//
- (NSArray *)getReportData:(NSArray *)arr {
    NSMutableArray * array = [NSMutableArray array];
    for (QDNodeModel * node in self.nodes) {
        for (NSDictionary * dic in arr) {
            if ([[dic.allKeys firstObject] isEqualToString:node.ip]) {
                NSArray * timesArr = [[dic allValues] firstObject];
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:QDConfigManager.shared.UUID forKey:@"uuid"];
                [dict setValue:node.ip forKey:@"node_ip"];
                [dict setValue:node.name forKey:@"node_name"];
                [dict setValue:[self getPingTime:timesArr order:0] forKey:@"ping_val1"];
                [dict setValue:[self getPingTime:timesArr order:1] forKey:@"ping_val2"];
                [dict setValue:[self getPingTime:timesArr order:2] forKey:@"ping_val3"];
                [dict setValue:@"" forKey:@"ping_result"];
                [dict setValue:[QDDateUtils getNowDateString] forKey:@"ping_time"];
                [array addObject:dict];
            }
        }
    }
    return array;
}

- (NSArray *)getTestReportData:(NSArray *)arr {
    NSMutableArray * array = [NSMutableArray array];
    for (QDNodeTestModel * testNode in self.testNodes) {
        for (NSDictionary * dic in arr) {
            if ([[dic.allKeys firstObject] isEqualToString:testNode.ip]) {
                NSArray * timesArr = [[dic allValues] firstObject];
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:QDConfigManager.shared.UUID forKey:@"uuid"];
                [dict setValue:testNode.ip forKey:@"node_ip"];
                [dict setValue:testNode.name forKey:@"node_name"];
                [dict setValue:[self getPingTime:timesArr order:0] forKey:@"ping_val1"];
                [dict setValue:[self getPingTime:timesArr order:1] forKey:@"ping_val2"];
                [dict setValue:[self getPingTime:timesArr order:2] forKey:@"ping_val3"];
                [dict setValue:[QDDateUtils getNowDateTimestamp] forKey:@"utc_time"];
                [dict setValue:@([QDDateUtils getNowUTCTimeTimestamp]) forKey:@"ping_time"];
                [array addObject:dict];
            }
        }
    }
    return array;
}

// 给线路添加ping结果
- (NSArray *)getSortArray:(NSArray *)arr hide:(BOOL)hide {
    NSMutableArray * array = [NSMutableArray array];
    if (self.pingResultList.count > 0) {
        for (NSDictionary * dic in self.pingResultList) {
            BOOL pingresult = [self getPingresult:[dic allValues].firstObject];
            for (QDNodeModel * node in arr) {
                if ([node.ip isEqualToString:[[dic allKeys] firstObject]]) {
                    node.pingResult = pingresult;
                }
            }
        }
        
        NSMutableArray * successArr = [NSMutableArray array];
        NSMutableArray * failArr = [NSMutableArray array];
        
        for (QDNodeModel * node in arr) {
            if (node.pingResult == 1) {
                [successArr addObject:node];
            }else {
                [failArr addObject:node];
            }
        }
        
        NSSortDescriptor *successSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"weights" ascending:NO];
        [successArr sortUsingDescriptors:[NSArray arrayWithObject:successSortDescriptor]];
        
        NSSortDescriptor *failSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"weights" ascending:NO];
        [failArr sortUsingDescriptors:[NSArray arrayWithObject:failSortDescriptor]];
        
        [array addObjectsFromArray:successArr];
        if (!hide) {
            [array addObjectsFromArray:failArr];
        }
        
        return array;
        
    }else {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"weights" ascending:NO];
        [array addObjectsFromArray:arr];
        [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        return array;
    }
}

// 获取ping结果
- (BOOL)getPingresult:(NSArray *)arr {
    int a = 0;
    for (NSNumber * time in arr) {
        if ([time floatValue] > 0 && [time floatValue] != 1000) {
            a++;
        }
    }
    if (a >= 2) {
        return 1;
    }else {
        return 0;
    }
}
// 获取ping的时长
- (NSString *)getPingTime:(NSArray *)arr order:(int)order {
    id time = arr[order];
    if ([time integerValue] == 1000) {
        return @"";
    }else {
        return [NSString stringWithFormat:@"%@",arr[order]];
    }
}


// 获取指定数量的免费或付费节点
- (NSMutableArray*) getNodes:(NSMutableArray*)source num:(int)num type:(int)type {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (QDNodeModel* n in source) {
        if (num < 0) break;
        if (n.node_type == type) {
            [arr addObject:n];
            num -= 1;
        }
    }
    return arr;
}


// 设置默认节点
- (void) setDefaultNode {
    if (self.otherLinesNodes.count > 0) {
        return;
    }
    // 设置默认节点
    if (!self.node_id || QDVPNManager.shared.status != NEVPNStatusConnected) {
        if (self.activeModel&&self.activeModel.member_type == 1) {
            for (QDNodeModel* node in self.vipNodes) {
                if (node.cell_type == 0) {
                    self.node_id = node.nodeid;
                    break;
                }
            }
        } else {
            for (QDNodeModel* node in self.freeNodes) {
                if (node.cell_type == 0) {
                    self.node_id = node.nodeid;
                    break;
                }
            }
        }
    }

    for (QDNodeModel* node in self.nodes) {
        if ([node.nodeid isEqual:self.node_id]) {
            _node = node;
            break;
        }
    }
    
    if (!_node) {
        // 若处于连接状态，则断开
        if (QDVPNManager.shared.status == NEVPNStatusConnected) [QDVPNManager.shared stop];
        // 设置默认节点
        if (self.activeModel&&self.activeModel.member_type == 1) {
            for (QDNodeModel* node in self.vipNodes) {
                if (node.cell_type == 0) {
                    self.node_id = node.nodeid;
                    _node = node;
                    break;
                }
            }
        } else {
            for (QDNodeModel* node in self.freeNodes) {
                if (node.cell_type == 0) {
                    self.node_id = node.nodeid;
                    _node = node;
                    break;
                }
            }
        }
    }
}

// 是否是同一天，一天之内只提示一次订阅
- (BOOL)isTodayDay {
    //一天之内只提示一次
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //拿到当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //当前时间
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr= [dateFormatter stringFromDate:nowDate];
    //之前时间
    NSString *agoDateStr = [userDefault objectForKey:kTodayKey];
    //判断时间差
    if ([agoDateStr isEqualToString:nowDateStr]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setIsTodayDay:(BOOL)isTodayDay {
    //一天之内只提示一次
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //拿到当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //当前时间
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr= [dateFormatter stringFromDate:nowDate];
    //之前时间
    NSString *agoDateStr = [userDefault objectForKey:kTodayKey];
    //判断时间差
    if ([agoDateStr isEqualToString:nowDateStr]) {
    }else{
        //保存当前时间
        [userDefault setObject:nowDateStr forKey:kTodayKey];
        [userDefault synchronize];
    }
}

- (void)setActiveModel:(QDDeviceActiveModel *)activeModel {
    _activeModel = activeModel;
    self.UID = activeModel.uid;
}


- (void) setLocal_UID:(long)local_UID {
    _local_UID = local_UID;
    [[NSUserDefaults standardUserDefaults] setInteger:local_UID forKey:kLocalUIDKey];
}

- (void)setEmail:(NSString *)email {
    _email = email;
    if (!email || [email isEqual:@""]) {
        _email = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEmailKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:email forKey:kEmailKey];
    }
}

- (void)setPassword:(NSString *)password {
    _password = password;
    if (!password || [password isEqual:@""]) {
        _password = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:kPasswordKey];
    }
}

- (void)setIsCommitIssue:(BOOL)isCommitIssue {
    _isCommitIssue = isCommitIssue;
    [[NSUserDefaults standardUserDefaults] setBool:isCommitIssue forKey:kCommitIssueKey];
}

// 获取当前连接线路外的另两条备用线路
- (void)getOtherTwoLinsWith:(NSString *)ip {
    self.otherLinesNodes = [NSMutableArray array];
    NSArray * arr = [NSArray array];
    if (QDConfigManager.shared.activeModel.member_type == 1) {
        arr = self.allVipNodes;
    }else {
        arr = self.freeNodes;
    }
    for (QDNodeModel * node in arr) {
        if ([node.ip isEqualToString:ip]) {
            self.defaultCountry = node.country;
            if (node.ip) {
                [self.otherLinesNodes insertObject:node atIndex:0];
            }
        }
    }
    for (QDNodeModel * node in arr) {
        if ([node.country isEqualToString:self.defaultCountry]) {
            if (self.otherLinesNodes.count >= 3 || [node.ip isEqualToString:ip]) {
                
            }else {
                if (node.ip) {
                    [self.otherLinesNodes addObject:node];
                }
            }
        }
    }
    if (self.otherLinesNodes.count < 3) {
        for (QDNodeModel * node in arr ) {
            if (![self.otherLinesNodes containsObject:node]) {
                if (self.otherLinesNodes.count >= 3 || [node.ip isEqualToString:ip]) {
                    break;
                }else {
                    if (node.ip) {
                        [self.otherLinesNodes addObject:node];
                    }
                }
            }
        }
    }
    if (self.otherLinesNodes.count > 0) {
        self.node = self.otherLinesNodes[0];
    }
}

// 如果线路连接失败，更新线路
- (QDNodeModel *)connectFailUpdateLines {
    QDNodeModel * node;
    if (self.otherLinesNodes.count > 0) {
        [self.otherLinesNodes removeObjectAtIndex:0];
    }else {
        return nil;
    }
    if (self.otherLinesNodes.count > 0) {
        self.node = self.otherLinesNodes[0];
        node = self.node;
    }else {
        node = nil;
    }
    return self.node;
}

- (NSMutableArray *)addressList {
    if (!_addressList) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}

- (NSMutableArray *)pingResultList {
    if (!_pingResultList) {
        _pingResultList = [NSMutableArray array];
    }
    return _pingResultList;
}

- (NSMutableArray<QDNodeModel *> *)allFreeNodes {
    if (!_allFreeNodes) {
        _allFreeNodes = [NSMutableArray array];
    }
    return _allFreeNodes;
}

- (NSArray<QDNodeModel *> *)allVipNodes {
    if (!_allVipNodes) {
        _allVipNodes = [NSMutableArray array];
    }
    return _allVipNodes;
}

@end
