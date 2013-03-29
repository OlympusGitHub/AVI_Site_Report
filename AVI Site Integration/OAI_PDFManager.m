//
//  OAI_PDFManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_PDFManager.h"

@implementation OAI_PDFManager {
    
    CGSize pageSize;
}

@synthesize strTableTitle, dictResults;

+(OAI_PDFManager *)sharedPDFManager {
    
    static OAI_PDFManager* sharedPDFManager;
    
    @synchronized(self) {
        
        if (!sharedPDFManager)
            
            sharedPDFManager = [[OAI_PDFManager alloc] init];
        
        return sharedPDFManager;
        
    }
    
}

-(id)init {
    return [self initWithAppID:nil];
}

-(id)initWithAppID:(id)input {
    if (self = [super init]) {
        
        /* perform your post-initialization logic here */
        colorManager = [[OAI_ColorManager alloc] init];
        stringManager = [[OAI_StringManager alloc] init];
    }
    return self;
}

- (void) makePDF : (NSString*) fileName : (NSDictionary*) results {
    
    pageSize = CGSizeMake(612, 792);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [self generatePdfWithFilePath:pdfFileName:results];
    
}

- (void) generatePdfWithFilePath: (NSString *)thefilePath : (NSDictionary*) results {
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    BOOL done = NO;
    
    do {
        
        //set up our font styles
        UIFont* headerFont = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        UIFont* contentFont = [UIFont fontWithName:@"Helvetica" size:13.0];
        UIFont* tableFont = [UIFont fontWithName:@"Helvetica" size:10.0];
        UIFont* tableFontBold = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        
        //set up a some constraints
        CGSize pageConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
        
        //set up a color holdr
        UIColor* textColor;
        
        //set up a line width holder
        float lineWidth;
        
        //O logo
        UIImage* imgLogo = [UIImage imageNamed:@"OA_img_logo_pdf.png"];
        
        /*************************COVER PAGE*********************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add the olympus logo to top of page
        CGRect imgLogoFrame = CGRectMake(312-(imgLogo.size.width/2), (pageSize.height/3), imgLogo.size.width, imgLogo.size.height);
        [self drawImage:imgLogo :imgLogoFrame];
        
        NSString* strPDFTitle = @"EBUS Break Even Results For NAME OF FACILITY GOES HERE";
        textColor = [colorManager setColor:8 :16 :123];
        CGSize PDFTitleSize = [strPDFTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect PDFTitleFrame = CGRectMake((pageSize.width/2)-(PDFTitleSize.width/2), imgLogoFrame.origin.y + imgLogoFrame.size.height + 50.0, PDFTitleSize.width, PDFTitleSize.height);
        [self drawText:strPDFTitle :PDFTitleFrame :headerFont :textColor :0];

        
        /*********************PAGE 1****************************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add page title
        NSString* strPageTitle = @"EBUS Break Even Results";
        CGSize pageTitleSize = [strPageTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect pageTitleFrame = CGRectMake((pageSize.width/2)-(pageTitleSize.width/2), 30.0, pageTitleSize.width, pageTitleSize.height);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:strPageTitle :pageTitleFrame :headerFont:textColor:1];
        
        //add some intro text
        NSString* strIntroText = @" Thank you for your interest in Olympus products. Included below are your break even figures on EBUS equipment.";
        CGSize introTextSize = [strIntroText sizeWithFont:contentFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect introTextFrame = CGRectMake((pageSize.width/2)-(introTextSize.width/2), pageTitleFrame.origin.y + pageTitleFrame.size.height + 10.0, introTextSize.width, introTextSize.height);
        textColor = [colorManager setColor:66.0:66.0:66.0];
        [self drawText:strIntroText :introTextFrame :contentFont:textColor:1];
        
        //input section
        NSString* strInput = @"Input";
        textColor = [colorManager setColor:8 :16 :123];
        CGSize inputSize = [strInput sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect inputFrame = CGRectMake(kMarginInset, introTextFrame.origin.y + introTextFrame.size.height + 10.0, inputSize.width, inputSize.height);
        [self drawText:strInput :inputFrame :headerFont:textColor:1];
        
        //make border rectangle
        UIColor* borderColor = [colorManager setColor:231 :232 :141];
        
        //make border rect
        CGRect borderFrame = CGRectMake(kMarginInset, inputFrame.origin.y+inputFrame.size.height+10.0, pageSize.width-(kMarginInset*2), 121.0);
        
        [self drawBorder:borderColor:borderFrame];
       
        //add background for input section
        UIColor* bgRectColor = [colorManager setColor:252:255:209];
        CGPoint bgRectStartPoint = CGPointMake(kMarginInset,inputFrame.origin.y+inputFrame.size.height + 70.0);
        CGPoint bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), inputFrame.origin.y+inputFrame.size.height + 70.0);
        lineWidth = kLineWidth*120;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add input data
        NSString* strQuoteHeader = @"Total Cost of EBUS Equipment From Quote:";
        NSString* strDownstreamHeader = @"Amount of Downstream Revenue Generated Per Patient:";
        NSString* strNetMarginHeader = @"Percent of Net Profit Margin Generated From Downstream Procedures:";
        
        //the header constrant is going to be used to constrain all the sizes
        CGSize baseSize = [strDownstreamHeader sizeWithFont:contentFont];
        CGSize headerConstraint = CGSizeMake(baseSize.width, 999.0);
        CGSize quoteSize = [strQuoteHeader sizeWithFont:contentFont constrainedToSize:headerConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGSize downstreamSize = [strDownstreamHeader sizeWithFont:contentFont constrainedToSize:headerConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGSize netMarginSize = [strNetMarginHeader sizeWithFont:contentFont constrainedToSize:headerConstraint lineBreakMode:NSLineBreakByWordWrapping];
        
        //set the text color
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        
        //set the frames
        CGRect quoteFrame = CGRectMake(bgRectStartPoint.x + 10.0, bgRectStartPoint.y-50.0, quoteSize.width, quoteSize.height);
        CGRect downstreamFrame = CGRectMake(bgRectStartPoint.x + 10.0, quoteFrame.origin.y+quoteFrame.size.height+10.0, downstreamSize.width, downstreamSize.height);
        CGRect netMarginFrame = CGRectMake(bgRectStartPoint.x + 10.0, downstreamFrame.origin.y+downstreamFrame.size.height+10.0, netMarginSize.width, netMarginSize.height);
        
        [self drawText:strQuoteHeader :quoteFrame :contentFont:textColor:0];
        [self drawText:strDownstreamHeader :downstreamFrame :contentFont:textColor:0];
        [self drawText:strNetMarginHeader :netMarginFrame :contentFont:textColor:0];
        
        //add the values
        NSString* strQuoteValue = [results objectForKey:@"Equipment Quote"];
        NSString* strDownstreamValue = [results objectForKey:@"Downstream Revenue"];
        NSString* strNetProfit = [results objectForKey:@"Net Profit"];
                
        //make the frames for the values
        CGRect quoteValueFrame = CGRectMake(430.0, bgRectStartPoint.y-50.0, 100.0, 30.0);
        CGRect downstreamValueFrame = CGRectMake(430.0, quoteValueFrame.origin.y+quoteValueFrame.size.height, 100.0, 30.0);
        CGRect netProfitValueFrame = CGRectMake(430.0, downstreamValueFrame.origin.y+downstreamValueFrame.size.height, 100.0, 30.0);
        
        [self drawText:strQuoteValue :quoteValueFrame :contentFont:textColor:0];
        [self drawText:strDownstreamValue :downstreamValueFrame :contentFont:textColor:0];
        [self drawText:strNetProfit :netProfitValueFrame :contentFont:textColor:0];
        
        //results section
        NSString* strResults = @"Results";
        textColor = [colorManager setColor:8 :16 :123];
        CGSize resultsSize = [strResults sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect resultsFrame = CGRectMake(kMarginInset, bgRectStartPoint.y+70.0, resultsSize.width, resultsSize.height);
        [self drawText:strResults :resultsFrame :headerFont:textColor:1];
        
        //make border rectangle
        borderColor = [colorManager setColor:8 :16 :123];
        
        //make border rect
        borderFrame = CGRectMake(kMarginInset, resultsFrame.origin.y+resultsFrame.size.height+10.0, pageSize.width-(kMarginInset*2), 121.0);
        
        [self drawBorder:borderColor:borderFrame];

        
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,resultsFrame.origin.y+resultsFrame.size.height + 70.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), resultsFrame.origin.y+resultsFrame.size.height + 70.0);
        lineWidth = kLineWidth*120;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //headers
        NSString* strProceduresHeader = @"Number of Procedures Required To Break Even (On Capital Cost):";
        NSString* strWeeklyHeader = @"Weekly Procedure Volume Necessary To Break Even:";
        
        //sizes
        headerConstraint = CGSizeMake(250.0, 999.0);
        CGSize procedureSize = [strProceduresHeader sizeWithFont:contentFont constrainedToSize:headerConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGSize weeklySize = [strWeeklyHeader sizeWithFont:contentFont constrainedToSize:headerConstraint lineBreakMode:NSLineBreakByWordWrapping];
        
        //frames
        CGRect procedureFrame = CGRectMake(bgRectStartPoint.x+10.0, resultsFrame.origin.y+resultsFrame.size.height+20.0, procedureSize.width, procedureSize.height);
        CGRect weeklyFrame = CGRectMake(bgRectStartPoint.x+10.0, procedureFrame.origin.y+procedureFrame.size.height+10.0, weeklySize.width, weeklySize.height);
        
        [self drawText:strProceduresHeader:procedureFrame:contentFont:textColor:0];
        [self drawText:strWeeklyHeader:weeklyFrame:contentFont:textColor:0];
        
        //add the values
        NSString* strProcedureValue = [results objectForKey:@"Procedure Count"];
        NSString* strWeekValue = [results objectForKey:@"Week Count"];
                
        //frames
        CGRect procedureValueFrame = CGRectMake(430.0, resultsFrame.origin.y+resultsFrame.size.height+20.0, 100.0, 30.0);
        CGRect weekValueFrame = CGRectMake(430.0, procedureFrame.origin.y+procedureFrame.size.height+10.0, 100.0, 30.0);
        
        [self drawText:strProcedureValue :procedureValueFrame :contentFont:textColor:0];
        [self drawText:strWeekValue :weekValueFrame :contentFont:textColor:0];
        
        /************************NOTES PAGES**********************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add page title
        NSString* strNotesTitle = @"Notes, Assumptions and References";
        CGSize notesTitleSize = [strNotesTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect notesTitleFrame = CGRectMake((pageSize.width/2)-(notesTitleSize.width/2), 30.0, notesTitleSize.width, notesTitleSize.height);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:strNotesTitle :notesTitleFrame :headerFont:textColor:1];
        
        NSArray* notesArray = stringManager.notesArray;

        //set up some points
        float rowX = kMarginInset;
        float rowY = notesTitleFrame.origin.y + notesTitleFrame.size.height + 20.0;
       
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        NSMutableArray* arrLastFrame = [[NSMutableArray alloc] init];
        
        //loop
        for(int i=0; i<notesArray.count; i++) {
            
            NSArray* rowItems = [notesArray objectAtIndex:i];
            
            //bullet list
            if (i<7) {
                            
                for(int r=0; r<rowItems.count; r++) {
                    
                    //increment row x
                    if (r>0) {
                        rowX = 100.0;
                    }
                    
                    NSString* strThisItem = [rowItems objectAtIndex:r];
                    
                    CGSize thisItemSize = [strThisItem sizeWithFont:tableFont constrainedToSize:CGSizeMake(400.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    
                    CGRect thisItemFrame = CGRectMake(rowX, rowY, thisItemSize.width, thisItemSize.height);
                    
                    //add to the lastFrame array
                    [arrLastFrame addObject:NSStringFromCGRect(thisItemFrame)];
                    
                    [self drawText:strThisItem :thisItemFrame :tableFont :textColor :0];
                    
                    //reset row x
                    rowX = kMarginInset;
                }
                
                //increment y
                CGRect lastFrame = CGRectFromString([arrLastFrame objectAtIndex:arrLastFrame.count-1]);
                rowY = lastFrame.origin.y + lastFrame.size.height + 10.0;
            
            } else {
             
                if (i>6 && i<notesArray.count-1) {
                    
                    //get the last bullet entry frame
                    CGRect lastFrame = CGRectFromString([arrLastFrame objectAtIndex:arrLastFrame.count-1]);
                    
                    //make border rectangle
                    UIColor* borderColor = [colorManager setColor:195 :212 :248];
                    
                    //make border rect
                    CGRect borderFrame = CGRectMake(kMarginInset, lastFrame.origin.y+lastFrame.size.height+10.0, pageSize.width-(kMarginInset*2), 271.0);
                    
                   [self drawBorder:borderColor:borderFrame];
                    
                    
                    bgRectColor = [colorManager setColor:248 :250 :255];
                    bgRectStartPoint = CGPointMake(kMarginInset, (borderFrame.origin.y+borderFrame.size.height)-(borderFrame.size.height/2));
                    bgRectEndPoint = CGPointMake(pageSize.width-kMarginInset, (borderFrame.origin.y+borderFrame.size.height)-(borderFrame.size.height/2));
                    lineWidth=kLineWidth*270;
                    
                    //[self drawLine:lineWidth :bgRectColor :bgRectStartPoint :bgRectEndPoint];
                    
                    rowX = rowX + 5.0;
                    rowY = rowY + 5.0;
                    UIFont* rowFont;
                    CGSize rowConstraint;
                    int alignment;
                    CGRect lastRowFrame;
                    
                    for(int r=0; r<rowItems.count; r++) {
                        
                        NSString* strThisRowItem = [rowItems objectAtIndex:r];
                        
                        //table headers
                        if (i==7) {
                           
                            rowFont = tableFontBold;
                            textColor = [colorManager setColor:66:66:66];
                            rowConstraint = CGSizeMake(200.0, 999.0);
                            alignment = 1;
                            
                        } else if (i>7 && i<notesArray.count-1) {
                            
                            rowFont = tableFont;
                            textColor = [colorManager setColor:66:66:66];
                            rowConstraint = CGSizeMake(pageSize.width-(205.0+(kMarginInset*2)), 999.0);
                            alignment = 1;
                        }
                        
                        if (r>0) {
                            //increment x
                            rowX = rowX + 205.0;
                        }
                        
                        CGSize thisRowItemSize = [strThisRowItem sizeWithFont:rowFont constrainedToSize:rowConstraint lineBreakMode:NSLineBreakByWordWrapping];
                        CGRect thisRowFrame = CGRectMake(rowX, rowY, thisRowItemSize.width, thisRowItemSize.height);
                        
                        [self drawText:strThisRowItem :thisRowFrame :rowFont :textColor :alignment];
                        
                        lastRowFrame = thisRowFrame;
                        
                    }
                    
                    rowY = lastRowFrame.origin.y + lastRowFrame.size.height + 10.0;
                    
                    //reset x
                    rowX = kMarginInset;
                    
                } else {
                    
                    //reset x
                    rowX = kMarginInset;
                    rowY = rowY + 40.0;
                    for (int r=0; r<rowItems.count; r++) {
                        
                        NSString* strThisRowItem = [rowItems objectAtIndex:r];
                        
                        CGSize thisRowSize = [strThisRowItem sizeWithFont:tableFont constrainedToSize:CGSizeMake(pageSize.width-(kMarginInset*2), 999.0) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        CGRect thisRowFrame = CGRectMake(rowX, rowY, thisRowSize.width, thisRowSize.height);
                        
                        
                        [self drawText:strThisRowItem :thisRowFrame :tableFont :textColor :0];
                        
                        rowY = thisRowFrame.origin.y + thisRowFrame.size.height + 10.0;
                    }
                }
            }//end i check
            
        }//end loop through notes array
        
        done = YES;
        
    } while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
}

#pragma mark - Drawing Methods

- (void) drawText : (NSString* ) textToDraw : (CGRect) textFrame : (UIFont*) textFont : (UIColor*) textColor : (int) textAlignment {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, textColor.CGColor);
    
    int myTextAlignment = textAlignment;
    
    [textToDraw drawInRect:textFrame withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:myTextAlignment];
}

- (void) drawImage : (UIImage*) imageToDraw : (CGRect) imageFrame  {
    
   [imageToDraw drawInRect:imageFrame];
}

- (void) drawLine : (float) lineWidth : (UIColor*) lineColor : (CGPoint) startPoint : (CGPoint) endPoint  {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, lineWidth);
    CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

- (void) drawBorder : (UIColor*) borderColor :  (CGRect) rectFrame {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
    CGContextSetLineWidth(currentContext, kBorderWidth);
    CGContextStrokeRect(currentContext, rectFrame);
    
}

#pragma mark - Data Gather

- (float) getStringHeight : (NSString* ) stringToMeasure : (float) widthConstraint : (UIFont*) thisFont {
    
    CGSize stringConstraint = CGSizeMake(widthConstraint, 9999.0);
    CGSize stringSize = [stringToMeasure sizeWithFont:thisFont constrainedToSize:stringConstraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return stringSize.height;
    
}

- (float) getMaxHeaderHeight : (NSArray*) headers : (UIFont*) font {
    
    //set a max height for the headers
    float maxHeaderH = 0.0;
    
    for(int i=0; i<headers.count; i++) {
        
        float thisConstraint;
        
        if (i==0) {
            thisConstraint = 140.0;
        } else {
            thisConstraint = (pageSize.width-(kMarginInset*2))/2;
        }
        
        float thisStringHeight = [self getStringHeight:[headers objectAtIndex:i] :thisConstraint:font];
        
        if (thisStringHeight > maxHeaderH) {
            maxHeaderH = thisStringHeight;
        }
    }
    
    return maxHeaderH;

}

- (void) setHeaderText : (NSArray*) headers : (UIFont*) font : (float) headerX : (float) headerY : (float) headerW : (float) headerH : (UIColor*) textColor {
    
    for(int i=0; i<headers.count; i++) {
        
        NSString* strThisHeader = [headers objectAtIndex:i];
        
        if (i>0) {
            headerX = headerX + headerW + 5.0;
            
            if (headerW == 140.0) { 
                headerW = 200.0;
            } else if (headerW == 80.0) {
                if (i>1) { 
                    headerW = 140.0;
                    headerX = headerX + 15.0;
                }
            } else if (headerW == 240.0) {
                headerW = 124.0;
            }
        }
        
        CGRect thisHeaderFrame = CGRectMake(headerX, headerY, headerW, headerH);
        [self drawText:strThisHeader :thisHeaderFrame :font:textColor:0];
    }
}

- (void) buildAlternatingTableRows : (NSArray*) rowHeaders : (UIColor* ) color1 : (UIColor* ) color2 : (float) rowX : (float) rowY : (float) endRowX : (float) endRowY : (float) lineWidth {
    
    for(int i=0; i<rowHeaders.count; i++) {
    
        //build a row
        UIColor* rowColor;
        if (i%2) {
            rowColor = color1;
        } else {
            rowColor = color2;
        }
    
        if(i>0) {
            rowY = rowY + 40.0;
            endRowY = endRowY + 40.0;
        }
        
        CGPoint rowStartPoint = CGPointMake(rowX, rowY);
        CGPoint rowEndPoint = CGPointMake(endRowX, endRowY);
        [self drawLine:lineWidth:rowColor:rowStartPoint:rowEndPoint];
        
    }

    
}

- (void) setRowText : (NSArray* ) rowCellContents : (float) strX : (float) strY : (float) strW : (float) strH : (UIColor*) textColor : (UIFont*) font {
    
    for(int r=0; r<rowCellContents.count; r++) {
        
        NSString* thisRowItem = [rowCellContents objectAtIndex:r];
        
        if (r>0) {
            
            //increment x
            strX = strX + strW + 5.0;
            
            if (strW == 140) { 
                //change row w
                strW = 200.0;
            } else if (strW == 80 && r>1) {
                strW = 140.0;
                strX = strX + 15.0;
            }
        }
        
        CGRect thisRowCellFrame = CGRectMake(strX, strY, strW, strH);
        [self drawText:thisRowItem :thisRowCellFrame :font:textColor:0];
        
    }

    
}

- (NSArray* ) gatherCellData : (NSDictionary*) theResults : (NSString* ) key {
    
    //set up an array to hold the keys to pul from theResults
    NSMutableArray* keyArray = [[NSMutableArray alloc] init];
    for(int i=0; i<3; i++) {
        [keyArray addObject:[NSString stringWithFormat:@"%@ Year %i", key, i+1]];
    }
    
    
    
    //loop through results
    for(NSString* thisKey in theResults) {
     
        if([thisKey hasPrefix:key]) {
            NSArray* thisRowCellData = [[NSArray alloc] initWithObjects:[theResults objectForKey:[keyArray objectAtIndex:0]], [theResults objectForKey:[keyArray objectAtIndex:1]], [theResults objectForKey:[keyArray objectAtIndex:2]],nil];
            
            return thisRowCellData;
        }
        
    }
    
    
    NSArray* thisRowCellData;
    return thisRowCellData;
    
}

@end
