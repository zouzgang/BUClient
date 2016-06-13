//
//  BUCImageFullScreen.m
//  BUCilent
//
//  Created by dito on 16/6/2.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCImageFullScreen.h"
#import "BUCToast.h"

static CGRect oldFrame;
//static CGFloat fullScreenImageX;
static CGFloat fullScreenImageY;
static CGFloat fullScreenImageW;
static CGFloat fullScreenImageH;

static CGFloat newFrameRelateToPinPointX;
static CGFloat newFrameRelateToPinPointY;
static CGFloat newFrameRelateToPinPointW;
static CGFloat newFrameRelateToPinPointH;


@implementation BUCImageFullScreen

+ (void)showImageFullScreen:(UIImageView *)imageView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *image = imageView.image;
    
    if (image) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        oldFrame = [imageView convertRect:imageView.bounds toView:window];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0;
        //        UIImageView *fullScreenImageView = [[UIImageView alloc] initWithFrame:oldFrame];
        UIImageView *fullScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, oldFrame.size.width, oldFrame.size.height)];
        fullScreenImageView.image = image;
        fullScreenImageView.tag = 1000;
        [backgroundView addSubview:fullScreenImageView];
        [window addSubview:backgroundView];
        
        //点击隐藏图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
        [backgroundView addGestureRecognizer:tap];
        
        //长安保存
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        [backgroundView addGestureRecognizer:longPress];
        
        //双指缩放
        UIPinchGestureRecognizer *scalePin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
        [backgroundView addGestureRecognizer:scalePin];
        
        //单指拖动
        UIPanGestureRecognizer *movePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
        [backgroundView addGestureRecognizer:movePan];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImage:)];
        [backgroundView addGestureRecognizer:swipe];
        
        //旋转
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
        [backgroundView addGestureRecognizer:rotation];
        
        [UIView animateWithDuration:0.3 animations:^{
            fullScreenImageY = (screenHeight - image.size.height * screenWidth / image.size.width) / 2;
            fullScreenImageH = image.size.height * screenWidth / image.size.width;
            fullScreenImageW = screenWidth;
            fullScreenImageView.frame = CGRectMake(0, fullScreenImageY, screenWidth, fullScreenImageH);
            backgroundView.alpha = 1;
        }];
        
    }
    
}

+ (void)swipeImage:(UISwipeGestureRecognizer *)swipe {
    
}

+ (void)saveImage:(UILongPressGestureRecognizer *)longPress {
    UIImageView *imageView = (UIImageView *)[longPress.view viewWithTag:1000];
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
                                   
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [BUCToast showToast:@"保存图片成功"];
    }
}

+ (void)rotateImage:(UIRotationGestureRecognizer *)rotation {
    UIView *backgroundView = rotation.view;
    //    UIImageView *imageView = (UIImageView *)[rotation.view viewWithTag:1000];
    
    backgroundView .transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    rotation.rotation = 0;
}

+ (void)moveImage:(UIPanGestureRecognizer *)pan {
    UIView *backgroundView = pan.view;
    UIImageView *imageView = (UIImageView *)[pan.view viewWithTag:1000];
    
    CGPoint translation = [pan translationInView:backgroundView];
    CGFloat velocity = sqrtf(translation.x * translation.x + translation.y * translation.y);
    if (pan.state == UIGestureRecognizerStateRecognized) {
        newFrameRelateToPinPointX = newFrameRelateToPinPointX + translation.x * velocity / 500;
        newFrameRelateToPinPointY = newFrameRelateToPinPointY + translation.y * velocity / 500;
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(newFrameRelateToPinPointX  , newFrameRelateToPinPointY, newFrameRelateToPinPointW, newFrameRelateToPinPointH);
        }];
    }
}

+ (void)scaleImage:(UIPinchGestureRecognizer *)pin {
    UIView *backgroundView = pin.view;
    UIImageView *imageView = (UIImageView *)[pin.view viewWithTag:1000];
    
    CGFloat scale = pin.scale;
    CGPoint pinPoint = [pin locationInView:backgroundView];
    //中心放大数据
    CGFloat newFrameX = -fullScreenImageW * (scale - 1) / 2;
    CGFloat newFrameY = fullScreenImageY - fullScreenImageH * (scale - 1) / 2;
    //捏合点放大数据
    newFrameRelateToPinPointX = newFrameX + (fullScreenImageW / 2 -pinPoint.x) * (scale - 1);
    newFrameRelateToPinPointY = newFrameY - (fullScreenImageY + fullScreenImageH / 2 - pinPoint.y) * (scale - 1);
    newFrameRelateToPinPointW = fullScreenImageW * scale;
    newFrameRelateToPinPointH = fullScreenImageH *scale;
    
    imageView.frame = CGRectMake(newFrameRelateToPinPointX  , newFrameRelateToPinPointY, newFrameRelateToPinPointW, newFrameRelateToPinPointH);
    
    if (pin.state == UIGestureRecognizerStateEnded) {
        if (scale < 1) {
            //缩小后恢复原图大小
            imageView.frame = CGRectMake(0, fullScreenImageY, fullScreenImageW, fullScreenImageH);
        }
    }
}


+ (void)hideImage:(UITapGestureRecognizer*)tap {
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(100, 200, oldFrame.size.width, oldFrame.size.height);
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
    
}


@end
