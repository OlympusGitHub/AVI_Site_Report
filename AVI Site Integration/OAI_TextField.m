//
//  OAI_TextField.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TextField.h"

@implementation OAI_TextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        self.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.returnKeyType = UIReturnKeyDone;
        self.userInteractionEnabled = YES;
        
         
        
    }
    return self;
}


- (void) handleTap : (CGPoint) hitPoint {
    NSLog(@"ok");
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
