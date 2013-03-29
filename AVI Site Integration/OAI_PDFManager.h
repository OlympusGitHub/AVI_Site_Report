//
//  OAI_PDFManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "OAI_ColorManager.h"
#import "OAI_StringManager.h"

#define kBorderInset            72.0
#define kBorderWidth            1.0
#define kMarginInset            72.0
#define kLineWidth              1.0

@interface OAI_PDFManager : NSObject {
    
    OAI_ColorManager* colorManager;
    OAI_StringManager* stringManager;

}

@property (nonatomic, retain) NSString* strTableTitle;
@property (nonatomic, retain) NSMutableDictionary* dictResults;

+(OAI_PDFManager* )sharedPDFManager;

- (void) makePDF : (NSString*) fileName : (NSDictionary*) results;

- (void) generatePdfWithFilePath: (NSString *)thefilePath : (NSDictionary*) results;

- (void) drawText : (NSString* ) textToDraw : (CGRect) textFrame : (UIFont*) textFont : (UIColor*) textColor : (int) textAlignment;

- (void) drawImage : (UIImage*) imageToDraw : (CGRect) imageFrame;

- (void) drawLine : (float) lineWidth : (UIColor*) lineColor : (CGPoint) startPoint : (CGPoint) endPoint;

- (void) drawBorder : (UIColor*) borderColor :  (CGRect) rectFrame;

- (float) getStringHeight : (NSString* ) stringToMeasure : (float) widthConstraint : (UIFont*) thisFont;

- (float) getMaxHeaderHeight : (NSArray*) headers : (UIFont*) font ;

- (void) setHeaderText : (NSArray*) headers : (UIFont*) font : (float) headerX : (float) headerY : (float) headerW : (float) headerH : (UIColor*) textColor;

- (void) buildAlternatingTableRows : (NSArray*) rowHeaders : (UIColor* ) color1 : (UIColor* ) color2 : (float) rowX : (float) rowY : (float) endRowX : (float) endRowY : (float) lineWidth;

- (void) setRowText : (NSArray* ) rowCellContents : (float) strX : (float) strY : (float) strW : (float) strH : (UIColor*) textColor : (UIFont*) font;

- (NSArray* ) gatherCellData : (NSDictionary*) theResults : (NSString* ) key;

@end
