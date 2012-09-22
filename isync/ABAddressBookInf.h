//
//  ABAddressBookInf.h
//  isync
//
//  Created by Nithya on 19/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
@interface ABAddressBookInf : NSObject
+(NSArray *)getAddressContactList;
+(void)constructAddressBookListAfterParsing:(NSMutableData *)xmlData;
@end
