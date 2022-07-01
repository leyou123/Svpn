//
//  NodeModel.h
//  vpn
//
//  Created by hzg on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDNodeModel : NSObject

// 节点id
@property(nonatomic, copy) NSString* nodeid;
// 节点名称
@property(nonatomic, copy) NSString* name;
// 主机地址
@property(nonatomic, copy) NSString* host;
@property(nonatomic, copy) NSString* ip;

// (1, "免费线路"),(2, "VIP线路"),(3,"我们推荐VIP线路")
@property(nonatomic, assign) int node_type;
// 快速访问类型  0表示普通  1表示快速
@property(nonatomic, assign) int quick_access;
@property(nonatomic, copy) NSString* des;
// tag
@property(nonatomic, copy) NSString* tag;
// 节点国家
@property(nonatomic, copy) NSString* country;
// 节点状态
@property(nonatomic, assign) BOOL status;
// 节点图片
@property(nonatomic, copy) NSString* image_url;
@property(nonatomic, copy) NSString* circle_image_url;
// 节点连接人数
@property(nonatomic, assign) int connected;
// 节点权重
@property(nonatomic, assign) int weights;

// 主机端口
@property(nonatomic, copy) NSString* port;
// 主机密码
@property(nonatomic, copy) NSString* password;

// 模版名字/cell使用
@property(nonatomic, copy) NSString* templateName;
@property(nonatomic, assign) BOOL showline;

// 节点配置
@property (assign, nonatomic) NSInteger remainMins;

// 节点序号
@property (nonatomic , assign) int cell_id;
// 父节点的id，如果为-1表示该节点为根节点
@property (nonatomic , assign) int cell_parentId;
// 该节点是否处于展开状态
@property (nonatomic , assign) BOOL cell_expand;
// 节点类型：-1表示未分配 0表示自动推荐节点 1表示section, 2表示normal  3表示可展开收缩的 4表示 5表示解锁引导单元
@property (nonatomic, assign) NSInteger cell_type;
// 改节点是否隐藏
@property (nonatomic , assign) BOOL isHidden;

// 测试网址
@property(nonatomic, copy) NSString* test_url;

// 节点携带数据
@property(nonatomic, strong) NSArray* subNodes;

// ping结果
@property (nonatomic, assign) int pingResult;

@end

NS_ASSUME_NONNULL_END
