//
//  CPTakePhotoTool.m
//  confPlus
//
//  Created by Han Shuai on 15/11/25.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import "CPTakePhotoTool.h"


@interface CPTakePhotoToolDelegateResponser : NSObject<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *originViewController;
@property (nonatomic, strong) CPGetPhotoCompletionBlock completionBlock;

@end

@implementation CPTakePhotoToolDelegateResponser {
    UIImagePickerController *_imagePickerController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imagePickerController =  [[UIImagePickerController alloc] init];
    }
    return self;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self takePhoto:_imagePickerController];
        } break;
        case 1: {
            [self takeCamera:_imagePickerController];
        } break;
        default:
            break;
    }
}

- (void)enterAlbum {
    [self takePhoto:_imagePickerController];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.originViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    if ([picker isEqual:_imagePickerController]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    if (self.completionBlock) {
        self.completionBlock(image);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.originViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private methods

- (void)takeCamera:(UIImagePickerController *)imagePicker {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [LPToast showToast:NSLocalizedString(@"NoCameraToast", nil)];
        return;
    }
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self.originViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)takePhoto:(UIImagePickerController *)imagePicker {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    imagePicker.delegate = self;
    [self.originViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (!error) {
        NSLog(@"picture saved with no error.");
        if (self.completionBlock) {
            self.completionBlock(image);
        }
    } else {
//        [LPToast showToast:[NSString cp_localizableString:@"ProfileAvatorPictureSavingFailedToast"]];
        NSLog(@"error occured while saving the picture%@", error);
    }
}

@end




@implementation CPTakePhotoTool

static CPTakePhotoToolDelegateResponser *delegateResponser;

+(void)load {
    delegateResponser = [[CPTakePhotoToolDelegateResponser alloc] init];
}

+ (void)enterAlbum:(UIViewController *)viewController completionBlock:(CPGetPhotoCompletionBlock)completionBlock {
    delegateResponser.originViewController = viewController;
    delegateResponser.completionBlock = completionBlock;
    [delegateResponser enterAlbum];
}

+ (void)didClickGetPhotos:(UIViewController *)viewController completionBlock:(CPGetPhotoCompletionBlock)completionBlock {
    
    delegateResponser.originViewController = viewController;
    delegateResponser.completionBlock = completionBlock;
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:delegateResponser
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"相册", @"拍照", nil];
    [sheet showInView:viewController.view];
};

@end
