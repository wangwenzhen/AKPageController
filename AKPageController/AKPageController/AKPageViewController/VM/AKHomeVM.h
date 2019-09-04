//
//  AKHomeVM.h
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AKChannelSquenceModel,
AKHomeWdWaterfallModel,AKHomeWaterfallModel;
NS_ASSUME_NONNULL_BEGIN

@interface AKHomeVM : NSObject
/** 频道数据 */
@property (nonatomic,strong) AKChannelSquenceModel *channelSquenceModel;
/** 网达瀑布流 */
@property (nonatomic,strong) AKHomeWdWaterfallModel *wdWaterfallModel;
/** 华为瀑布流 */
@property (nonatomic,strong) AKHomeWaterfallModel *homeWaterfallModel;

/** 频道请求 */
@property (nonatomic,strong) RACCommand *channelSquenceCommand;
/** 瀑布流 请求 */
@property (nonatomic,strong) RACCommand *i_contentListCommand;

@end

NS_ASSUME_NONNULL_END
