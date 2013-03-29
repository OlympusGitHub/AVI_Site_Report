//
//  OAI_TitleScreen.h
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAI_ColorManager.h"

@interface OAI_TitleScreen : UIView {
    
    OAI_ColorManager* colorManager;
}

@property (nonatomic, retain) NSString* strAppTitle;

- (void) buildTitleScreen;

- (void) fadeTitleScreen;

@end
