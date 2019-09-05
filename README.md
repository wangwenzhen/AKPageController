# AKPageController
市面流行的上下区域相互滚动



使用方法。

1.将AKPageController 拖入工程

2.载体vc参考AKDemoVC

3.底部滚动参考AKCommenVC

4.手动拖入BeautyKit 中的工具类 即可。  [可以移除将使用的工具类替换自己的工具类]

5.集成pod

pod 'YYCategories','1.0.4'

pod 'ReactiveObjC','3.1.1'

pod 'Masonry','1.1.0'

pod 'SDWebImage','4.4.6'     

pod 'SDWebImage/GIF', '4.4.6'


6.导入的全局头文件参考  PrefixHeader.pch 文件 如下
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BeautyKitHeader.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
