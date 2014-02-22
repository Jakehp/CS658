//
//  ViewController.h
//  PhotoMailer
//  14:07
//  Created by Jake on 2/21/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PhotoMailerViewController : UIViewController <MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) IBOutlet UIImageView* imageView;

@end
