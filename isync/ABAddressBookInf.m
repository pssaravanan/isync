//
//  ABAddressBookInf.m
//  isync
//
//  Created by Nithya on 19/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "ABAddressBookInf.h"
#import "GDataXMLNode.h"
@implementation ABAddressBookInf
+( NSArray* )getAddressContactList{
    ABAddressBookRef addressBook =  ABAddressBookCreate();
    NSArray * peopleList = ( NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    return peopleList;
}
+(void)constructAddressBookListAfterParsing:(NSMutableData *)xmlData{
    NSLog(@"SUCCESS\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return; }
    NSLog(@"%@", doc.rootElement);
    NSArray *allContacts = [doc.rootElement elementsForName:@"entry"];
    NSLog(@"COUNT////////////");
    NSLog(@"%u",allContacts.count);
    for (GDataXMLElement *contactElement in allContacts) {
        
        NSString *name = [[[contactElement elementsForName:@"title"] objectAtIndex:0] stringValue];
        NSLog(@"%@",name);
        
        NSString *phone = [[[contactElement elementsForName:@"gd:phoneNumber"] objectAtIndex:0] stringValue];
        NSLog(@"%@",phone);
        
        NSString *postalAddress = [[[contactElement elementsForName:@"gd:postalAddress"] objectAtIndex:0] stringValue];
        NSLog(@"%@",postalAddress);
        
        NSArray *emailElement=[contactElement elementsForName:@"gd:email"];

        NSString *emailAddress=[(GDataXMLNode *)[[emailElement objectAtIndex:0] attributeForName:@"address"] stringValue];
        NSLog(@"%@",emailAddress);

    }
    
    [doc release];
    [xmlData release];
    return;
}
@end
