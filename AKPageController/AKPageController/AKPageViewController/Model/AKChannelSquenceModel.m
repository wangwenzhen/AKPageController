//
//  AKChannelSquenceModel.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "AKChannelSquenceModel.h"

@implementation AKChannelSquenceModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"channelList" : AKChannelListModel.class,
             };
}

- (void)setSelectedColor:(NSString *)selectedColor{
    _selectedColor = selectedColor;
    if (![_selectedColor union_isExist] || [_selectedColor isEqualToString:@"#ff7a18"]) {

//        _selectedColor = @"#FF5E00";
        _selectedColor = @"#FFFFFF";
    }
}

- (void)setSelectedSize:(NSString *)selectedSize{
    _selectedSize = selectedSize;
    if (![_selectedSize union_isExist]) {
        _selectedSize = @"22";
    }
}

- (void)setChannelList:(NSArray<AKChannelListModel *> *)channelList{
    _channelList = channelList;
    int idx = 0;
    NSString *otherUnselColor = @"";
    for (AKChannelListModel *m in channelList) {
        
        if (idx == 0) {
            otherUnselColor = m.unselectedColor;
        } else {
            m.displayUnselColor = otherUnselColor;
        }
        
        
        
        if (![m.fontSize union_isExist]) {//未选中字体大小
            m.fontSize = @"16";
        }
        
        if (![m.selectedColor union_isExist]) {//选中颜色
            m.selectedColor = _selectedColor;      
        }
        
        m.isStateBarLight = YES;
        NSArray *d = [UIColor getRGBDictionaryByColor:[UIColor colorWithHexString:m.selectedColor]];
        if (d.count >= 3) {
            CGFloat s = 0.3* [d[0] floatValue] + 0.6*[d[1] floatValue] + 0.1*[d[2] floatValue];
            if (s < 0.45) {//黑色
                m.isStateBarLight = YES;
                
            } else {
                m.isStateBarLight = NO;
            }
        }
        
        
        if ([m.columOfBgImg hasPrefix:@"http"]) {//有远程图
            m.isStateBarLight = NO;
        }
        
        if (![m.selectedSize union_isExist]) {//选中大小
            m.selectedSize = _selectedSize;
        }
        
        
        idx++;
    }
}
- (void)defaultSetup {
    self.selectedColor = @"";
    self.selectedSize = @"";
}
@end

@implementation AKChannelListModel

- (void)setColor:(NSString *)color{
    if (![color union_isExist] || [color isEqualToString:@"#71707A"]) {
        //            m.color = @"#D3D3D3";
        //
        color = @"#FFFFFFCC";
    }
    _color = color;
}

- (void)setUnselectedColor:(NSString *)unselectedColor{
    if (![unselectedColor union_isExist]) {
        unselectedColor = _color;
    }
    
    _unselectedColor = unselectedColor;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"zjColumOfChannelType" : ALZjColumOfChannelTypeModel.class,
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return  @{
              @"ID" : @[@"id"]
              };
}

- (instancetype)init {
    if (self = [super init]) {
        _exfontSize = 15;
    }
    return self;
}

//@property (nonatomic,copy) NSString *; //搜索框的背景气氛图 selectedColor  右上角频道管理图标,扫码,收藏,闹钟的图标颜色  同时也是文字的选中色颜色
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,strong) NSArray <AKChannelListModel *> *;

- (void)setColumOfBgImg:(NSString *)columOfBgImg{
    if ([columOfBgImg union_isExist]) {
        _columOfBgImg = columOfBgImg;
    } else {
        _columOfBgImg = @"default_channle_top";
    }
}

- (void)setColumOfSerBgImg:(NSString *)columOfSerBgImg{
    if ([columOfSerBgImg union_isExist]) {
        _columOfSerBgImg = columOfSerBgImg;
    } else {
        _columOfSerBgImg = @"default_channle_search";
    }
}

@end

@implementation ALZjColumOfChannelTypeModel



@end
