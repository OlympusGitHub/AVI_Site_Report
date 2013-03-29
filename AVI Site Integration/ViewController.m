//
//  ViewController.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "ViewController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    /********************INIT MANAGERS****************/

    alertManager = [[OAI_AlertScreen alloc] init];
    fileManager =  [[OAI_FileManager alloc] init];
    pdfManager =   [[OAI_PDFManager alloc] init];
    colorManager = [[OAI_ColorManager alloc] init];
    
    /*************INIT DATA ARRAYS******************/
    
    arrResultsData = [[NSMutableArray alloc] init];
    arrSectionData = [[NSMutableArray alloc] init];
    
    /***********************************
     TOP BAR
    ***********************************/
    
    titleBarManager = [[OAI_TitleBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40.0)];
    titleBarManager.titleBarTitle = @"Site Inspection Report";
    [titleBarManager buildTitleBar];
    [self.view addSubview:titleBarManager];
    
    /***********************************
     MAIN APP SCREEN
    **********************************/
    
    UIView* vMainWin = [[UIView alloc] initWithFrame:CGRectMake(0.0, titleBarManager.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-40.0)];
    
    //array to hold the segemented control count and button titles
    NSArray* arrSections = [[NSArray alloc] initWithObjects:@"Site Information", @"ENDOALPHA Solution", @"Hospital Information", @"Pre-Install Checks", @"Misc. Info.", nil];
    
    //add a segmented control to top of the screen
    scNav = [[UISegmentedControl alloc] initWithItems:arrSections];
    
    [self resizeSegmentedControlSegments];
    
    CGRect scNavFrame = scNav.frame;
    scNavFrame.origin.y = 5.0;
    scNavFrame.origin.x = (self.view.frame.size.width/2)-(scNavFrame.size.width/2);
    scNav.frame = scNavFrame;
    [scNav setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [scNav addTarget:self action:@selector(scrollToView:) forControlEvents:UIControlEventValueChanged];
        
    [vMainWin addSubview:scNav];
    
    //add the scroll controller
    scrollManager = [[OAI_ScrollView alloc] initWithFrame:CGRectMake(10.0, scNav.frame.origin.y + scNav.frame.size.height + 40.0, self.view.frame.size.width-20.0, self.view.frame.size.height - scNav.frame.size.height)];
    [scrollManager setDelegate:self];
    [scrollManager setContentSize:CGSizeMake(self.view.bounds.size.width * (arrSections.count+1), 1024)];
    scrollManager.layer.borderWidth = 1.0;
    myScrollViewOrigiOffSet = scrollManager.contentOffset;
    
    
    
    float pageX = 0.0;
    float pageY = 0.0;
    float pageW = 768.0;
    float pageH = 1024.0;
    
    for(int i=0; i<arrSections.count+1; i++) {
        
        if(i>0) {
            pageX = pageX + pageW;
        }
        
        //build the section page
        OAI_View* vThisSection = [[OAI_View alloc] initWithFrame:CGRectMake(pageX, pageY, pageW, pageH)];
        
        //add the section title
        NSString* strSectionTitle;
        if (i==0) {
            strSectionTitle = @"Instructions";
        } else {
            strSectionTitle = [arrSections objectAtIndex:i-1];
        }
        
        if (i%2==0) {
            vThisSection.backgroundColor = [UIColor purpleColor];
        } else {
            vThisSection.backgroundColor = [UIColor orangeColor];
        }
        
        OAI_SectionLabel* lblSectionTitle = [[OAI_SectionLabel alloc] initWithFrame:CGRectMake(10.0, 50.0, vThisSection.frame.size.width-30.0, 40.0)];
        lblSectionTitle.text = strSectionTitle;
        [vThisSection addSubview:lblSectionTitle];
        
        //get the section data
        arrSectionData = [self getSectionData:i];
        
        
        //[self buildSectionElements:arrSectionData:vThisSection];
        
        [scrollManager addSubview:vThisSection];
    }
    
        
    [self.view addSubview:scrollManager];
    
    [self.view addSubview:vMainWin];
    
    
    /**********************************
    TITLE SCREEN
    **********************************/
    
    titleScreenManager = [[OAI_TitleScreen alloc] initWithFrame:CGRectMake(0.0, titleBarManager.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-40.0)];
    titleScreenManager.strAppTitle = @"Site Inspection Report";
    [titleScreenManager buildTitleScreen];
    [self.view addSubview:titleScreenManager];
    
    /***********************************
     SPLASH SCREEN
     ***********************************/
    
    //check to see if we need to display the splash screen
    BOOL needsSplash = YES;
    
    if (needsSplash) {
        CGRect myBounds = self.view.bounds;
        appSplashScreen = [[OAI_SplashScreen alloc] initWithFrame:CGRectMake(myBounds.origin.x, myBounds.origin.y, myBounds.size.width, myBounds.size.height)];
        
        //pass the title screen over to the splash screen (so we can run the title screen fade)
        appSplashScreen.myTitleScreen = titleScreenManager;
        
        [self.view addSubview:appSplashScreen];
        [appSplashScreen runSplashScreenAnimation];
    }
    
    /***********************************
     ACCOUNT SCREEN
     ***********************************/
    CGRect accountFrame = CGRectMake(100.0, -350.0, 300.0, 350.0);
    accountManager.frame = accountFrame;
    [accountManager buildAccountObjects];
    [self.view addSubview:accountManager];
    [self.view bringSubviewToFront:titleBarManager];
    
    
}

- (NSMutableArray*) getSectionData : (int) sectionNum {
    
    //init the section data array 
    NSMutableArray* arrThisSectonData = [[NSMutableArray alloc] init];
    
    if (sectionNum == 0) {
        
        //add the section elements
        [arrThisSectonData addObject:
         [[NSDictionary alloc] initWithObjectsAndKeys:
            @"1", @"Column Count",
            @"Text Display", @"Element Type",
            @"Full", @"Element Width", 
            @"Welcome to the AVI Integration Site Report App. Click on any tab above to begin",@"Element Value",
          nil]];
    
    } else if (sectionNum == 1) {
        
        [arrThisSectonData addObject:
         [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          @"Project Number:", @"Element Name",
          @"Text Field", @"Element Type",
          @"NO", @"isRequired",
          @"Medium", @"Element Width",
          @"30", @"Element Height",
          @"1", @"Sub Section",
          nil]];
        
        
        [arrThisSectonData addObject:
         [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          @"Inspection Date:", @"Element Name",
          @"Text Field", @"Element Type",
          @"NO", @"isRequired",
          @"Medium", @"Element Width",
          @"30", @"Element Height",
          @"1", @"Sub Section",
          nil]];
        
        
        [arrThisSectonData addObject:
         [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          @"Prepared By:", @"Element Name",
          @"Text Field", @"Element Type",
          @"NO", @"isRequired",
          @"Medium", @"Element Width",
          @"30", @"Element Height",
          @"1", @"Sub Section",
          nil]];
        
        
        [arrThisSectonData addObject:
         [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          @"Revised Date:", @"Element Name",
          @"Text Field", @"Element Type",
          @"NO", @"isRequired",
          @"Medium", @"Element Width",
          @"30", @"Element Height",
          @"1", @"Sub Section",
          nil]];
        
        
        [arrThisSectonData addObject:
         [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          @"Revised By:", @"Element Name",
          @"Text Field", @"Element Type",
          @"NO", @"isRequired",
          @"Medium", @"Element Width",
          @"30", @"Element Height",
          @"1", @"Sub Section",
          nil]];
    }
    
    return arrThisSectonData;
}

- (void) buildSectionElements : (NSArray*) arrElements : (UIView* ) vParent {
    
    //set a holder for label widths;
    float maxLabelWidth = 0.0;
    
    //get the subview from the section
    NSArray* arrChildren = vParent.subviews;
    //get the title label
    UILabel* lblSectionTitle = [arrChildren objectAtIndex:0];
    
    //build a wrapper for the elements
    UIView* vElementWrapper = [[UIView alloc] initWithFrame:CGRectMake(10.0, lblSectionTitle.frame.origin.y + lblSectionTitle.frame.size.height + 15.0, vParent.frame.size.width-30.0, 100.0)];
    vElementWrapper.userInteractionEnabled = YES;
    
    //set the elements coords
    float elementX = 10.0;
    float element2X = 0.0;
    float elementY = 0.0;
    float elementW = 0.0;
    float elementH = 0.0;
    
    //loop through the elements
    for(int i=0; i<arrElements.count; i++) {
        
        //get the element dictionary
        NSDictionary* dictElementData = [arrElements objectAtIndex:i];
        
        //get the type
        NSString* strElementType = [dictElementData objectForKey:@"Element Type"];
        //get the width
        NSString* strElementWidth = [dictElementData objectForKey:@"Element Width"];
        
        //get the label value - check is for instructions page versus form page
        NSString* strElementLabelValue;
        if ([strElementType isEqualToString:@"Text Display"]) { 
            strElementLabelValue = [dictElementData objectForKey:@"Element Value"];
        } else {
            strElementLabelValue = [dictElementData objectForKey:@"Element Name"];
        }
        
        if ([strElementWidth isEqualToString:@"Full"]) {
            elementW = vElementWrapper.frame.size.width;
        } else if ([strElementWidth isEqualToString:@"Medium"]) {
            elementW = vElementWrapper.frame.size.width/2;
        }
        
        //add the element label
        CGSize labelConstraintSize = CGSizeMake(elementW, 999.0);
        CGSize elementSize = [strElementLabelValue sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0] constrainedToSize:labelConstraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
        OAI_Label* lblElementLabel = [[OAI_Label alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementSize.height)];
        lblElementLabel.text = strElementLabelValue;
        [vElementWrapper addSubview:lblElementLabel];
        
        //check if this is the widest label
        if (elementSize.width > maxLabelWidth) {
            maxLabelWidth = elementSize.width;
        }
        
        //increment elementX
        element2X = lblElementLabel.frame.origin.x + lblElementLabel.frame.size.width + 20.0;
        
        //get elementH
        elementH = [[dictElementData objectForKey:@"Element Height"] floatValue];
        
        //reduce the width by 20.0 because of the margin between label and element
        elementW = elementW-20.0;
        
        //set up frame to pass to element build method
        CGRect elementFrame = CGRectMake(element2X, elementY, elementW, elementH);
        
        //add the element
        if ([strElementType isEqualToString:@"Text Field"]) {
            
            [self addTextField:vElementWrapper:elementFrame];
        }
        
        //increment y
        elementY = elementY + elementSize.height + 20.0;
                
    }
    
    //go through the wrapper and reset all the x locations of the elements to maxLabelWidth + 20.0;
    NSArray* arrElementSubs = vElementWrapper.subviews;
    for(int i=0; i<arrElementSubs.count; i++) {
        
        if (![[arrElementSubs objectAtIndex:i] isMemberOfClass:[OAI_Label class]]) {
            
            UIView* thisObject = [arrElementSubs objectAtIndex:i];
            CGRect objFrame = thisObject.frame;
            objFrame.origin.x = maxLabelWidth + 40.0;
            thisObject.frame = objFrame;
            
            [vElementWrapper bringSubviewToFront:thisObject];
        
        } else {
            
            OAI_Label* thisLabel = (OAI_Label*)[arrElementSubs objectAtIndex:i];
            CGRect thisLabelFrame = thisLabel.frame;
            thisLabelFrame.size.width = maxLabelWidth + 10.0;
            thisLabel.frame = thisLabelFrame;
            
        }
    }
    
    [vParent addSubview:vElementWrapper];
    [vParent bringSubviewToFront:vElementWrapper];
    
}

#pragma mark - Form Elements

- (void) addTextField:(UIView *)myWrapper : (CGRect) myFrame {
    
    OAI_TextField* thisTextField = [[OAI_TextField alloc] initWithFrame:myFrame];
    [myWrapper addSubview:thisTextField];
    
}

#pragma mark - Scroll To View

- (void) scrollToView : (UISegmentedControl*) control {
    
    //get the selected index from the segemented control
    int selectedIndex = control.selectedSegmentIndex + 1;
    
    //set up a point
    float pageX = selectedIndex * 768.0;
    float pageY = 0.0;
    CGPoint scrollOffset = CGPointMake(pageX, pageY);
    
    //reset the my origi offset (so when keyboard is dismissed scroll remains on page)
    myScrollViewOrigiOffSet = scrollOffset;
    
    //move the scroll offset to that point
    [scrollManager setContentOffset:scrollOffset animated:YES];
    
}




#pragma mark - Segmented Control Methods
- (void) resizeSegmentedControlSegments {
    
    NSArray* segments = scNav.subviews;
    
    //loop
    for(int i=0; i<segments.count; i++) {
        
        //get the segment
        UIView* aSegment = [segments objectAtIndex:i];
        //get the segment subviews
        NSArray* aSegmentSubviews = aSegment.subviews;
        
        //loop
        for(UILabel* segmentLabel in aSegmentSubviews) {
            
            //make sure it is a UILabel
            if ([segmentLabel isKindOfClass:[UILabel class]]) {
                
                //get the text value
                NSString* segmentText = segmentLabel.text;
                
                CGSize segmentTextSize = [segmentText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
                
                [scNav setWidth:segmentTextSize.width-5.0 forSegmentAtIndex:i];
                
            }
        }
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
