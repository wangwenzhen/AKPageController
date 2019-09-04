//
//  AKChannelSquenceView.h
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTopTabbarBGView.h"
#import "AKChannelSquenceModel.h"
@interface AKChannelSquenceView : UIView

@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, assign) CGFloat progressHeight;   // default 2
@property (nonatomic, assign) CGFloat progressHorEdging; // default 6, if < 0 width + edge ,if >0 width - edge
@property (nonatomic, assign) CGFloat progressVerEdging; // default 0, cover style is 3.
@property (nonatomic,strong) AKTopTabbarBGView *topTabbarBGView;
@property (nonatomic,strong) AKChannelSquenceModel *model;
/** 顶部点击 滚动 */
@property (nonatomic,strong) RACSubject *scroDidSubject;
//@property (nonatomic,strong) RACSignal *channerSingle;
@property (nonatomic,assign) CGPoint preScroP;//上次滚动点
- (void)selToIndex:(NSInteger)index;


- (void)selFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)index sendSingle:(BOOL)isSend animate:(BOOL)isAnimate;

//- (void)scroingByP:(CGPoint)p;
- (void)scroToChannelSquenceName:(NSString *)name;
- (void)scroToChannelSquenceIndex:(NSInteger)idx;

- (void)scrollToItemExtraActionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

- (void)scrollToItemExtraActionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated ;
@end

