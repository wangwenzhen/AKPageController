//
//  AKHomeVC.m
//  miguaikan
//
//  Created by 王文震 on 2019/3/3.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKHomeVC.h"
#import "AKHomeVM.h"




@interface AKHomeVC ()
@property (nonatomic,strong) AKHomeVM *homeVM;
/** 顶部滑动栏 */
@property (nonatomic,strong) AKChannelSquenceView *cSquenceView;
/** 底部滑动栏 */
@property (nonatomic,strong) AKHomeMainView *mainView;



@property (nonatomic,assign) NSInteger preIndex;//上次对象坐标


@end

@implementation AKHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _preIndex = 0;
    
    
}

- (void)dataConfigure{
    
    if ([self respondsToSelector:@selector(AKHomeDataSourceDealHomeMainView:cSquenceView:)]) {
        
        
        [self AKHomeDataSourceDealHomeMainView:self.mainView
                                  cSquenceView:self.cSquenceView];
        
    } else {
        
        @weakify(self)
        [self.homeVM.channelSquenceCommand.executionSignals.switchToLatest subscribeNext:^(id model) {
            @strongify(self)
            dispatch_async_on_main_queue(^{
                
                if (!model) {
                    
                } else {
                    self.cSquenceView.model = model;
                    
                    self->_channelModel = model;
                    self.mainView.channelSquenceModel = model;

                    [self.cSquenceView scroToChannelSquenceIndex:3];//后台数据传来 自动选中0
                }
            });
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.childViewControllers.count > 0) {
        AKHomeBaseVC *vc = (AKHomeBaseVC *)self.childViewControllers[_preIndex];
        if ([vc respondsToSelector:@selector(akViewAppear)]) {
            [vc akViewAppear];
        }
    }
    
    
    if ([self respondsToSelector:@selector(AKHomeDataSourceExe)]) {
        [self AKHomeDataSourceExe];
    } else {
        if (!self.homeVM.channelSquenceModel) {
            /**
             模拟网络请求
             */
            [self.homeVM.channelSquenceCommand execute:nil];
        }
    }
    
    [self dataConfigure];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.childViewControllers.count > 0) {
        AKHomeBaseVC *vc = (AKHomeBaseVC *)self.childViewControllers[_preIndex];
        if ([vc respondsToSelector:@selector(akViewDisAppear)]) {
            [vc akViewDisAppear];
        }
    }
}

#pragma mark - AKHomeVCDataSource
///** 运行数据命令 */
//- (void)AKHomeDataSourceExe{}
///** 数据返回处理 */
//- (void)AKHomeDataSourceDeal{}


#pragma mark - AKHomeMainView delegate


-(void)pagerViewTransitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    //SquenceView 字体颜色和下划线渐变
    [self.cSquenceView scrollToItemExtraActionFromIndex:fromIndex toIndex:toIndex progress:progress];
    //searchBar 按钮前景色渐变
    UIColor *next_other_uns = [UIColor colorWithHexString:self.channelModel.channelList[toIndex].unselectedColor];
    UIColor *cur_other_uns = [UIColor colorWithHexString:self.channelModel.channelList[fromIndex].unselectedColor];
    NSArray *color_d = [self normalTextColorL:cur_other_uns selectedTextColor:next_other_uns progress:(1-progress)];
//    [self.searchBar setButtonTintColor:color_d.firstObject];
}

-(void)pagerViewTransitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated needScorllExAction:(BOOL)needScorllExAction{

    self.preIndex = toIndex;
    
    @synchronized (self) {
        for (AKHomeBaseVC *vc in self.childViewControllers) {
            vc.displayIdx = self.preIndex;
        }
    }
    
    
    if (self.preIndex >= 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AKHomeWaterfallNotiKey object:nil userInfo:@{@"idx":@(self.preIndex - 1)}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AKHomeWaterfallNotiKey object:nil userInfo:@{@"idx":@(self.preIndex + 1)}];
    
    
//    [self.searchBar setModel:self.channelModel.channelList[toIndex]];
//    if (toIndex == 0) {
//        [self.searchBar hiddenExtraButton:NO];
//    }else {
//        [self.searchBar hiddenExtraButton:YES];
//    }
//

    [self.cSquenceView selFromIndex:fromIndex ToIndex:toIndex sendSingle:NO animate:NO];
    if (needScorllExAction) {
        [self.cSquenceView scrollToItemExtraActionFromIndex:fromIndex toIndex:toIndex animated:YES];
    }
}

- (void)initMainView{
//    @weakify(self)
//    [_mainView.scroDidSubject subscribeNext:^(NSNumber *x) {
//        @strongify(self)
//        self.preIndex = x.integerValue;
//
//        @synchronized (self) {
//            for (AKHomeBaseVC *vc in self.childViewControllers) {
//                vc.displayIdx = self.preIndex;
//            }
//        }
//
//
//        if (self.preIndex >= 1) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:AKHomeWaterfallNotiKey object:nil userInfo:@{@"idx":@(self.preIndex - 1)}];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:AKHomeWaterfallNotiKey object:nil userInfo:@{@"idx":@(self.preIndex + 1)}];
//
//
//        [self.searchBar setModel:self.channelModel.channelList[x.integerValue]];
//        if (x.integerValue == 0) {
//            [self.searchBar hiddenExtraButton:NO];
//        }else {
//            [self.searchBar hiddenExtraButton:YES];
//        }
//
//        [self.cSquenceView selToIndex:x.intValue];
//        @synchronized (self) {
//            self.isAKFeatured = x.intValue == 0 ? YES : NO;
//        }
//
//        if (!self.isAKFeatured) {
//            self.cSquenceView.alpha = self.statusV.alpha
//                                    = 1;
//        } else {
//            AKFeaturedVC *vc = (AKFeaturedVC *)self.childViewControllers.firstObject;
//            if (vc.refreshState == MJRefreshStateRefreshing) {
//                self.cSquenceView.alpha = self.statusV.alpha
//                                        = 0;
//            }
//        }
//    }];
    //先取消
//    [_mainView.scringSubject subscribeNext:^(NSString *x) {
//       @strongify(self)
////        [self.cSquenceView scroingByP:CGPointFromString(x)];
//
//        CGPoint point = CGPointFromString(x);
//        [self.topTabbarBGView scrollWithOffsetX:point.x];
//
//    }];

}
- (void)scroToChannelSquenceName:(NSString *)name {
    [self.cSquenceView scroToChannelSquenceName:name];
}
- (BOOL)hidesBottomBarWhenPushed{
    return NO;
}


- (AKHomeMainView *)mainView{
    if (!_mainView) {
        _mainView = AKHomeMainView.new;
        if ([self respondsToSelector:@selector(resetLayoutHomeMainView:cSquenceView:)]) {
            [self resetLayoutHomeMainView:_mainView cSquenceView:nil];
        } else {
            [self.view addSubview:_mainView];
            [self.view sendSubviewToBack:_mainView];

            _mainView.frame = CGRectMake(0, CGRectGetMaxY(self.cSquenceView.frame) , self.view.union_w, UNION_SCREEN_HEIGHT - self.cSquenceView.union_y - self.cSquenceView.union_h - self.tabBarController.tabBar.union_h);
        }
        _mainView.pageDelegate = self;
    }
    return _mainView;
}
- (AKHomeVM *)homeVM{
    if (!_homeVM) {
        _homeVM = [AKHomeVM new];
    }
    return _homeVM;
}



- (AKChannelSquenceView *)cSquenceView{
    if (!_cSquenceView) {
        _cSquenceView = [AKChannelSquenceView lw_createAddToView:self.view
                                                     blockConfig:^(__kindof AKChannelSquenceView *headV) {
                                           
             if ([self respondsToSelector:@selector(resetLayoutHomeMainView:cSquenceView:)]) {
                 [self resetLayoutHomeMainView:nil cSquenceView:headV];
             } else {
                 headV.frame = CGRectMake(0, [NSObject union_statusBarHeight], self.view.union_w, 46);
             }

            @weakify(self)
            [headV.scroDidSubject subscribeNext:^(NSNumber *x) {
                NSInteger idx = x.integerValue;
                @synchronized (self) {
                    for (AKHomeBaseVC *vc in self.childViewControllers) {
                        vc.displayIdx = idx;
                    }
                }
                
                if (idx >= 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:AKHomeWaterfallNotiKey object:nil userInfo:@{@"idx":@(idx - 1)}];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:AKHomeWaterfallNotiKey object:nil userInfo:@{@"idx":@(idx + 1)}];

                @strongify(self)
                if (self.preIndex != x.integerValue) {
                    
                    if (self.preIndex < self.childViewControllers.count) {
                        AKHomeBaseVC *vc = (AKHomeBaseVC *)self.childViewControllers[self.preIndex];
                        self.preIndex = x.integerValue;
                        if ([vc respondsToSelector:@selector(akViewDisAppear)]) {
                            
                            dispatch_async_on_main_queue(^{
                                [vc akViewDisAppear];
                            });
                        }
                    }
                }
                
                [self.mainView scroToPage:x.integerValue];
//                _scroV.union_offsetX = page * UNION_SCREEN_WIDTH;
                
                
//                [self.searchBar setModel:self.channelModel.channelList[x.integerValue]];
//                if (x.integerValue == 0) {
//                    [self.searchBar hiddenExtraButton:NO];
//                }else {
//                    [self.searchBar hiddenExtraButton:YES];
//                }
                
                if (x.integerValue < self.childViewControllers.count) {
                    AKHomeBaseVC *vc = (AKHomeBaseVC *)self.childViewControllers[x.integerValue];
                    if ([vc respondsToSelector:@selector(akViewAppear)]) {
                        dispatch_async_on_main_queue(^{
                            [vc akViewAppear];
                        });
                    }
                }
                
            }];
        }];
    }
    return _cSquenceView;
}


#pragma mark - private func
- (NSArray *)normalTextColorL:(UIColor *)normalTextColor selectedTextColor:(UIColor *)selectedTextColor progress:(CGFloat)progress{
    CGFloat narR=0,narG=0,narB=0,narA=1;
    [normalTextColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR=0,selG=0,selB=0,selA=1;
    [selectedTextColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    UIColor *fromColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    UIColor *toColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
    return @[fromColor,toColor];
}
@end
