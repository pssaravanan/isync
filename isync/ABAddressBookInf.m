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
+(NSArray *)constructAddressBookListAfterParsing:(NSMutableData *)xmlData{
    NSError *xmlError;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&xmlError];
    if (doc == nil) { return NULL; }
    NSLog(@"%@", doc.rootElement);
    NSArray *allContacts = [doc.rootElement elementsForName:@"entry"];
    NSLog(@"%u",allContacts.count);
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    for (GDataXMLElement *contactElement in allContacts) {
        
        ABRecordRef newRecord = ABPersonCreate();
        NSString *name = [[[contactElement elementsForName:@"title"] objectAtIndex:0] stringValue];
        ABRecordSetValue(newRecord, kABPersonFirstNameProperty,name , &error);
        //Email
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *emailElement=[contactElement elementsForName:@"gd:email"];
        for(GDataXMLElement *element in emailElement){
            NSString *emailAddress = [[element attributeForName:@"address"] stringValue];
            NSString *label = [[element attributeForName:@"rel"]stringValue];
            if([label rangeOfString:@"home"].length != 0){
                ABMultiValueAddValueAndLabel(multiEmail, emailAddress, kABHomeLabel, NULL);
            }
            if([label rangeOfString:@"work"].length != 0){
                ABMultiValueAddValueAndLabel(multiEmail, emailAddress, kABWorkLabel, NULL);
            }
            if([label rangeOfString:@"other"].length != 0){
                ABMultiValueAddValueAndLabel(multiEmail, emailAddress, kABOtherLabel, NULL);
            }
            NSLog(@"%@",emailAddress);
            
        }
        ABRecordSetValue(newRecord, kABPersonEmailProperty, multiEmail, &error);
        
        NSArray *phoneNumbers = [contactElement elementsForName:@"gd:phoneNumber"];
        ABMultiValueRef phoneNumberRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for(GDataXMLElement *phoneNumber in phoneNumbers){
            NSString *phone = [phoneNumber stringValue];
            NSLog(@"%@", phone);
            NSString *label = [[phoneNumber attributeForName:@"rel"]stringValue];
            if(label == (id)[NSNull null] || label.length == 0){
                label = [[phoneNumber attributeForName:@"label"] stringValue];
            }
            if([label rangeOfString:@"main"].length != 0){
                ABMultiValueAddValueAndLabel(phoneNumberRef, phone, kABPersonPhoneMainLabel, NULL);
            }
            if([label rangeOfString:@"mobile"].length != 0){
                ABMultiValueAddValueAndLabel(phoneNumberRef, phone, kABPersonPhoneMobileLabel, NULL);
            }
            
        }
        ABRecordSetValue(newRecord, kABPersonPhoneProperty, phoneNumberRef, &error);
        
        ABAddressBookAddRecord(addressBook, newRecord, &error);
//        ABAddressBookSave(addressBook, &error);
        NSLog(@"%@",newRecord);
        if(error != NULL){
            NSLog(@"Save Failed");
        }
    }
   NSArray *GmailContactList=(NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    [doc release];
    [xmlData release];
    return GmailContactList;
}
@end
