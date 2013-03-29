//
//  OAI_SectionLabel.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_SectionLabel.h"

@implementation OAI_SectionLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.backgroundColor = [colorManager setColor:8.0 :16.0 :123.0];
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
        self.textColor = [colorManager setColor:204.0 :204.0 :204.0];
        
    }
    return self;
}

- (void) drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0,5,0,5};
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 12.0;
    self.layer.borderWidth = 1;
    
    [super drawRect:rect];
}

@end
