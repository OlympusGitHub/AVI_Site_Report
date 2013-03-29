//
//  ViewController.h
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_SplashScreen.h"
#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"
#import "OAI_PDFManager.h"
#import "OAI_AlertScreen.h"
#import "OAI_TitleBar.h"
#import "OAI_TitleScreen.h"
#import "OAI_Account.h"

#import "OAI_ScrollView.h"
#import "OAI_View.h"
#import "OAI_SectionLabel.h"
#import "OAI_Label.h"
#import "OAI_TextField.h"



@interface ViewController : UIViewController <UIScrollViewDelegate>{
    
    OAI_SplashScreen* appSplashScreen;
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    OAI_PDFManager* pdfManager;
    OAI_AlertScreen* alertManager;
    OAI_TitleBar* titleBarManager;
    OAI_TitleScreen* titleScreenManager;
    OAI_Account* accountManager;
    OAI_ScrollView* scrollManager;
    
    /*********Data************/
    NSMutableArray* arrSectionData;
    NSMutableArray* arrResultsData;
    
    /********Nav*************/
    UISegmentedControl* scNav;
    CGPoint myScrollViewOrigiOffSet;
    
}


- (NSMutableArray*) getSectionData : (int) sectionNum;

- (void) buildSectionElements : (NSArray*) arrElements : (UIView* ) vParent;

- (void) scrollToView : (UISegmentedControl*) control;

- (void) addTextField : (UIView*) myWrapper : (CGRect) myFrame;

- (void) resizeSegmentedControlSegments;



@end
