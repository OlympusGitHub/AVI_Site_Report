//
//  OAI_Account.h
//  EBUS
//
//  Created by Steve Suranie on 3/4/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"

@interface OAI_Account : UIView <UITextFieldDelegate>{
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
}

- (void) buildAccountObjects;

- (void) closeWin : (UIButton*) btnClose;

@end
