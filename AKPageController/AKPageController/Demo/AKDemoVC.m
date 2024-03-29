//
//  AKDemoVC.m
//  AKPageController
//
//  Created by Little.Daddly on 2019/9/4.
//  Copyright © 2019 wangwz. All rights reserved.
//

#import "AKDemoVC.h"
#import "AKFeaturedVC.h"
#import "AKCommonVC.h"
@interface AKDemoVC ()

@end

@implementation AKDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


/** 运行数据命令 */
//- (void)AKHomeDataSourceExe{
//}

/** 数据返回处理 */
- (void)AKHomeDataSourceDealHomeMainView:(AKHomeMainView *)homeView
                            cSquenceView:(AKChannelSquenceView *)cSquenceView{
    AKChannelSquenceModel *sM;
    {
        sM = [AKChannelSquenceModel new];
        
        NSArray *d = @[@"精选",@"小欢喜",@"电视剧",@"电影",@"综艺",@"少儿",@"芒果"];
        NSMutableArray *marr = NSMutableArray.new;
        for (NSString *s in d) {
            AKChannelListModel *m = AKChannelListModel.new;
            m.name = s;
            m.unselectedColor = @"#FFFFFFCC";
            m.columOfBgImg = @"";
            
            if ([s isEqualToString:@"小欢喜"]) {
                /** 选中的颜色 */
                m.selectedColor = @"#5B8C3F";
                /** 选中时候 其它频道的颜色 */
                m.unselectedColor = @"#EFEF67CC";
                //                        m.picSize = @"8";
                m.columOfBgImg = @"privacyTop";
            } else if ([s isEqualToString:@"电影"]) {
                m.selectedChannelIconUrl = @"big_collection_sel";
                m.selectedPicSize = @"48*48";
            } else if ([s isEqualToString:@"电视剧"]) {
                m.channelIconUrl = @"ak_ sel_praise";
                m.picSize = @"17*17";
            }
            /** 设置默认选中背景图 */
            
            [marr addObject:m];
        }
        
        [sM defaultSetup];
        sM.channelList = marr.copy;
    }
    
    cSquenceView.model = sM;
    
    self.channelModel = sM;
//    homeView.channelSquenceModel = sM;
    [homeView configureData];
    [cSquenceView scroToChannelSquenceIndex:0];//后台数据传来 自动选中0
}
/**
 重新布局
 
 @param homeView 底部滚动视图
 @param cSquenceView 顶部滚动视图
 */
//- (void)resetLayoutHomeMainView:(AKHomeMainView *)homeView
//                   cSquenceView:(AKChannelSquenceView *)cSquenceView{
//}

- (NSArray<AKHomeBaseVC *> *)configureViewControllerData{
    AKChannelSquenceModel *_channelSquenceModel = self.channelModel;
    NSInteger subVC_count = _channelSquenceModel.channelList.count;
    NSMutableArray *a = NSMutableArray.new;
    for (int i =0 ; i < subVC_count; i++) {
        AKHomeBaseVC *vc;
        if (i == 0) {
            vc = [[AKFeaturedVC alloc] initWithModel:_channelSquenceModel.channelList[i]];
        } else {
            vc = [[AKCommonVC alloc] initWithModel:_channelSquenceModel.channelList[i]];
        }
        vc.view.backgroundColor = [UIColor union_colorWithR:i*10 + 100 G:i*10 + 100 B:i*10 + 100];
        [a addObject:vc];
    }
    return a.copy;
}
@end
