//
//  AKTopTabbarBGView.m
//  miguaikan
//
//  Created by donghui lv on 2019/8/6.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKTopTabbarBGView.h"


@interface AKTopTabbarBGView ()
@property (nonatomic,strong) NSArray *containViews;
@property (nonatomic,strong) UIScrollView *scroV;
@property (nonatomic,assign) CGFloat bgH;
@property (nonatomic,strong) AKChannelSquenceModel *channelSquenceModel;
@end

@implementation AKTopTabbarBGView
- (void)setupModel:(AKChannelSquenceModel *)channelSquenceModel withBgH:(CGFloat)bgH{
    _channelSquenceModel = channelSquenceModel;
    _bgH = bgH;
    [self configureData];
    self.clipsToBounds = NO;
}

-(void)scrollWithOffsetX:(CGFloat)offsetX {
    
    [self.scroV setContentOffset:CGPointMake(offsetX, self.scroV.contentOffset.y) animated:NO];
}

-(void)setChannelSquenceModel:(AKChannelSquenceModel *)channelSquenceModel {
    _channelSquenceModel = channelSquenceModel;
    _scroV.contentSize = CGSizeMake(_channelSquenceModel.channelList.count * UNION_SCREEN_WIDTH, _bgH + [NSObject union_statusBarHeight]);
    [self configureData];
    
}
- (void)configureData{
    NSInteger subVC_count = _channelSquenceModel.channelList.count;
    
    self.scroV.frame = self.bounds;
    [self addSubview:self.scroV];

     NSMutableArray *marr = NSMutableArray.array;
    for (int i =0 ; i < subVC_count; i++) {
 
       AKChannelListModel *model = _channelSquenceModel.channelList[i];
       
       [UIImageView lw_createView:^(__kindof UIImageView *v) {
           [marr addObject:v];
           [self.scroV addSubview:v];
            v.contentMode = UIViewContentModeScaleToFill;
            v.clipsToBounds = YES;
            v.frame = CGRectMake(UNION_SCREEN_WIDTH * i, 0, UNION_SCREEN_WIDTH, self.bgH + [NSObject union_statusBarHeight]);
            if ([model.columOfBgImg hasPrefix:@"http"]) {
                [v sd_setImageWithURL:[NSURL URLWithString:model.columOfBgImg] placeholderImage:nil];
            } else {
                v.image = [UIImage imageNamed:model.columOfBgImg];
            }
        }];
    }
    
    _scroV.clipsToBounds = NO;
}

- (UIScrollView *)scroV{
    if (!_scroV) {
        _scroV = [UIScrollView new];
        _scroV.bounces = NO;
        _scroV.pagingEnabled = YES;
        _scroV.showsVerticalScrollIndicator = NO;
        _scroV.showsHorizontalScrollIndicator = NO;
    }
    return _scroV;
}
@end
