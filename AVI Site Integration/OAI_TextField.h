//
//  OAI_TextField.h
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"


@interface OAI_TextField : UITextField {
    
     OAI_ColorManager* colorManager;
}

@property (nonatomic, retain) NSString* myLabel;
@property (nonatomic, retain) NSString* myNumberType;

- (void) handleTap : (CGPoint) hitPoint;
@end
