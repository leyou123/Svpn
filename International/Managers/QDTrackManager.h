//
//  QDTrackManager.h
//
//  Created by hzg on 2021/5/7.
//

#import <Foundation/Foundation.h>

// 统计特征
typedef NS_ENUM(NSInteger, QDTrackType) {
    
    // 开始连接节点，node_id为节点id
    QDTrackType_connect_start,
    
    // 连接节点失败
    QDTrackType_connect_fail,
    
    // VPN 配置安装失败/或隧道异常
    QDTrackType_connect_fail_tunnel,
    
    // VPN 节点注册
    QDTrackType_connect_fail_node_register,
    
    // 验证连接后是否能够访问测试网址 失败
    QDTrackType_connect_fail_test_connect,
    
    // 连接超时
    QDTrackType_connect_timeout,
    
    // 连接节点成功
    QDTrackType_connect_suc,
    
    // 连接节点取消
    QDTrackType_connect_cancel,
    
    // ping结果上报，成功时，可通过delay上报延迟时间
    QDTrackType_ping,
    
    // 弃用。网速上报，可通过delay上报网速（kB/s)，连接成功后1分钟上报一起，之后每10分钟上报一次
    QDTrackType_network_speed,
    
    //  app启动
    QDTrackType_app_start,
    
    // app初始化完成，用户可点击连接按钮
    QDTrackType_app_inited,
    
    // 用户在节点列表界面中选择了什么节点
    QDTrackType_select_node,
    
    // 用户在节点列表界面中选择了什么按钮
    QDTrackType_app_button,
    
    // cms连接开始
    QDTrackType_connect_cms_start,
    
    // cms连接成功
    QDTrackType_connect_cms_suc,
    
    // cms连接失败
    QDTrackType_connect_cms_fail,
    
    // 安装vpn配置开始
    QDTrackType_install_config_start,
    
    // 安装vpn配置失败
    QDTrackType_install_config_fail,
    
    // 安装vpn配置成功
    QDTrackType_install_config_suc,
    
    // 选择或停留在试用节点页面
    QDTrackType_select_trial_tab,
    
    // 选择或停留在vip节点页面
    QDTrackType_select_vip_tab,
    
    // 节点评分
    QDTrackType_rate_node,
    
    // 分享成功
    QDTrackType_share_success,
    
    // 兑换成功
    QDTrackType_redmeem_success,
    
    // 兑换失败
    QDTrackType_redmeem_fail,
    
    // 推送打开事件
    QDTrackType_PushMessage,
};

// 按钮类型
typedef NS_ENUM(NSInteger, QDTrackButtonType) {
    
    // 点击隐私协议的Accept&close
    QDTrackButtonType_0,
    
    // 点击引导页的Next
    QDTrackButtonType_1,
    
    // 点击引导页的Restore
    QDTrackButtonType_2,
    
    // 点击引导页的Use as a Basic Member
    QDTrackButtonType_3,
    
    // 点击引导页的Terms of Service按钮
    QDTrackButtonType_4,
    
    // 点击引导页的Privacy Policy按钮
    QDTrackButtonType_5,
    
    // 点击主页的连接按钮
    QDTrackButtonType_6,
    
    // 点击主页的节点按钮
    QDTrackButtonType_7,
    
    // 点击主页的交叉推广
    QDTrackButtonType_8,
    
    // 点击主页的交叉推广的关闭按钮
    QDTrackButtonType_9,
    
    // 点击tabbar的主页按钮
    QDTrackButtonType_10,
    
    // 点击tabbar的订阅按钮
    QDTrackButtonType_11,
    
    // 点击tabbar的个人中心按钮
    QDTrackButtonType_12,
    
    // 点击订阅界面的instruction按钮
    QDTrackButtonType_13,
    
    // 点击订阅界面的Restore按钮
    QDTrackButtonType_14,
    
    // 点击订阅界面的30天按钮
    QDTrackButtonType_15,
    
    // 点击订阅界面的90天按钮
    QDTrackButtonType_16,
    
    // 点击订阅界面的180天按钮
    QDTrackButtonType_17,
    
    // 点击订阅界面的180天按钮
    QDTrackButtonType_18,
    
    // 点击instruction界面的月度按钮
    QDTrackButtonType_19,
    
    // 点击instruction界面的季度按钮
    QDTrackButtonType_20,
    
    // 点击instruction界面的半年按钮
    QDTrackButtonType_21,
    
    // 点击instruction界面的年按钮
    QDTrackButtonType_22,
    
    // 点击instruction界面的ok按钮
    QDTrackButtonType_23,
    
    // 点击instruction界面的restore按钮
    QDTrackButtonType_24,
    
    // 点击instruction界面的Terms of Service按钮
    QDTrackButtonType_25,
    
    // 点击instruction界面的Privacy Policy按钮
    QDTrackButtonType_26,
    
    // 点击instruction界面的关闭按钮
    QDTrackButtonType_27,
    
    // 点击个人中心界面的购买记录
    QDTrackButtonType_28,
    
    // 点击个人中心界面的评分
    QDTrackButtonType_29,
    
    // 点击节点界面底部付费按钮
    QDTrackButtonType_30,
    
    // 点击加时间按钮
    QDTrackButtonType_31,
    
    // 点击个人中心界面的FAQ
    QDTrackButtonType_32,
    
    // 点击个人中心界面的检查更新
    QDTrackButtonType_33,
    
    // 点击个人中心分享按钮
    QDTrackButtonType_34,
    
    // 点击个人中心兑换按钮
    QDTrackButtonType_35,
    
    // 点击分享页分享按钮
    QDTrackButtonType_36,
    
    // 点击推送弹窗的确定按钮
    QDTrackButtonType_37,
    
    // 点击instruction界面的周按钮
    QDTrackButtonType_38

};

// 声明全局的字典，用于将枚举APIType和对应的URL关联起来
#define QDTrackName @{\
    [NSNumber numberWithInteger:QDTrackType_connect_start]:\
    @"connect_start",\
    [NSNumber numberWithInteger:QDTrackType_connect_fail]:\
    @"connect_fail",\
    [NSNumber numberWithInteger:QDTrackType_connect_fail_tunnel]:\
    @"connect_fail_tunnel",\
    [NSNumber numberWithInteger:QDTrackType_connect_fail_node_register]:\
    @"connect_fail_node_register",\
    [NSNumber numberWithInteger:QDTrackType_connect_fail_test_connect]:\
    @"connect_fail_test_connect",\
    [NSNumber numberWithInteger:QDTrackType_connect_timeout]:\
    @"connect_fail_timeout",\
    [NSNumber numberWithInteger:QDTrackType_connect_suc]:\
    @"connect_suc",\
    [NSNumber numberWithInteger:QDTrackType_connect_cancel]:\
    @"connect_cancel",\
    [NSNumber numberWithInteger:QDTrackType_ping]:\
    @"ping", \
    [NSNumber numberWithInteger:QDTrackType_network_speed]:\
    @"network_speed", \
    [NSNumber numberWithInteger:QDTrackType_app_start]:\
    @"app_start", \
    [NSNumber numberWithInteger:QDTrackType_app_inited]:\
    @"app_inited", \
    [NSNumber numberWithInteger:QDTrackType_select_node]:\
    @"select_node", \
    [NSNumber numberWithInteger:QDTrackType_app_button]:\
    @"app_button", \
    [NSNumber numberWithInteger:QDTrackType_connect_cms_start]:\
    @"connect_cms_start",\
    [NSNumber numberWithInteger:QDTrackType_connect_cms_suc]:\
    @"connect_cms_suc",\
    [NSNumber numberWithInteger:QDTrackType_connect_cms_fail]:\
    @"connect_cms_fail",\
    [NSNumber numberWithInteger:QDTrackType_install_config_start]:\
    @"install_config_start",\
    [NSNumber numberWithInteger:QDTrackType_install_config_fail]:\
    @"install_config_fail",\
    [NSNumber numberWithInteger:QDTrackType_install_config_suc]:\
    @"install_config_suc",\
    [NSNumber numberWithInteger:QDTrackType_select_trial_tab]:\
    @"select_trial_tab",\
    [NSNumber numberWithInteger:QDTrackType_select_vip_tab]:\
    @"select_vip_tab",\
    [NSNumber numberWithInteger:QDTrackType_rate_node]:\
    @"node_rate",\
    [NSNumber numberWithInteger:QDTrackType_PushMessage]:\
    @"push_message"}


NS_ASSUME_NONNULL_BEGIN

@interface QDTrackManager : NSObject

// 统计事件
+ (void) track:(QDTrackType)trackType data:(NSDictionary*)dict;
+ (void) track_node:(NSString*)nodeName;
+ (void) track_rate_node:(NSString*)nodeName rate:(int)rate;
+ (void) track_button:(QDTrackButtonType)buttonType;

@end

NS_ASSUME_NONNULL_END
