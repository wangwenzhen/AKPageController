//
//  AKFeaturedVC.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/24.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKFeaturedVC.h"

@interface AKFeaturedVC()


@end

@implementation AKFeaturedVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = NO;
}



- (void)viewWillDisappear:(BOOL)animated{
    
}


- (void)akViewAppear{
    KCLog(@"");
}

- (void)pullRomoteData:(NSInteger)idx{
//    [self.mainView cacheLoadData];
}

- (void)akViewDisAppear{
    KCLog(@"");
}


- (void)setListModel:(id)listModel{
    [super setListModel:listModel];
    KCLog(@"接受 model");
}
@end
