//
//  AKHomeBaseVC.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKHomeBaseVC.h"

@interface AKHomeBaseVC ()

@end

@implementation AKHomeBaseVC
- (instancetype)initWithModel:(id)listModel {
    if (self = [super init]) {
        [self setListModel:listModel];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AKHomeWaterfallNotiKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            if ([self respondsToSelector:@selector(pullRomoteData:)]) {
                if ([x.userInfo[@"idx"] integerValue] == self.idx) {
                    [self pullRomoteData:self.idx];
                }
            }
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
