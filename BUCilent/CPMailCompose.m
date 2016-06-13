//
//  CPMailCompose.m
//  confPlus
//
//  Created by dengjiebin on 11/19/15.
//  Copyright © 2015 Loopeer. All rights reserved.
//

#import "CPMailCompose.h"
#import "MessageUI/MessageUI.h"

@interface CPMailCompose() <MFMailComposeViewControllerDelegate>

@end

@implementation CPMailCompose {
    
    MFMailComposeViewController *_mailComposerController;
    UIViewController *_controller;
}

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Send


- (void)send:(NSString *)subject toRecipients:(NSArray *)toRecipients messageBody:(NSString *)messageBody isHTML:(BOOL)isHTML controller:(UIViewController *)controller {
                           
    //该设备未登录邮箱帐号，跳转到系统邮箱
    if (![MFMailComposeViewController canSendMail]) {
        [[UIApplication sharedApplication] openURL:[self makeEmailURL:subject toRecipients:toRecipients messageBody:messageBody]];
        return;
    }
    
    //该设备已登录邮箱帐号，在内部发送邮件
    _mailComposerController = [[MFMailComposeViewController alloc] init];
    _controller = controller;
    [_mailComposerController setSubject:subject];
    [_mailComposerController setMessageBody:messageBody isHTML:isHTML];
    [_mailComposerController setToRecipients:toRecipients];
    _mailComposerController.mailComposeDelegate = self;
    [_mailComposerController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [controller presentViewController:_mailComposerController animated:YES completion:nil];
}

- (NSURL *)makeEmailURL:(NSString *)subject toRecipients:(NSArray *)toRecipients messageBody:(NSString *)messageBody {
    
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    //添加收件人
    [mailUrl appendFormat:@"mailto://%@?", [toRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:[NSString stringWithFormat:@"subject=%@",subject]];
    //添加邮件内容
    [mailUrl appendString:[NSString stringWithFormat:@"&body=%@",messageBody]];
    
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    return [NSURL URLWithString:email];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [_controller dismissViewControllerAnimated:YES completion:nil];
    _controller = nil;
    _mailComposerController = nil;
    
    switch (result) {
        case MFMailComposeResultSent:
//            [LPToast showToast:[NSString cp_localizableString:@"NoteListMainSendSuccess"]];
            break;
        case MFMailComposeResultFailed:
//            [LPToast showToast:[NSString cp_localizableString:@"NoteListMainSendFailed"]];
            break;
        default:
            break;
    }
}

@end
