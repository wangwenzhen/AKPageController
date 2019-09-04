//
//  AKHomeVM.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKHomeVM.h"
#import "AKChannelSquenceModel.h"
@implementation AKHomeVM

- (RACCommand *)channelSquenceCommand{
    if (!_channelSquenceCommand) {
        @weakify(self)
        _channelSquenceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                
                AKChannelSquenceModel *sM = [AKChannelSquenceModel new];
                
                NSArray *d = @[@"精选",@"小欢喜",@"电视剧",@"电影",@"综艺",@"少儿",@"芒果"];
                NSMutableArray *marr = NSMutableArray.new;
                for (NSString *s in d) {
                    AKChannelListModel *m = AKChannelListModel.new;
                    m.name = s;
                    m.unselectedColor = @"#FFFFFFCC";
                    
                    if ([s isEqualToString:@"小欢喜"]) {
                        m.selectedColor = @"#5B8C3F";
                        m.unselectedColor = @"#EFEF67CC";
//                        m.picSize = @"8";
                    }
                    
                    m.columOfBgImg = @"";
                    [marr addObject:m];
                }
                [sM defaultSetup];
                sM.channelList = marr.copy;
                
                self.channelSquenceModel = sM;
                [subscriber sendNext:sM];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _channelSquenceCommand;
}

- (RACCommand *)i_contentListCommand{
    if (!_i_contentListCommand) {
        
        _i_contentListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSArray *inputData) {
          
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
        
        _i_contentListCommand.allowsConcurrentExecution = YES;
    }
    return _i_contentListCommand;
}

@end

