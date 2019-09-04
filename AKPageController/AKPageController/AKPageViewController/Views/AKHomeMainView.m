//
//  AKHomeMainView.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKHomeMainView.h"

@interface AKHomeMainView()<UIScrollViewDelegate>{
    CGFloat     _preOffsetX;
    BOOL        _isTapScrollMoved;
}

@property (nonatomic,strong) NSArray *containViews;

@property (nonatomic,strong) UIScrollView *scroV;
@property (nonatomic,assign) NSInteger prePage;
@property (nonatomic,assign) NSInteger curIndex;


@end

@implementation AKHomeMainView
- (instancetype)init{
    if (self = [super init]) {
        
        
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setChannelSquenceModel:(id)channelSquenceModel{
    _channelSquenceModel = channelSquenceModel;
    [self configureData];
}

- (void)configureData{
    
    [self addSubview:self.scroV];
    [_scroV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    NSMutableArray *marr = NSMutableArray.array;
    
    if ([self.pageDelegate respondsToSelector:@selector(configureViewControllerData)]) {
        NSArray *d = [self.pageDelegate configureViewControllerData];
        int idx = 0;
        for (AKHomeBaseVC *vc in d) {
            vc.idx = idx;
            [_pageDelegate addChildViewController:vc];
            [marr addObject:vc.view];
            [_scroV addSubview:vc.view];
            idx++;
        }
    } else {//演示的demo
        NSInteger subVC_count =  [(AKChannelSquenceModel *)_channelSquenceModel channelList].count;
        for (int i =0 ; i < subVC_count; i++) {
            AKHomeBaseVC *vc = [[AKHomeBaseVC alloc] initWithModel:[(AKChannelSquenceModel *)_channelSquenceModel channelList][i]];
            vc.view.backgroundColor = [UIColor union_colorWithR:i*10 + 100 G:i*10 + 100 B:i*10 + 100];
            vc.idx = i;
            [_pageDelegate addChildViewController:vc];
            [marr addObject:vc.view];
            [_scroV addSubview:vc.view];
        }
    }
    
    
    _scroV.clipsToBounds = NO;
    _containViews = marr.copy;
    _preOffsetX = 0;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
    _scroV.contentSize = CGSizeMake(_pageDelegate.childViewControllers.count * UNION_SCREEN_WIDTH, self.union_h);
    for (int i = 0; i < _containViews.count; i++) {
        UIView *v = _containViews[i];
        v.frame = CGRectMake(UNION_SCREEN_WIDTH * i, 0, UNION_SCREEN_WIDTH, self.union_h);
    }
}

- (void)scroToPage:(NSInteger)page{
   
//    if (page > _prePage) {
//        _scroV.union_offsetX = page * UNION_SCREEN_WIDTH ;
//    }else {
//        _scroV.union_offsetX = page * UNION_SCREEN_WIDTH + 1;
//    }

    _prePage = page;
    
     _preOffsetX = _scroV.contentOffset.x;
    _isTapScrollMoved = YES;
    
    if (page== 0 && _scroV.contentOffset.x == 0) {
        [self.scroV setContentOffset:CGPointMake(1,0) animated:NO];
    }
    [self.scroV setContentOffset:CGPointMake(page * UNION_SCREEN_WIDTH,0) animated:NO];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.superview) {
        return;
    }
    [self.scringSubject sendNext:NSStringFromCGPoint(scrollView.contentOffset)];
    // get scrolling direction
    CGFloat offsetX = scrollView.contentOffset.x;
    // 0 Left 1  Right
    int direction = offsetX >= _preOffsetX ? 0 : 1;
    if (!_isTapScrollMoved) {
         [self caculateIndexByProgressWithOffsetX:offsetX direction:direction];
    }
    [self caculateIndexWithOffsetX:offsetX direction:direction];
     _isTapScrollMoved = NO;
}

- (void)caculateIndexWithOffsetX:(CGFloat)offsetX direction:(int)direction{
    if (CGRectIsEmpty(self.scroV.frame)) {
        return;
    }
    if (self.containViews.count <= 0) {
        _curIndex = -1;
        return;
    }
    // scrollView width
    CGFloat width = CGRectGetWidth(self.scroV.frame);
    NSInteger index = 0;
    // when scroll to progress(changeIndexWhenScrollProgress) will change index
    double percentChangeIndex = 0.50;
   
    // caculate cur index
    if (direction == 0) {
        index = ceil(offsetX/width-percentChangeIndex);
    }else {
        index = floor(offsetX/width+percentChangeIndex);
    }
    
    if (index < 0) {
        index = 0;
    }else if (index >= self.containViews.count) {
        index = self.containViews.count-1;
    }
    if (index == _curIndex) {
        // if index not same,change index
        return;
    }
    
    NSInteger fromIndex = MAX(_curIndex, 0);
    
    
    if (self.scroV.isTracking) {
        return;
    }
    
    _curIndex = index;

    if ([self.pageDelegate respondsToSelector:@selector(pagerViewTransitionFromIndex:toIndex:animated:needScorllExAction:)]) {
        //Tap 导致的切换tab和滚动，需要附加ScorllExAction，如字体颜色大小和下划线
        if (_isTapScrollMoved) {
            [self.pageDelegate pagerViewTransitionFromIndex:fromIndex toIndex:index animated:YES needScorllExAction:YES];
        //手动滑动切换tab和滚动，不需要附加ScorllExAction，字体颜色大小和下划线由滑动process实现
        }else {
            [self.pageDelegate pagerViewTransitionFromIndex:fromIndex toIndex:index animated:YES needScorllExAction:NO];
        }
//         _scroV.union_offsetX = index * UNION_SCREEN_WIDTH ;
    }
    
    
    [self.scroDidSubject sendNext:@(index)];
    AKHomeBaseVC *appearVC = (AKHomeBaseVC *)_pageDelegate.childViewControllers[index];
    if ([appearVC respondsToSelector:@selector(akViewAppear)]) {
        dispatch_async_on_main_queue(^{
            [appearVC akViewAppear];
        });
    }
    AKHomeBaseVC *disAppearVC = (AKHomeBaseVC *)_pageDelegate.childViewControllers[_prePage];
    if ([disAppearVC respondsToSelector:@selector(akViewDisAppear)]) {
        dispatch_async_on_main_queue(^{
            [disAppearVC akViewDisAppear];
        });
    }
    
    _prePage = index;
}


//通过offsetX 得到progress、fromIndex、toIndex,然后调用代理
- (void)caculateIndexByProgressWithOffsetX:(CGFloat)offsetX direction:(int)direction{
    if (CGRectIsEmpty(self.scroV.frame)) {
        return;
    }
    if (self.containViews.count <= 0) {
        _curIndex = -1;
        return;
    }
    CGFloat width = CGRectGetWidth(self.scroV.frame);
    CGFloat floadIndex = offsetX/width;
    NSInteger floorIndex = floor(floadIndex);
    if (floorIndex < 0 || floorIndex >= self.containViews.count || floadIndex > self.containViews.count-1) {
        return;
    }
    
    CGFloat progress = offsetX/width-floorIndex;
    NSInteger fromIndex = 0, toIndex = 0;
    if (direction == 0) {
        fromIndex = floorIndex;
        toIndex = MIN(self.containViews.count -1, fromIndex + 1);
        if (fromIndex == toIndex && toIndex == self.containViews.count-1) {
            fromIndex = self.containViews.count-2;
            progress = 1.0;
        }
    }else {
        toIndex = floorIndex;
        fromIndex = MIN(self.containViews.count-1, toIndex +1);
        progress = 1.0 - progress;
    }
    
   
    if ([self.pageDelegate respondsToSelector:@selector(pagerViewTransitionFromIndex:toIndex:progress:)]) {
        [self.pageDelegate pagerViewTransitionFromIndex:fromIndex toIndex:toIndex progress:progress];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _preOffsetX = scrollView.contentOffset.x;
    NSInteger page = scrollView.contentOffset.x / UNION_SCREEN_WIDTH;
    KCLog(@"Dragging a ---index  %ld",(long)page);
    _prePage = page;
}

- (void)scrollViewWillScrollToView:(UIScrollView *)scrollView{
    _preOffsetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
   
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    // get scrolling direction
//    CGFloat offsetX = targetContentOffset->x;
//    // 0 Left 1  Right
//    int direction = offsetX >= _preOffsetX ? 0 : 1;
//    [self caculateIndexWithOffsetX:offsetX direction:direction];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //是否在触摸
    BOOL isTracking =  scrollView.tracking;
    if (!isTracking && decelerate) {
        
    }
}

- (UIScrollView *)scroV{
    if (!_scroV) {
        _scroV = [UIScrollView new];
        _scroV.delegate = self;
        _scroV.bounces = NO;
        _scroV.pagingEnabled = YES;
        _scroV.showsVerticalScrollIndicator = NO;
        _scroV.showsHorizontalScrollIndicator = NO;
    }
    return _scroV;
}

- (RACSubject *)scroDidSubject{
    if (!_scroDidSubject) {
        _scroDidSubject = [RACSubject subject];
    }
    return _scroDidSubject;
}

- (RACSubject *)scringSubject{
    if (!_scringSubject) {
        _scringSubject = RACSubject.new;
    }
    return _scringSubject;
}
@end
