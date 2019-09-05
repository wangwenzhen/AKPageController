//
//  AKChannelSquenceView.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKChannelSquenceView.h"
#import "UIImageView+AKSDWebAdd.h"
#define minCS_Item_W    50
#define minCS_Item_H    45
//static NSString * const kFontFamily = @"GillSans-SemiBold";
static NSString * const kFontFamily = @"PingFangSC-Medium";
static NSString * const AKItemColorTransfromNoti = @"_AKItemColorTransfromNoti";
@interface AKCSquenceItem : UICollectionViewCell
@property (nonatomic,strong) UILabel *sequenceLb;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,copy) NSString *itemSelectedColor;

@property (nonatomic,copy) void (^selOption)(AKChannelListModel *m);
@property (nonatomic,strong) AKChannelListModel *model;
+ (NSString *)itemId;
@end
@implementation AKCSquenceItem
+ (NSString *)itemId {
    return NSStringFromClass([self class]);
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        _imgV = [UIImageView lw_createAddToView:self.contentView blockConfig:^(__kindof UIImageView *v) {
            v.userInteractionEnabled = YES;
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeZero);
            }];
        }];
        
        _sequenceLb = [UILabel lw_createAddToView:self.contentView blockConfig:^(__kindof UILabel *lb) {
            lb.textAlignment = NSTextAlignmentCenter;
            
        }];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _sequenceLb.frame = self.bounds;
}


- (void)setModel:(AKChannelListModel *)model{
    
    _model = model;
    
    _sequenceLb.text = model.name;

    if (model.isSel) {
        
        if ([model.selectedChannelIconUrl union_isExist]) {
            _sequenceLb.hidden = YES;
            _imgV.hidden = NO;
            NSArray *d = [model.selectedPicSize componentsSeparatedByString:@"*"];
            [_imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                //720 * 1280
                make.size.mas_equalTo(CGSizeMake([d.firstObject floatValue], [d.lastObject floatValue]));
            }];
            
            [_imgV sd_setImageLineAniWithURL:[NSURL URLWithString:model.selectedChannelIconUrl] placeholderImage:nil];
            
        } else {
            _sequenceLb.hidden = NO;
            _imgV.hidden = YES;
            _sequenceLb.textColor = [UIColor colorWithHexString:model.selectedColor];
        
        }
        
        if (model.isStateBarLight) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
        }
        
        if (self.selOption) {
            self.selOption(model);
        }
    } else {
        
        if ([model.channelIconUrl union_isExist]) {
            _sequenceLb.hidden = YES;
            _imgV.hidden = NO;
            NSArray *d = [model.picSize componentsSeparatedByString:@"*"];
            [_imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake([d.firstObject floatValue]/2., [d.lastObject floatValue]/2.));
            }];
            
            [_imgV sd_setImageLineAniWithURL:[NSURL URLWithString:model.channelIconUrl] placeholderImage:nil];
        } else {
            _imgV.hidden = YES;
            _sequenceLb.hidden = NO;
            _sequenceLb.textColor = [UIColor colorWithHexString:model.displayUnselColor];

        }
        
    }
    
}

@end

#define invalidIndex 999

@interface AKChannelSquenceView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineImgView;
@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,assign) int fromIndex;
@property (nonatomic,assign) int curIdx;

@property (nonatomic, strong) NSTimer *timer;
/**
 用来记录是否正在滚动
 */
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

/**
 用来设置偏移量的
 */
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;

/**
 用来记录当前的偏移量
 */
@property (nonatomic, assign) CGFloat scrollOffset;
/**
 用来记录一次移动的起末位置
 */
@property (nonatomic, assign) CGFloat startOffset;
@property (nonatomic, assign) CGFloat endOffset;

@end
@implementation AKChannelSquenceView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];

        _progressHorEdging = 0;
        _progressHeight=3;
        _progressWidth= 14;

        [self initSubview];
        
    }
    return self;
}

- (void)layoutSubViews {
  
    int selectIndex = 0;
    for (int i = 0; i < self.model.channelList.count -1; i++) {
        AKChannelListModel *model = self.model.channelList[i];
        if (model.isSel) {
            selectIndex = i;
            break;
        }
    }

    
}

- (void)initSubview{
    [self addSubview:self.collectionView];
    [self.collectionView lw_AddToView:self blockConfig:^(__kindof UICollectionView *cV) {
        [cV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }];
    
    _bgImgV = [UIImageView lw_createView:^(__kindof UIImageView *v) {
        v.backgroundColor = [UIColor whiteColor];
        
        [self insertSubview:v atIndex:0];
        v.contentMode = UIViewContentModeScaleToFill;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(-[NSObject union_statusBarHeight]);
        }];
    }];
    
    _bgImgV.hidden = YES;
    
    @weakify(self);
    _lineImgView = [UIView lw_createAddToView:self.collectionView blockConfig:^(__kindof UIView *v) {
        v.layer.cornerRadius = self_weak_.progressHeight/2.f;
        v.backgroundColor = [UIColor redColor];
    }];
    
    
}
//FromCell toCell 赋值颜色和字体
-(void)transitionFromCell:(AKCSquenceItem*)fromCell toIndex:(AKCSquenceItem*)toCell animate:(BOOL)animate {
    if (self.model.channelList.count == 0) {
        return;
    }
    NSInteger fromIndex = ((AKChannelListModel*)fromCell.model).idx;
    NSInteger toIndex  = ((AKChannelListModel*)toCell.model).idx;
    CGFloat fromCellselectFontScale;
    
    fromCellselectFontScale = [UIFont systemFontOfSize:self.model.channelList[fromIndex].fontSize.integerValue].pointSize/ [UIFont boldSystemFontOfSize:self.model.channelList[fromIndex].selectedSize.integerValue].pointSize;
    
    void (^animateBlock)(void) = ^{
        if (fromCell) {
            fromCell.sequenceLb.font = [UIFont systemFontOfSize:self.model.channelList[fromIndex].selectedSize.integerValue];
            fromCell.sequenceLb.textColor = [UIColor colorWithHexString:self.model.channelList[fromIndex].displayUnselColor];;
            fromCell.transform = CGAffineTransformMakeScale(fromCellselectFontScale, fromCellselectFontScale);
        }
        if (toCell) {
            toCell.sequenceLb.font = [UIFont boldSystemFontOfSize:self.model.channelList[toIndex].selectedSize.integerValue];;
            toCell.sequenceLb.textColor = [UIColor colorWithHexString:self.model.channelList[toIndex].selectedColor];;
            toCell.transform = CGAffineTransformIdentity;
        }
    };
    
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            animateBlock();
        }];
    }else{
        animateBlock();
    }
  

    
    for (AKCSquenceItem *cell in self.collectionView.visibleCells) {
        [cell setModel:cell.model];
    }
    
//    if (fromCell) {
//        [fromCell setModel:self.model.channelList[fromIndex]];
//    }
//    if (toCell) {
//        [toCell setModel:self.model.channelList[toIndex]];
//    }
}

- (void)transitionFromCell:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    UIColor *next_c = nil;
    UIColor *cur_c = [UIColor colorWithHexString:self.model.channelList[fromIndex].selectedColor];
    UIColor *cur_other_uns = nil;
    UIColor *next_other_uns = nil;

    if (toIndex >= fromIndex) { //向右 获取下个 颜色指标
        
        
        if (fromIndex+1 <= self.model.channelList.count) {
            
            CGFloat c = progress;
            AKCSquenceItem *fromCell = (AKCSquenceItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
            AKCSquenceItem *toCell = (AKCSquenceItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
            //颜色Transform
            next_c = [UIColor colorWithHexString:self.model.channelList[toIndex].selectedColor];
            next_other_uns = [UIColor colorWithHexString:self.model.channelList[toIndex].unselectedColor];
            cur_other_uns = [UIColor colorWithHexString:self.model.channelList[fromIndex].unselectedColor];
            cur_c = [UIColor colorWithHexString:self.model.channelList[fromIndex].selectedColor];
            
            NSArray *color_d = [self normalTextColorL:cur_c selectedTextColor:next_other_uns progress:(1-c)];
            NSArray *color_d2 = [self normalTextColorL:cur_other_uns selectedTextColor:next_c progress:c];
            NSArray *color_d3 = [self normalTextColorL:cur_other_uns selectedTextColor:next_other_uns progress:(1-c)];
            
            
            for (AKCSquenceItem *cell in self.collectionView.visibleCells) {
                if (cell != toCell && cell != fromCell) {
                    cell.sequenceLb.textColor = color_d3.firstObject;
                }
            }
            
            fromCell.sequenceLb.textColor = color_d.firstObject;
            toCell.sequenceLb.textColor = color_d2.lastObject;
            
//             self.bannerBtn.tintColor = color_d3.firstObject;
            
            //
            //字体Transform
            //先不做缩放
            CGFloat fromCellselectFontScale = [UIFont boldSystemFontOfSize:self.model.channelList[fromIndex].fontSize.integerValue].pointSize/ [UIFont boldSystemFontOfSize:self.model.channelList[fromIndex].selectedSize.integerValue].pointSize;
            
            CGFloat toCellselectFontScale = [UIFont boldSystemFontOfSize:self.model.channelList[toIndex].fontSize.integerValue].pointSize/ [UIFont boldSystemFontOfSize:self.model.channelList[toIndex].selectedSize.integerValue].pointSize;
            
            CGFloat fromCellCurrentTransform = (1.0 - fromCellselectFontScale)*progress;
            
            CGFloat toCellCurrentTransform = (1.0 - toCellselectFontScale)*progress;
            
            
            
            
            fromCell.transform = CGAffineTransformMakeScale(1.0-fromCellCurrentTransform, 1.0-fromCellCurrentTransform);
            toCell.transform = CGAffineTransformMakeScale(toCellCurrentTransform+toCellselectFontScale, toCellCurrentTransform+toCellselectFontScale);
            
            if (progress >= 0.98) {
                [self transitionFromCell:fromCell toIndex:toCell animate:NO];
            }
            
            
        }
        
        
        
        
    } else {//向左 获取上个颜色指标
//        if (progress == 1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//
//                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//            });
//
//        }
        if (fromIndex - 1 >= 0) {
            
            CGFloat c = progress;
            AKCSquenceItem *fromCell = (AKCSquenceItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
            AKCSquenceItem *toCell = (AKCSquenceItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
            
            next_c = [UIColor colorWithHexString:self.model.channelList[toIndex].selectedColor];
            next_other_uns = [UIColor colorWithHexString:self.model.channelList[toIndex].unselectedColor];
            cur_other_uns = [UIColor colorWithHexString:self.model.channelList[fromIndex].unselectedColor];
            cur_c = [UIColor colorWithHexString:self.model.channelList[fromIndex].selectedColor];
            
            NSArray *color_d = [self normalTextColorL:cur_c selectedTextColor:next_other_uns progress:(1-c)];
            NSArray *color_d2 = [self normalTextColorL:cur_other_uns selectedTextColor:next_c progress:c];
            
            NSArray *color_d3 = [self normalTextColorL:cur_other_uns selectedTextColor:next_other_uns progress:(1-c)];
            
            
            for (AKCSquenceItem *cell in self.collectionView.visibleCells) {
                if (cell != toCell && cell != fromCell) {
                    cell.sequenceLb.textColor = color_d3.firstObject;
                }
            }
            
            fromCell.sequenceLb.textColor = color_d.firstObject;
            toCell.sequenceLb.textColor = color_d2.lastObject;
//            self.bannerBtn.tintColor = color_d3.firstObject;
            
            //字体Transform
            //先不做缩放
            CGFloat fromCellselectFontScale = [UIFont boldSystemFontOfSize:self.model.channelList[fromIndex].fontSize.integerValue].pointSize/ [UIFont boldSystemFontOfSize:self.model.channelList[fromIndex].selectedSize.integerValue].pointSize;
            
            CGFloat toCellselectFontScale = [UIFont boldSystemFontOfSize:self.model.channelList[toIndex].fontSize.integerValue].pointSize/ [UIFont boldSystemFontOfSize:self.model.channelList[toIndex].selectedSize.integerValue].pointSize;
            
            CGFloat fromCellCurrentTransform = (1.0 - fromCellselectFontScale)*progress;
            
            CGFloat toCellCurrentTransform = (1.0 - toCellselectFontScale)*progress;
            
            
            fromCell.transform = CGAffineTransformMakeScale(1.0-fromCellCurrentTransform, 1.0-fromCellCurrentTransform);
            toCell.transform = CGAffineTransformMakeScale(toCellCurrentTransform+toCellselectFontScale, toCellCurrentTransform+toCellselectFontScale);
            
            if (progress >= 0.98) {
                [self transitionFromCell:fromCell toIndex:toCell animate:NO];
            }
            
        }
    }

}



- (void)selToIndex:(NSInteger)index;{
    //    [self selToIndex:index sendSingle:NO];
    [self selFromIndex:invalidIndex ToIndex:index sendSingle:NO];
}

- (void)scroToChannelSquenceName:(NSString *)name {
    for (int i = 0; i < self.model.channelList.count; i++) {
        AKChannelListModel *m = self.model.channelList[i];
        if ([name isEqualToString:m.name]) {
            [self selFromIndex:invalidIndex ToIndex:i sendSingle:YES];
            //            [self selToIndex:i sendSingle:YES];
        }
    }
}
- (void)scroToChannelSquenceIndex:(NSInteger)idx{
    [self selFromIndex:invalidIndex ToIndex:idx sendSingle:YES];
}


-(void)scrollToItemExtraActionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self setUnderLineFrameWithfromIndex:fromIndex toIndex:toIndex progress:progress];
    
    [self transitionFromCell:fromIndex toIndex:toIndex progress:progress];
}


-(void)scrollToItemExtraActionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self setUnderLineFrameWithIndex:toIndex animated:animated];
    AKCSquenceItem *fromCell = (AKCSquenceItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
    AKCSquenceItem *toCell = (AKCSquenceItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    [self transitionFromCell:fromCell toIndex:toCell animate:animated];
}


- (CGRect)cellFrameWithIndex:(NSInteger)index
{
    if (index < 0) {
        return CGRectZero;
    }
    
    if (index >= self.model.channelList.count ) {
        return CGRectZero;
    }
    UICollectionViewLayoutAttributes * cellAttrs = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (!cellAttrs) {
        return CGRectZero;
    }
    
    return cellAttrs.frame;
}

- (void)setUnderLineFrameWithIndex:(NSInteger)index animated:(BOOL)animated
{
    UIView *progressView = self.lineImgView;
    if (progressView.isHidden || self.model.channelList.count == 0) {
        return;
    }
    
    CGRect cellFrame = [self cellFrameWithIndex:index];
    CGFloat progressHorEdging = _progressWidth > 0 ? (cellFrame.size.width - _progressWidth)/2 : _progressHorEdging;
    CGFloat progressX = cellFrame.origin.x+progressHorEdging;
    CGFloat progressY = (cellFrame.size.height - _progressHeight - _progressVerEdging);
    CGFloat width = cellFrame.size.width-2*progressHorEdging;
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            progressView.frame = CGRectMake(progressX, progressY, width, self->_progressHeight);
        }];
    }else {
        progressView.frame = CGRectMake(progressX, progressY, width, _progressHeight);
    }
    progressView.backgroundColor = [UIColor colorWithHexString:self.model.channelList[index].selectedColor];
}
- (void)setUnderLineFrameWithfromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    //设置frame
    
    UIView *progressView = self.lineImgView;
    
    if (progressView.isHidden || self.model.channelList.count == 0) {
        return;
    }
    
    CGRect fromCellFrame = [self cellFrameWithIndex:fromIndex];
    CGRect toCellFrame = [self cellFrameWithIndex:toIndex];
    
    //竞品的效果
    CGFloat progressFromEdging;
    if (progress<=0.5) {
        progressFromEdging = _progressWidth > 0 ? (fromCellFrame.size.width - _progressWidth * (1-progress*2))/2 : _progressHorEdging;
    }else {
        progressFromEdging = _progressWidth > 0 ? (fromCellFrame.size.width )/2 : _progressHorEdging;
    }
    CGFloat progressToEdging;
    if (progress >0.5) {
        progressToEdging = _progressWidth > 0 ? (toCellFrame.size.width - _progressWidth * (1-(1-progress)*2) )/2 : _progressHorEdging;
    }else {
        progressToEdging = _progressWidth > 0 ? (toCellFrame.size.width )/2 : _progressHorEdging;
    }
    
    
    CGFloat progressY = (toCellFrame.size.height - _progressHeight - _progressVerEdging);
    CGFloat progressX = 0, width = 0;
    
    //之前的效果
//    CGFloat progressFromEdging = _progressWidth > 0 ? (fromCellFrame.size.width - _progressWidth * 1))/2 : _progressHorEdging;
//    CGFloat progressToEdging = _progressWidth > 0 ? (toCellFrame.size.width - _progressWidth * 1)/2 : _progressHorEdging;
//    CGFloat progressY = (toCellFrame.size.height - _progressHeight - _progressVerEdging);
//    CGFloat progressX = 0, width = 0;
    
    
    if (fromCellFrame.origin.x < toCellFrame.origin.x) {
        if (progress <= 0.5) {
            progressX = fromCellFrame.origin.x + progressFromEdging;
            width = (toCellFrame.size.width-progressToEdging+progressFromEdging)*2*progress + fromCellFrame.size.width-2*progressFromEdging;
        }else {
            progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width-progressFromEdging+progressToEdging)*(progress-0.5)*2;
            width = CGRectGetMaxX(toCellFrame)-progressToEdging - progressX;
        }
    }else {
        if (progress <= 0.5) {
            progressX = fromCellFrame.origin.x + progressFromEdging - (toCellFrame.size.width-progressToEdging+progressFromEdging)*2*progress;
            width = CGRectGetMaxX(fromCellFrame) - progressFromEdging - progressX;
        }else {
            progressX = toCellFrame.origin.x + progressToEdging;
            width = (fromCellFrame.size.width-progressFromEdging+progressToEdging )*(1-progress)*2 + toCellFrame.size.width - 2*progressToEdging;
        }
    }
    progressView.frame = CGRectMake(progressX,progressY, width, _progressHeight);
    
    
     if (toIndex >= fromIndex) {
          if (fromIndex+1 <= self.model.channelList.count) {
              CGFloat c = progress;
       
              UIColor* next_s = [UIColor colorWithHexString:self.model.channelList[toIndex].selectedColor];
       
              UIColor* cur_c = [UIColor colorWithHexString:self.model.channelList[fromIndex].selectedColor];
              NSArray *color_d = [self normalTextColorL:cur_c selectedTextColor:next_s progress:(1-c)];
              

              //设置颜色
              progressView.backgroundColor = color_d.firstObject;

          }
         
     }else {
         if (fromIndex - 1 >= 0) {
             
             CGFloat c = progress;
            
             
             UIColor* next_s = [UIColor colorWithHexString:self.model.channelList[toIndex].selectedColor];
             
             UIColor* cur_c = [UIColor colorWithHexString:self.model.channelList[fromIndex].selectedColor];
             NSArray *color_d = [self normalTextColorL:cur_c selectedTextColor:next_s progress:(1-c)];
             
             
             //设置颜色
             progressView.backgroundColor = color_d.firstObject;
             
           
             
             
         }
     }
   
}


- (void)startScrollAnimation{
    if (!_timer)
    {
        self.timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                             target:self
                                           selector:@selector(startScroll)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}
- (CGFloat)easeInOut:(CGFloat)time
{
    return (time < 0.5f)? 0.5f * powf(time * 2.0f, 3.0f) : 0.5f * powf(time * 2.0f - 2.0f, 3.0f) + 1.0f;
}


- (void)setContentOffsetWithoutEvent:(CGPoint)contentOffset
{
    if (!CGPointEqualToPoint(self.collectionView.contentOffset, contentOffset))
    {
        BOOL animationEnabled = [UIView areAnimationsEnabled];
        if (animationEnabled) [UIView setAnimationsEnabled:NO];
    
        self.collectionView.contentOffset = contentOffset;

        if (animationEnabled) [UIView setAnimationsEnabled:YES];
    }
}


- (void)startScroll
{
   
    NSTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
    double delta = _lastTime - currentTime;
    _lastTime = currentTime;
    
    if (_scrolling)
    {
        NSTimeInterval time = fminf(1.0f, (currentTime - _startTime) / 0.25);
        delta = [self easeInOut:time];
        _scrollOffset = (_endOffset - _startOffset) * delta + _startOffset;
      
        [self setContentOffsetWithoutEvent:CGPointMake(_scrollOffset, 0.0f)];
        
        if (time == 1.0f)
        {
            _scrolling = NO;
        }
    }
    else
    {
        [self stopScrollAnimation];
    }
}

- (void)stopScrollAnimation
{
    [_timer invalidate];
    self.timer = nil;
}


- (void)scrollToIndexAnimation:(NSInteger)index {
    
    self.startTime = [[NSDate date] timeIntervalSinceReferenceDate];
    _startOffset = self.collectionView.contentOffset.x;
    _endOffset = [self getFinalContentOffsetXWithIndex:index].x;
    _scrolling = YES;
    [self startScrollAnimation];
    
    
}

- (void)selFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)index sendSingle:(BOOL)isSend animate:(BOOL)isAnimate{
    
    self.fromIndex = (int)fromIndex;
    
    NSString *otherDisplayColor_text = _model.channelList[index].unselectedColor;
    for (int i = 0; i < _model.channelList.count; i++) {
        AKChannelListModel *m = _model.channelList[i];
        if (m.isSel && i != index) {
            m.preSel = YES;
        } else {
            m.preSel = NO;
        }
        
        m.displayUnselColor = otherDisplayColor_text;
        
        m.isSel = i == index ? YES:NO;
        m.exfontSize = i == index ? 21:15;
    }
    
    
    {
        //设置右边更多分类按钮
//        self.bannerBtn.tintColor = [UIColor colorWithHexString:_model.channelList[index].unselectedColor];
//
//        [self.bannerBtn setImage:[self.bannerBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        
        
//        [self.bgImgV sd_setImageLineAniWithURL:[NSURL URLWithString:_model.channelList[index].columOfBgImg] placeholderImage:nil];
    }
    
    
    NSInteger num = [self.collectionView numberOfItemsInSection:0];
    if (num - 1 >= index) {
        

        dispatch_async(dispatch_get_main_queue(), ^{
            
            //触发滚动
            [self scrollToIndexAnimation:index];
           
            if (isSend) {
                [self.scroDidSubject sendNext:@(index)];
                [self.topTabbarBGView scrollWithOffsetX:index*self.union_w];
            }
            
            
        });
        
    }
    
//    if (_model.selectedColor) {
//        //        [_bannerBtn setBackgroundColor:[UIColor union_colorWithHex:0x212121]];
//        //        [_bannerBtn setImage:[[UIImage imageNamed:@"channelBtnImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];//MyShareCardBG
//        //        [_bannerBtn setTintColor:[UIColor colorWithHexString:_model.selectedColor]];
//        //
//        //        AKChannelListModel *m = _model.channelList[index];
//        //        [_shadow sd_setImageWithURL:[NSURL URLWithString:m.columOfBgImg] placeholderImage:nil];
//        //        [self insertSubview:_shadow atIndex:0];
//
//        NSDictionary *dict = @{@"selectedColor":_model.selectedColor};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeSearchBarSubBtnImgColorNotif" object:nil userInfo:dict];
//    }
    
    
    
    for (AKChannelListModel *model in self.model.channelList) {
        model.displayUnselColor = self.model.channelList[index].unselectedColor;
    }
    [self.topTabbarBGView scrollWithOffsetX:index*self.union_w];
}


- (void)selFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)index sendSingle:(BOOL)isSend{
    
    [self selFromIndex:fromIndex ToIndex:index sendSingle:isSend animate:NO];
}

//- (void)lineSelAniByIdx:(NSInteger)index{
//    AKChannelListModel *m = _model.channelList[index];
//    NSString *title = m.name;
//    CGSize size = [title union_stringSizeWithFontSize:m.exfontSize
//                                              maxSize:CGSizeMake(
//                                                                 MAXFLOAT,
//                                                                 MAXFLOAT
//                                                                 )];
//    CGFloat centXFlaot = (size.width + 12 + 10) / 2;
//    CGFloat imgWith = 14;
//
//    CGFloat offset = (centXFlaot - imgWith/2 + [self leftLineDistanceBySelIdx:index]) - self.lineImgView.transform.tx;
//
//    [UIView animateWithDuration:0.25 animations:^{
//        self.lineImgView.transform = CGAffineTransformTranslate(self.lineImgView.transform, offset, 0);
//    }];
//}

- (CGFloat)leftLineDistanceBySelIdx:(NSInteger)idx{
    CGFloat distance = 0.f;
    for (int i = 0; i < _model.channelList.count; i++) {
        
        if (idx == i) {
            break;
        }
        AKChannelListModel *m = _model.channelList[i];
        NSString *title = m.name;
        CGSize size = [title union_stringSizeWithFontSize:m.exfontSize
                                                  maxSize:CGSizeMake(
                                                                     MAXFLOAT,
                                                                     MAXFLOAT
                                                                     )];
        distance+=(size.width+12+10);
    }
    return distance;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    AKChannelListModel *m = _model.channelList[indexPath.row];
    NSString *title = m.name;
    CGSize size = [title union_stringSizeWithFontSize:m.fontSize.integerValue
                                              maxSize:CGSizeMake(
                                                                 MAXFLOAT,
                                                                 MAXFLOAT
                                                                 )];
    
    return CGSizeMake(size.width+12+10+title.length*2, minCS_Item_H);
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.channelList.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    AKCSquenceItem *item = (AKCSquenceItem*)cell;
    
//    [item conv]
    item.itemSelectedColor = _model.selectedColor;
    AKChannelListModel *m = _model.channelList[indexPath.row];
    m.idx = indexPath.row;
    item.model = m;
    
//    if (m.isSel) {
//        [self transitionFromCell:nil toIndex:item animate:NO];
//        
//    }else {
//        [self transitionFromCell:item toIndex:nil animate:NO];
//    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AKCSquenceItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[AKCSquenceItem itemId] forIndexPath:indexPath];
    
    item.itemSelectedColor = _model.selectedColor;
    AKChannelListModel *m = _model.channelList[indexPath.row];
    m.idx = indexPath.row;
    item.model = m;
    
    if (m.isSel) {
        [self transitionFromCell:nil toIndex:item animate:NO];

    }else {
         [self transitionFromCell:item toIndex:nil animate:NO];
    }

    
//    @weakify(self)
//    item.selOption = ^(AKChannelListModel *m) {
//        @strongify(self)
//        self.bannerBtn.tintColor = [UIColor colorWithHexString:m.selectedColor];
//
//        [self.bannerBtn setImage:[self.bannerBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//        self.lineImgView.tintColor = [UIColor colorWithHexString:m.selectedColor];
//        [self.lineImgView setImage:[self.lineImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
//        [self.bgImgV sd_setImageLineAniWithURL:[NSURL URLWithString:m.columOfBgImg] placeholderImage:nil];
    
//        if ([m.columOfBgImg union_isExist]) {
//            [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:m.columOfBgImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                CGFloat s = image.size.height / image.size.width;
////                CGFloat h = 46. + [NSObject union_safeAreaTop];
//
//                CGFloat w = UNION_SCREEN_WIDTH;
//                CGFloat h = w * s;
//                if (h >= 46. + [NSObject union_safeAreaTop]) {
//                    [self.bgImgV mas_updateConstraints:^(MASConstraintMaker *make) {
//                        make.left.mas_equalTo(0);
//                        make.right.mas_equalTo(0);
//                        make.top.mas_equalTo(46 - h);
//                    }];
//                } else {
//                    h = 46. + [NSObject union_safeAreaTop];
//                    w = h / s;
//                    CGFloat padding = (UNION_SCREEN_WIDTH - w) / 2.;
//                    [self.bgImgV mas_updateConstraints:^(MASConstraintMaker *make) {
//                        make.left.mas_equalTo(padding);
//                        make.right.mas_equalTo(0 - padding);
//                        make.top.mas_equalTo(-[NSObject union_safeAreaTop]);
//                    }];
//                }
//                CGFloat padding = (w - UNION_SCREEN_WIDTH) / 2.;
                
//            }];
//        } else {
//            [self.bgImgV setImage:nil];
//        }
//    };
    return item;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self selFromIndex:self.curIdx ToIndex:indexPath.row sendSingle:YES];
    [self selFromIndex:self.curIdx ToIndex:indexPath.row sendSingle:YES animate:YES];

}
#pragma mark - Getter & Setter
- (void)setModel:(AKChannelSquenceModel *)model{
    _model = model;
    [self.topTabbarBGView setupModel:model withBgH:self.union_h];
    
    if (_model.selectedColor) {
//        [_bannerBtn setBackgroundColor:[UIColor clearColor]];
//        [_bannerBtn setImage:[[UIImage imageNamed:@"channelBtnImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];//MyShareCardBG
//        [_bannerBtn setTintColor:[UIColor colorWithHexString:_model.selectedColor]];
//
//        AKChannelListModel *m = _model.channelList[0];
//        [_shadow sd_setImageWithURL:[NSURL URLWithString:m.columOfBgImg] placeholderImage:nil];//MyShareCardBG
//        [self insertSubview:_shadow atIndex:0];

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSDictionary *dict = @{@"selectedColor":self->_model.selectedColor};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeSearchBarSubBtnImgColorNotif" object:nil userInfo:dict];
//        });
    }
    
    
    /** 注册新版 的UI背景 */
//    if ([self.model.selectedColor union_isExist]) {
//        self.bannerBtn.tintColor = [UIColor colorWithHexString:self.model.selectedColor];
//    } else {
//        self.bannerBtn.tintColor = [UIColor blackColor];
//    }
    
    
//    [self.bannerBtn setImage:[self.bannerBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [_collectionView reloadData];
//    [_collectionView performBatchUpdates:^{
//
//    } completion:^(BOOL finished) {
        int selectIndex =0 ;
        for (int i = 0; i< model.channelList.count-1; i++) {
            AKChannelListModel *model1 = model.channelList[i];
            if (model1.isSel) {
                selectIndex =i;
                break;
            }
        }
        //    [self transitionFromCell:0 toIndex:selectIndex progress:0];
        [self scrollToItemExtraActionFromIndex:0 toIndex:selectIndex progress:0];
//    }];
    
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:AKCSquenceItem.class forCellWithReuseIdentifier:AKCSquenceItem.itemId];
    }
    return _collectionView;
}
- (RACSubject *)scroDidSubject{
    if (!_scroDidSubject) {
        _scroDidSubject = [RACSubject subject];
    }
    return _scroDidSubject;
}

- (int)curIdx{
    int i = 0;
    for (AKChannelListModel *m in self.model.channelList) {
        if (m.isSel) {
            break;
        } else {
            i++;
        }
    }
    return i;
}

-(AKTopTabbarBGView *)topTabbarBGView {
    if (_topTabbarBGView) {
        return _topTabbarBGView;
    }
    
    _topTabbarBGView = [AKTopTabbarBGView lw_createAddToView:self
                                                 blockConfig:^(__kindof AKTopTabbarBGView *v) {
                                                     
                                                     v.frame = CGRectMake(0, -[NSObject union_statusBarHeight], self.union_w, 46. + [NSObject union_statusBarHeight]);
                                                     
                                                     [self sendSubviewToBack:v];
                                                 }];
    return _topTabbarBGView;
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

/** 获取需要最终滚动停留的ContentOffset */
- (CGPoint)getFinalContentOffsetXWithIndex: (NSInteger)index {
    

    CGRect cellRect =  [self cellFrameWithIndex:index];
    
    CGFloat  finalContentOffsetX;
    
    //中间需要修正的位置
    if (cellRect.origin.x + cellRect.size.width/2.f >= self.collectionView.size.width / 2.f && self.collectionView.contentSize.width - cellRect.origin.x - cellRect.size.width/2.f >= self.collectionView.size.width / 2.f ) {
        
        finalContentOffsetX = cellRect.origin.x + cellRect.size.width/2.f - self.collectionView.size.width / 2.f;
        
        //最右边
    }else if (self.collectionView.contentSize.width - cellRect.origin.x - cellRect.size.width/2.f < self.collectionView.size.width / 2.f  ){
        finalContentOffsetX = self.collectionView.contentSize.width - self.collectionView.size.width / 2.f - self.collectionView.size.width / 2.f;
        //最左边
    }else {
        finalContentOffsetX = self.collectionView.size.width / 2.f - self.collectionView.size.width / 2.f;
    }
    
    return CGPointMake(finalContentOffsetX, self.collectionView.contentOffset.y);
    
}
@end
