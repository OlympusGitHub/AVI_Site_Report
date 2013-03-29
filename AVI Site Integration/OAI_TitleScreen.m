//
//  OAI_TitleScreen.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TitleScreen.h"

@implementation OAI_TitleScreen

@synthesize strAppTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) buildTitleScreen  {
    
    //init the color manager
    colorManager = [[OAI_ColorManager alloc] init];
    
    //get the size of the title string
    CGSize titleSize = [strAppTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size: 24.0]];
    
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(titleSize.width/2), 300.0, titleSize.width, titleSize.height)];
    lblTitle.text = strAppTitle;
    lblTitle.textColor = [colorManager setColor:8.0 :16.0 :123.0];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    
    [self addSubview:lblTitle];
    
    //add title image
    UIImage* imgTitle = [UIImage imageNamed:@"imgTitleScreen.png"];
    UIImageView* vImgTitle = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(imgTitle.size.width/2), lblTitle.frame.origin.y + lblTitle.frame.size.height + 10.0, imgTitle.size.width, imgTitle.size.height)];
    [vImgTitle setImage:imgTitle];
    [self addSubview:vImgTitle];
}

- (void) fadeTitleScreen   {
    
    [UIView animateWithDuration:2.5 delay:1.0 options:UIViewAnimationOptionCurveEaseOut
     
        animations:^{
            self.alpha = 0.0;
        }
     
        completion:^ (BOOL finished) {
            
            CGRect myFrame = self.frame;
            myFrame.origin.x = 0-myFrame.size.width;
            myFrame.origin.y = 0-myFrame.size.height;
            self.frame = myFrame;
        }
     ];
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
