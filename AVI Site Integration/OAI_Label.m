//
//  OAI_Label.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_Label.h"

@implementation OAI_Label

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        self.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return self;
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
