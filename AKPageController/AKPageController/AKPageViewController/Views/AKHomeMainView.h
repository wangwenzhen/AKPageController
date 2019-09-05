//
//  AKHomeMainView.h
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKChannelSquenceModel.h"
#import "AKHomeBaseVC.h"
@protocol AKHomeMainViewDelegate <NSObject>
/** 滚动下标处理 */
- (void)pagerViewTransitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;
/** 选中下标处理 */
- (void)pagerViewTransitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated needScorllExAction:(BOOL)needScorllExAction;
/** vc数据源 */
- (NSArray <AKHomeBaseVC *>*)configureViewControllerData;

@end



NS_ASSUME_NONNULL_BEGIN

@interface AKHomeMainView : UIView
/** 主体内容滚动 */
@property (nonatomic,strong) RACSubject *scroDidSubject;

@property (nonatomic,weak) __kindof UIViewController <AKHomeMainViewDelegate> *pageDelegate;
@property (nonatomic,strong) id channelSquenceModel;
@property (nonatomic,strong) RACSubject *scringSubject;
/** 必须使用 才会有数据*/
- (void)configureData;

- (void)scroToPage:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
