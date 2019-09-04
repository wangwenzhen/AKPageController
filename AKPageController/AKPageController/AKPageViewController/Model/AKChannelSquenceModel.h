//
//  AKChannelSquenceModel.h
//  miguaikan
//
//  Created by Little.Daddly on 2019/3/23.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AKChannelListModel,ALZjColumOfChannelTypeModel;

@interface AKChannelSquenceModel : NSObject
@property (nonatomic,copy) NSString *selectedColor; //搜索框的背景气氛图 selectedColor  右上角频道管理图标,扫码,收藏,闹钟的图标颜色  同时也是文字的选中色颜色
@property (nonatomic,copy) NSString *selectedSize;
@property (nonatomic,strong) NSArray <AKChannelListModel *> *channelList;
- (void)defaultSetup;
@end


@interface AKChannelListModel : NSObject
@property (nonatomic,strong) NSArray <ALZjColumOfChannelTypeModel *>*zjColumOfChannelType;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *channelUrl;

/** 当前未选中字体大小 */
@property (nonatomic,copy) NSString *fontSize;
/** 当前选中字体颜色 */
@property (nonatomic,copy) NSString *selectedColor;

@property (nonatomic,copy) NSString *fontFamily;
/** 未选中图 */
@property (nonatomic,copy) NSString *channelIconUrl;
/** 未选中大小 */
@property (nonatomic,copy) NSString *picSize;
/** 选中远程图 */
@property (nonatomic,copy) NSString *selectedChannelIconUrl;
/** 选中大小 */
@property (nonatomic,copy) NSString *selectedPicSize;
@property (nonatomic,copy) NSString *platformType;
@property (nonatomic,copy) NSString *searchWord;

/** 当前未选中字体颜色 */
@property (nonatomic,copy) NSString *color;
/** 选中后其他字体的颜色 */
@property (nonatomic,copy) NSString *unselectedColor;

/** 频道的背景气氛图 */
@property (nonatomic,copy) NSString *columOfBgImg;
/** 搜索框的背景气氛图 */
@property (nonatomic,copy) NSString *columOfSerBgImg;

/** 当前选中字体大小 */
@property (nonatomic,copy) NSString *selectedSize;


#pragma mark - custom
/** 是否选中 */
@property (nonatomic,assign) BOOL isSel;
@property (nonatomic,assign) BOOL preSel;
@property (nonatomic,assign) NSInteger exfontSize;
/** 未选中的字体颜色 */
@property (nonatomic,copy) NSString *displayUnselColor;
@property (nonatomic,assign) NSInteger idx;
@property (nonatomic,assign) BOOL isStateBarLight;
@end

@interface ALZjColumOfChannelTypeModel : NSObject
@property (nonatomic,copy) NSString *isSpecialColum;
@property (nonatomic,copy) NSString *showSerchLaber;
@property (nonatomic,copy) NSString *showTitle;
@property (nonatomic,copy) NSString *h5Url;
@end
NS_ASSUME_NONNULL_END
