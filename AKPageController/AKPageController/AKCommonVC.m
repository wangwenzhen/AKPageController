//
//  AKMovieVC.m
//  miguaikan
//
//  Created by 李剑刚 on 2019/4/9.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKCommonVC.h"


@interface AKCommonVC ()
@end

@implementation AKCommonVC
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
}
- (void)initSubViews{

}

- (void)akViewAppear{
    KCLog(@"");
}



- (void)pullRomoteData:(NSInteger)idx{

}

- (void)akViewDisAppear{
    KCLog(@"");
}
- (void)setListModel:(id)listModel{
    [super setListModel:listModel];
    KCLog(@"接受 model");
}
@end
