//
//  RecordViewController.m
//  vpn
//
//  Created by hzg on 2020/12/23.
//

#import "QDRecordViewController.h"
#import "QDNoneRecordView.h"
//#import "YJSubscribeViewController.h"
#import "QDOrderRecordResultModel.h"
#import "QDOrderRecordModel.h"
#import "QDRecordTableViewProxy.h"
//#import "CSLYVIPViewController.h"
#import "QDRefreshNormalHeader.h"
#import "QDSizeUtils.h"

@interface QDRecordViewController () {
    int _currentPage;
    int _totalPage;
    NSMutableArray* _recordItems;
}

@property (nonatomic, strong) QDRecordTableViewProxy *tableViewProxy;
@property (nonatomic,strong)QDNoneRecordView *noneRecordView;
@end

@implementation QDRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackFrame];
    [self setupTitle:@"RecordTitleName"];
    
    [self.backFrame addSubview:self.noneRecordView];
    [self.noneRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backFrame);
    }];
    [self.noneRecordView setHidden:YES];

    // tableview
    [self.backFrame addSubview:self.tableViewProxy.tableView];
    [self.tableViewProxy.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backFrame);
        make.right.bottom.equalTo(self.backFrame);
    }];
    self.tableViewProxy.tableView.backgroundColor = [UIColor clearColor];
    self.tableViewProxy.tableView.showsVerticalScrollIndicator = NO;
    __weak typeof(self) weakSelf = self;
    self.tableViewProxy.tableView.mj_header = [QDRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->_currentPage = 1;
        [strongSelf requestPurchaseRecords:strongSelf->_currentPage completed:^(NSArray *array, int size, BOOL success) {
            if (success) {
                strongSelf->_totalPage = size;
                strongSelf->_recordItems = [NSMutableArray arrayWithArray:array];
                [strongSelf setTableViewData:strongSelf->_recordItems];
                [strongSelf.tableViewProxy.tableView.mj_footer resetNoMoreData];
            }
            [strongSelf.tableViewProxy.tableView.mj_header endRefreshing];
        }];
    }];

    self.tableViewProxy.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf->_currentPage > strongSelf->_totalPage - 1) {
            [strongSelf.tableViewProxy.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        if (strongSelf->_currentPage < 0) {
            strongSelf->_currentPage = 1;
        }
        strongSelf->_currentPage += 1;
        [strongSelf requestPurchaseRecords:strongSelf->_currentPage completed:^(NSArray *array, int size, BOOL success) {
            if (success) {
                strongSelf->_totalPage = size;
                [strongSelf->_recordItems addObjectsFromArray:array];
                [strongSelf setTableViewData:strongSelf->_recordItems];
            } else {
                strongSelf->_currentPage -= 1;
            }
            [strongSelf.tableViewProxy.tableView.mj_footer endRefreshing];
        }];
    }];
    [self.tableViewProxy.tableView.mj_header beginRefreshing];
    
    // 当前页码为0
    _currentPage = 0;
    _recordItems = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!QDConfigManager.shared.activeModel||QDConfigManager.shared.activeModel.member_type != 1) {
        CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
        [QDAdManager.shared showBanner:self toBottom:toBottom];
    }
}

- (void)dealloc {
    NSLog(@"RecordViewController dealloc");
}

- (void) requestPurchaseRecords:(int)page completed:(void (^)(NSArray *array, int size, BOOL success)) completed {
    [QDModelManager requestPurchaseRecords:page completed:^(NSDictionary * _Nonnull dictionary) {
        QDOrderRecordResultModel* resultModel = [QDOrderRecordResultModel mj_objectWithKeyValues:dictionary];
        NSArray* temp = @[];
        BOOL success = NO;
        int tempSize = 0;
        if (resultModel.code == kHttpStatusCode200) {
            temp = resultModel.data;
            tempSize = resultModel.page_info.pages;
            success = YES;
        } else {
            [SVProgressHUD showErrorWithStatus:resultModel.message];
        }
        completed(temp, tempSize, success);
    }];
}

- (QDNoneRecordView*) noneRecordView {
    if (!_noneRecordView) {
//        __weak typeof(self) weakSelf = self;
        _noneRecordView = [[QDNoneRecordView alloc] initWithFrame:CGRectZero clickBlock:^{
//            __strong typeof(self) strongSelf = weakSelf;
//            [CSLYTrackHelper track:CSLYTrackType_app_button data:@{@"buttonType":@(10)}];
//            CSLYVIPViewController *vc = [[CSLYVIPViewController alloc] init];
//            [strongSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _noneRecordView;
}

- (void) setTableViewData:(NSArray*) array {
    if (!array || array.count == 0) {
        [self.noneRecordView setHidden:NO];
        [self.tableViewProxy.tableView setHidden:YES];
        return;
    }

    NSMutableArray* newArr = [NSMutableArray new];
//    YJOrderRecordModel* model = [YJOrderRecordModel new];
//    model.templateName = @"header";
//    model.goods_name  = @"Subscriptions Details";
//    [newArr addObject:model];
    for (int i = 0; i < array.count; i++) {
        QDOrderRecordModel* model = array[i];
        model.templateName = @"cell";
        model.showline = i != array.count - 1;
        [newArr addObject:model];
    }
    self.tableViewProxy.dataArray = newArr;
    [self.tableViewProxy.tableView reloadData];
}

#pragma mark properties
- (QDRecordTableViewProxy *)tableViewProxy {
    if (!_tableViewProxy) {
        _tableViewProxy = [[QDRecordTableViewProxy alloc] initWithReuseIdentifier:@"YJRecordTableViewCell" configuration:^(QDTableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            [cell configWithData:cellData];
        } action:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            NSLog(@"action!");
        }];
    }
    return _tableViewProxy;
}

@end
