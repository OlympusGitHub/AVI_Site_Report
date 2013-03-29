//
//  OAI_ScrollView.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_ScrollView.h"

@implementation OAI_ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setPagingEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:YES];
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.canCancelContentTouches = NO;
        
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
