//
//  AKHomeBaseVC.h
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKChannelSquenceModel.h"
static NSString * const AKHomeWaterfallNotiKey = @"_AKHomeWaterfallNotiKey";//首页瀑布流数据刷新


@interface AKHomeBaseVC : UIViewController

@property (nonatomic,copy) NSString *displayTime;
@property (nonatomic,strong) id listModel;
/** vc所处下标 */
@property (nonatomic,assign) NSInteger idx;
/** 当前展示下标 */
@property (nonatomic,assign) NSInteger displayIdx;

- (instancetype)initWithModel:(id)listModel;

/** 视图将要出现 */
- (void)akViewAppear;
/** 视图将要消失 */
- (void)akViewDisAppear;
/** 提前预加载 目前只是提供预加载 左右2个位置 */
- (void)pullRomoteData:(NSInteger)idx;
@end


