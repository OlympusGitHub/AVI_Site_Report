//
//  OAI_View.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_View.h"

@implementation OAI_View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", event);
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
