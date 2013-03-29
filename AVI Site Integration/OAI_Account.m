//
//  OAI_Account.m
//  EBUS
//
//  Created by Steve Suranie on 3/4/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_Account.h"

@implementation OAI_Account

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /*******************************
         USER ACCOUNT INFO
         **********************************/
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.75;
        
        colorManager = [[OAI_ColorManager alloc] init];
        fileManager = [[OAI_FileManager alloc] init];
        
    }
    
     return self;
}
    
- (void) buildAccountObjects  { 
        
        //title and instructions
        NSString* strAccountInfo = @"Account Info";
        CGSize accountInfoSize = [strAccountInfo sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        UILabel* lblAcountInfo = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(accountInfoSize.width/2), 20.0, accountInfoSize.width, accountInfoSize.height)];
        lblAcountInfo.text = strAccountInfo;
        lblAcountInfo.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblAcountInfo.backgroundColor = [UIColor clearColor];
        lblAcountInfo.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        [self addSubview:lblAcountInfo];
        
        NSString* strAccountInst = @"Enter your account info below. This will be stored and used when emailing results.";
        CGSize accountInstSize = [strAccountInst sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0] constrainedToSize:CGSizeMake(self.frame.size.width-40.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel* lblAcountInst = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(accountInstSize.width/2), lblAcountInfo.frame.origin.y + lblAcountInfo.frame.size.height + 5.0, accountInstSize.width, accountInstSize.height)];
        lblAcountInst.text = strAccountInst;
        lblAcountInst.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblAcountInst.backgroundColor = [UIColor clearColor];
        lblAcountInst.numberOfLines = 0;
        lblAcountInst.lineBreakMode = NSLineBreakByWordWrapping;
        lblAcountInst.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        [self addSubview:lblAcountInst];
        
        
        //form elements
        UITextField* txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(20.0, lblAcountInst.frame.origin.y + lblAcountInst.frame.size.height + 35.0, self.frame.size.width-40.0, 30.0)];
        txtUserName.placeholder = @"Name";
        txtUserName.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
        txtUserName.borderStyle = UITextBorderStyleRoundedRect;
        txtUserName.backgroundColor = [UIColor whiteColor];
        txtUserName.delegate = self;
        txtUserName.tag = 601;
        [self addSubview:txtUserName];
        
        UITextField* txtUserTitle = [[UITextField alloc] initWithFrame:CGRectMake(20.0, txtUserName.frame.origin.y + txtUserName.frame.size.height + 15.0, self.frame.size.width-40.0, 30.0)];
        txtUserTitle.placeholder = @"Title";
        txtUserTitle.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
        txtUserTitle.borderStyle = UITextBorderStyleRoundedRect;
        txtUserTitle.backgroundColor = [UIColor whiteColor];
        txtUserTitle.delegate = self;
        txtUserTitle.tag = 602;
        [self addSubview:txtUserTitle];
        
        UITextField* txtUserEmail = [[UITextField alloc] initWithFrame:CGRectMake(20.0, txtUserTitle.frame.origin.y + txtUserTitle.frame.size.height + 10.0, self.frame.size.width-40.0, 30.0)];
        txtUserEmail.placeholder = @"Olympus Email Address";
        txtUserEmail.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
        txtUserEmail.borderStyle = UITextBorderStyleRoundedRect;
        txtUserEmail.backgroundColor = [UIColor whiteColor];
        txtUserEmail.delegate = self;
        txtUserEmail.tag = 603;
        [self addSubview:txtUserEmail];
        
        UITextField* txtUserPhone = [[UITextField alloc] initWithFrame:CGRectMake(20.0, txtUserEmail.frame.origin.y + txtUserEmail.frame.size.height + 10.0, self.frame.size.width-40.0, 30.0)];
        txtUserPhone.placeholder = @"Phone Number";
        txtUserPhone.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
        txtUserPhone.borderStyle = UITextBorderStyleRoundedRect;
        txtUserPhone.backgroundColor = [UIColor whiteColor];
        txtUserPhone.delegate = self;
        txtUserPhone.tag = 604;
        [self addSubview:txtUserPhone];
        
        //add the toggle account data button
        UIImage* imgCloseX = [UIImage imageNamed:@"btnCloseX.png"];
        UIButton* btnCloseX = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-(imgCloseX.size.width+10.0), self.frame.size.height-(imgCloseX.size.height+10.0), imgCloseX.size.width, imgCloseX.size.height)];
        [btnCloseX setImage:imgCloseX forState:UIControlStateNormal];
    [btnCloseX addTarget:self action:@selector(closeWin:) forControlEvents:UIControlEventTouchUpInside];
        [btnCloseX setBackgroundColor:[UIColor clearColor]];
        [self addSubview:btnCloseX];
   
}

- (void) closeWin:(UIButton *)btnClose {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:@"Close Account Win" forKey:@"Event"];
    [userData setObject:self forKey:@"Account View"];
    
    /*This is the call back to the notification center, */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //trapping for account info text fields
    if (textField.tag > 600 && textField.tag < 605) {
        
        //set some ivars
        NSString* strAccountPlist = @"UserAccount.plist";
        NSMutableDictionary* dictAccountData = [[NSMutableDictionary alloc] init];
        
        //get all the text fields
        NSArray* arrAccountSubviews = self.subviews;
        
        //loop through elements of vAccount
        for(int i=0; i<arrAccountSubviews.count; i++) {
            
            //sniff for textfields
            if ([[arrAccountSubviews objectAtIndex:i] isMemberOfClass:[UITextField class]]) {
                
                //cast to textfield
                UITextField* thisTextField = (UITextField*)[arrAccountSubviews objectAtIndex:i];
                
                //check which textfield we captured and then dump data into dictionary
                if (thisTextField.text != nil) {
                    if (thisTextField.tag == 601) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Name"];
                    } else if (thisTextField.tag == 602) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Title"];
                    } else if (thisTextField.tag == 603) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Email"];
                    } else if (thisTextField.tag == 604) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Phone"];
                    }
                }
            }
        }
        
        //create the plist if we need to
        [fileManager createPlist:strAccountPlist];
        
        NSLog(@"%@", dictAccountData);
        [fileManager writeToPlist:strAccountPlist :dictAccountData];
        
    }
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
