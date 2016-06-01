//
//  UIImage+BUCImage.m
//  BUCilent
//
//  Created by dito on 16/6/1.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "UIImage+BUCImage.h"
#import <ImageIO/ImageIO.h>


#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)

@implementation UIImage (BUCImage)

+ (UIImage *)imageWithData:(NSData *)data size:(CGSize)size {
    UIImage *output;
    CGImageRef image = NULL;
    CGImageSourceRef source = NULL;
    CFDictionaryRef properties = NULL;
    NSString *type;
    NSMutableDictionary *options;
    
    source = CGImageSourceCreateWithData(toCF data, NULL);
    if (!source) {
        goto cleanup;
    }
    
    options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               (id)kCFBooleanTrue, (id)kCGImageSourceShouldCache,
               nil];
    
    properties = CGImageSourceCopyPropertiesAtIndex(source, 0, toCF options);
    if (!properties) {
        goto cleanup;
    }
    
    if (size.width > 0) {
        [options setObject:[NSNumber numberWithInt:maxDimension(properties, size)] forKey:(id)kCGImageSourceThumbnailMaxPixelSize];
    }
    [options setObject:(id)kCFBooleanTrue forKey:(id)kCGImageSourceCreateThumbnailFromImageAlways];
    [options setObject:(id)kCFBooleanTrue forKey:(id)kCGImageSourceCreateThumbnailWithTransform];
    
    type = (NSString *)CGImageSourceGetType(source);
    
    image = CGImageSourceCreateThumbnailAtIndex(source, 0, toCF options);
    output = [UIImage imageWithCGImage:image];
//    if ([type isEqualToString:@"com.compuserve.gif"]) {
//        output = animatedImageWithAnimatedGIFImageSource(source, toCF options);
//    } else {
//        image = CGImageSourceCreateThumbnailAtIndex(source, 0, toCF options);
//        output = [UIImage imageWithCGImage:image];
//    }
    
cleanup:
    if (source) {
        CFRelease(source);
    }
    if (properties) {
        CFRelease(properties);
    }
    if (image) {
        CFRelease(image);
    }
    
    return output;
}

static int maxDimension(CFDictionaryRef properties, CGSize fitSize) {
    NSNumber *width;
    NSNumber *height;
    CGFloat scaledWidth;
    CGFloat scaledHeight;
    
    
    width = (NSNumber *)CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    height = (NSNumber *)CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    
    CGFloat targetRatio = fitSize.width / fitSize.height;
    CGFloat imageRatio = width.floatValue / height.floatValue;
    
    if (targetRatio > imageRatio) {
        scaledWidth = width.floatValue * fitSize.height / height.floatValue;
        scaledHeight = fitSize.height;
    } else {
        scaledWidth = fitSize.width;
        scaledHeight = height.floatValue * fitSize.width / width.floatValue;
    }
    
    return floorf(MAX(scaledWidth, scaledHeight));
}



@end
