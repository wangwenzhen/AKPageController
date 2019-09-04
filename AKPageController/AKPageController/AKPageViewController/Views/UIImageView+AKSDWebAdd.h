//
//  UIImageView+AKSDWebAdd.h
//  miguaikan
//
//  Created by Little.Daddly on 2019/4/18.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (AKSDWebAdd)
- (void)sd_setImageLineAniWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)img;
@end

@interface FLAnimatedImageView (AKSDWebAdd)
- (void)sd_setImageLineAniWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)img;
@end
NS_ASSUME_NONNULL_END
