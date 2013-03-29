//
//  OAI_TitleBar.h
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OAI_TitleBar : UIView {
    
}

@property (nonatomic, retain) NSString* titleBarTitle;

- (void) buildTitleBar; 

- (void) toggleAccount : (UIButton* ) btnAccount;

@end
