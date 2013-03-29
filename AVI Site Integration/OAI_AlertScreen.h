//
//  OAI_AlertScreen.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/27/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"


@interface OAI_AlertScreen : UIView {
    
    OAI_ColorManager* colorManager;
    
    UITextView* txtAlertMsg;
    UIButton* btnOkay;
    CGSize headerLabelSize;
}

@property (nonatomic, retain) NSString* closeAction;
@property (nonatomic, retain) NSString* titleBarImage;
@property (nonatomic, retain) NSString* titleBarText;


- (void) closeWin : (id) sender;

- (void) showAlert : (NSString* ) alertMsg;

@end
