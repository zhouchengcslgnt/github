/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    
    
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)setImageWithURL:(NSURL *)url imageArray:(NSMutableArray *)imageArray
{
    //为图片设置动态
     self.animationImages = imageArray;
    //为动画设置持续时间
    self.animationDuration = 1.0;
    //为默认的无限循环
    self.animationRepeatCount = 0;
    //开始播放动画
    [self startAnimating];
    
    //下载图片
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.animationImages = nil;
    [self stopAnimating];//结束动画
    self.image = image;
    
//    self.alpha = 0.0;
//    
//    [UIView beginAnimations: nil context: nil];
//    [UIView setAnimationDuration: 2.0];
//    self.alpha = 1.0;
//    [UIView commitAnimations];
}

@end
