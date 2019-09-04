//
//  UIImageView+AKSDWebAdd.m
//  miguaikan
//
//  Created by Little.Daddly on 2019/4/18.
//  Copyright © 2019 cmvideo. All rights reserved.
//

#import "UIImageView+AKSDWebAdd.h"

@implementation UIImageView (AKSDWebAdd)
- (void)sd_setImageLineAniWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)img{
    @weakify(self);
    [self sd_setImageWithURL:url placeholderImage:img completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (cacheType == SDImageCacheTypeNone) {
            @strongify(self);
            self.alpha = 0.15;
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self);
                self.alpha = 1;
            }];
        }
    }];
}
@end

@implementation FLAnimatedImageView (AKSDWebAdd)
- (void)sd_setImageLineAniWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)img{
    @weakify(self);
    [self sd_setImageWithURL:url placeholderImage:img completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (cacheType == SDImageCacheTypeNone) {
            @strongify(self);
            self.alpha = 0.15;
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self);
                self.alpha = 1;
            }];
        }
    }];
}
@end
