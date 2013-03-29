//
//  OAI_AlertScreen.m
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/27/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import "OAI_AlertScreen.h"

@implementation OAI_AlertScreen

@synthesize closeAction, titleBarImage, titleBarText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = 350.0;
        self.frame = selfFrame;
        
        //round the corners and add shadow
        self.layer.cornerRadius = 8.0;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
                
    }
    return self;
}

- (void) showAlert : (NSString* ) alertMsg {
    
    //remove all objects
    NSArray* mySubview = self.subviews;
    
    for(id thisSubview in mySubview) {
        [thisSubview removeFromSuperview];
    }
    
    //header bar
    UIView* headerBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44.0)];
    headerBar.backgroundColor = [UIColor blackColor];
    
    //add the header bar title
    NSString* headerLabel = titleBarText;
    headerLabelSize = [headerLabel sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    
    UILabel* headerTitle = [[UILabel alloc] initWithFrame:CGRectMake((headerBar.frame.size.width/2)-(headerLabelSize.width/2), 7.0, headerLabelSize.width, headerLabelSize.height)];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.textColor = [UIColor whiteColor];
    headerTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    headerTitle.text = headerLabel;
    
    [headerBar addSubview:headerTitle];
    
    //add the title bar image
    if([titleBarImage isEqualToString:@"Warning"]) { 
        
        UIImage* imgYellowWarning = [UIImage imageNamed:@"imgYellowWarning.png"];
    
        UIImageView* vImgYellowWarning = [[UIImageView alloc] initWithImage:imgYellowWarning];
        CGRect imgYellowWarningFrame = vImgYellowWarning.frame;
        imgYellowWarningFrame.origin.x = headerTitle.frame.origin.x - (imgYellowWarningFrame.size.width + 10.0);
        imgYellowWarningFrame.origin.y = 1;
        vImgYellowWarning.frame = imgYellowWarningFrame;
    
        [headerBar addSubview:vImgYellowWarning];
        
    }
    
    [self addSubview:headerBar];
    
    //add the error msg
    txtAlertMsg = [[UITextView alloc] initWithFrame:CGRectMake(20.0, headerBar.frame.size.height + 10.0, self.frame.size.width-40, 40.0)];
    txtAlertMsg.backgroundColor = [UIColor clearColor];
    txtAlertMsg.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    txtAlertMsg.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    txtAlertMsg.textAlignment = NSTextAlignmentCenter;
    [self addSubview:txtAlertMsg];
    
    //submit images
    UIImage* imgOkayNormal = [UIImage imageNamed:@"btnOkayNormal.png"];
    UIImage* imgOkayHighlight = [UIImage imageNamed:@"btnOkayHighlight.png"];
    
    //get the image sizes
    CGSize imgOkayNormalSize = imgOkayNormal.size;
    
    btnOkay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOkay setImage:imgOkayNormal forState:UIControlStateNormal];
    [btnOkay setImage:imgOkayHighlight forState:UIControlStateHighlighted];
    
    //reset the button frame
    CGRect btnOkayFrame = btnOkay.frame;
    btnOkayFrame.origin.x = (self.frame.size.width/2)-(imgOkayNormalSize.width/2);
    btnOkayFrame.origin.y = (txtAlertMsg.frame.origin.x + txtAlertMsg.frame.size.height) + 15.0;
    btnOkayFrame.size.width = imgOkayNormalSize.width;
    btnOkayFrame.size.height = imgOkayNormalSize.height;
    btnOkay.frame = btnOkayFrame;
    
    //add the action
    [btnOkay addTarget:self action:@selector(closeWin:) forControlEvents:UIControlEventTouchUpInside];
    //a tag so we can identify it
    btnOkay.tag = 101;
    [self addSubview:btnOkay];
    [self bringSubviewToFront:btnOkay];

    
    //get superview
    UIView* myParent = self.superview;
    
    [myParent bringSubviewToFront:self];
    
    //resize view
    //get alert size
    CGSize maximumLabelSize = CGSizeMake(250,9999);
    CGSize alertMsgSize = [alertMsg sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    //resize txtAlertMsg
    CGRect txtAlertFrame = txtAlertMsg.frame;
    txtAlertFrame.size.height = alertMsgSize.height + 50.0;
    txtAlertMsg.frame = txtAlertFrame;
    
    //reposition the close button
    btnOkayFrame.origin.y = (txtAlertFrame.origin.y + txtAlertFrame.size.height)-10.0;
    btnOkay.frame = btnOkayFrame;
    
    txtAlertMsg.text = alertMsg;
    
    //resize the alert view
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = (myParent.frame.size.width/2) - (self.frame.size.width/2);
    selfFrame.origin.y = 190;
    selfFrame.size.height = 45.0 + txtAlertFrame.size.height +btnOkayFrame.size.height + 10.0;
    self.frame = selfFrame;
    
    //fade in
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
     
        animations:^{
            self.alpha = 1.0;
        }
     
        completion:^ (BOOL finished) {
            
        }
     
     ];
    
    
}

- (void) closeWin : (id) sender {
    
    //fade out
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
     
        animations:^{
            self.alpha = 0.0;
        }
     
        completion:^ (BOOL finished) {
            
            CGRect selfFrame = self.frame;
            selfFrame.origin.x = 0.0;
            selfFrame.origin.y = 0.0;
            self.frame = selfFrame;
            
                
            NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
                
            [userData setObject:@"Alert Closed" forKey:@"theEvent"];
            [userData setObject:closeAction forKey:@"Close Action"];
                
            //This is the call back to the notification center
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
                
            
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
