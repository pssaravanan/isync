//
//  GmailContactsParser.m
//  isync
//
//  Created by Admin on 17/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "GmailContactsParser.h"
#import "GDataXMLNode.h"

@implementation GmailContactsParser
+ (NSString *)dataFilePath:(BOOL)forSave {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"GmailContacts.xml"];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"GmailContacts" ofType:@"xml"];
    }}
+ (NSString *)parseGmailContacts {
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    
    NSLog(@"%@", doc.rootElement);
    [doc release];
    [xmlData release];
    return nil;
    
}
@end