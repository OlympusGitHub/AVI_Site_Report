//
//  OAI_FileManager.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/14/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAI_FileManager : NSObject {
    
    NSFileManager* fileManager;
    NSString* documentsDirectory;
   
    
}



+(OAI_FileManager* )sharedFileManager;

- (NSDictionary* ) readPlist : plistToRead;

- (BOOL) writeToPlist : (NSString* ) plistToWrite : (NSDictionary* ) plistData;

- (void) createDirectory : (NSString* ) directoryName;

- (void) createPlist : (NSString* ) filePath;

- (BOOL) checkIfExists : (NSString* ) fileName;

- (NSString* ) dateToString : (NSDate* ) dateToConvert;

@end
