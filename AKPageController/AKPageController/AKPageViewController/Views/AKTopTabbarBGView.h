//
//  AKTopTabbarBGView.h
//  miguaikan
//
//  Created by donghui lv on 2019/8/6.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKChannelSquenceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AKTopTabbarBGView : UIView



- (instancetype)setupModel:(AKChannelSquenceModel *)channelSquenceModel withBgH:(CGFloat)bgH;

-(void)scrollWithOffsetX:(CGFloat)offsetX;

@end

NS_ASSUME_NONNULL_END
