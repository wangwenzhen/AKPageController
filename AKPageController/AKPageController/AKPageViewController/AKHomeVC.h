//
//  AKHomeVC.h
//  miguaikan
//
//  Created by 王文震 on 2019/3/3.
//  Copyright © 2019 cmvideo. All rights reserved.
//


#import "AKHomeMainView.h"
#import "AKChannelSquenceView.h"
#import "AKTopTabbarBGView.h"
@protocol AKHomeVCDataSource <NSObject>
/** 运行数据命令 */
- (void)AKHomeDataSourceExe;
/** 数据返回处理
     self.topTabbarBGView.channelSquenceModel = model;
     self.cSquenceView.model = model;
     self->_channelModel = model;
     self.mainView.channelSquenceModel = model;
 
     [self.cSquenceView scroToChannelSquenceIndex:0];//后台数据传来 自动选中0
 */
- (void)AKHomeDataSourceDealHomeMainView:(AKHomeMainView *)homeView
                            cSquenceView:(AKChannelSquenceView *)cSquenceView;
/**
 重新布局

 @param homeView 底部滚动视图
 @param cSquenceView 顶部滚动视图
 
 */
- (void)resetLayoutHomeMainView:(AKHomeMainView *)homeView
                   cSquenceView:(AKChannelSquenceView *)cSquenceView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface AKHomeVC : UIViewController<AKHomeVCDataSource,AKHomeMainViewDelegate>
@property (nonatomic,strong) AKChannelSquenceModel *channelModel;
- (void)scroToChannelSquenceName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
