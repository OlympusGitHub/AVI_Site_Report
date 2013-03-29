//
//  OAI_FileManager.m
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/14/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import "OAI_FileManager.h"

@implementation OAI_FileManager


+(OAI_FileManager *)sharedFileManager {
    
    static OAI_FileManager* sharedFileManager;
    
    @synchronized(self) {
        
        if (!sharedFileManager)
            
            sharedFileManager = [[OAI_FileManager alloc] init];
        
        return sharedFileManager;
        
    }
    
}

-(id)init {
    
    if (self = [super init]) {
        
        //set up a file manager and error container
       fileManager=[NSFileManager defaultManager];
        
        //docs directory path
        documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        
    }
    
    return self;
}

- (NSDictionary* ) readPlist : (NSString* ) plistToRead {
    NSLog(@"ok");
    //set up an error 
    NSError* error;
    
    //set path to plist to read in docs directory
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent:plistToRead];
    
    //check to see if the file exists
    if ([fileManager fileExistsAtPath:plistPath]) {
        
        //read file
        NSDictionary* fileData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        return fileData;
        
    } else {
        
        //file doesn't exist in doc directory, check to see if it is in the bundle
        NSString *sourcePath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:plistToRead];
        
        if ([fileManager fileExistsAtPath:sourcePath]) { 
            
            //copy the file from the bundle to the docs directory
            bool success = [fileManager copyItemAtPath:sourcePath toPath:plistPath error:&error];
            
            if (success) {
                
                //read file
                NSDictionary* fileData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
                return fileData;
            }
        
        } else {
            
            
        
        }
        
    }
    
    return 0;
}

- (BOOL) writeToPlist : (NSString* ) plistToWrite : (NSDictionary* ) plistData {
    
    BOOL success = YES;
    
    //set path to plist to read in docs directory
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent:plistToWrite];
    
    if ([fileManager fileExistsAtPath:plistPath]) {
        
        success = [plistData writeToFile:plistPath atomically:YES];
    }
    
    if (success) {
        return YES;
    } else {
        return NO;
    }
    
}

- (void) createPlist : (NSString* ) filePath {
    
    //set path to plist to read in docs directory
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    //if it doesn't exists, create it
    if(![fileManager fileExistsAtPath:plistPath]) {
        
        //break the path apart
        NSArray* plistPathItems = [plistPath componentsSeparatedByString:@"/"];
        
        //get the last item (this is our filename)
        NSString* fileName = [plistPathItems objectAtIndex:plistPathItems.count-1];
        
        //create a dictionary and populate with filename
        NSDictionary* dataDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        fileName, @"File Name",
                                        nil];

        [dataDictionary writeToFile: plistPath atomically:YES];
    }
    
}

- (void) createDirectory : (NSString* ) directoryName {
    
    //set up a holder for any errors
    NSError* error;
    
    //set path to the directory
    NSString* directoryPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", directoryName]];
    
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
        
    if (!exists){
        
        if([fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error]) { 
            ;// success
        } else {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    } 
}

//check if plist exists
- (BOOL) checkIfExists : (NSString* ) filePath {
    
    //set path to plist to read in docs directory
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    if(![fileManager fileExistsAtPath:plistPath]) {
        return NO;
    } else {
        return YES;
    }
}



- (NSString* ) dateToString : (NSDate* ) dateToConvert {
   
    //format the date string
    NSDateFormatter* formatter;
    NSString* dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy Time: HH:mm:ss"];
    
    dateString = [formatter stringFromDate:dateToConvert];
    
    return dateString;
    
}


@end
