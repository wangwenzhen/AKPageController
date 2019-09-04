//
//  ViewController.m
//  AKPageController
//
//  Created by Little.Daddly on 2019/9/3.
//  Copyright © 2019 wangwz. All rights reserved.
//

#import "ViewController.h"
#import "AKDemoVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIButton lw_createAddToView:self.view blockConfig:^(__kindof UIButton *b) {
        b.backgroundColor = [UIColor redColor];
        @weakify(self)
        [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self presentViewController:AKDemoVC.new animated:YES completion:nil];
        }];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
    }];
    
    
}


@end
