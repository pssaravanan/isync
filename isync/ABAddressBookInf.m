//
//  ABAddressBookInf.m
//  isync
//
//  Created by Nithya on 19/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "ABAddressBookInf.h"
@implementation ABAddressBookInf
+( NSArray* )getAddressContactList{
    ABAddressBookRef addressBook =  ABAddressBookCreate();
    NSArray * peopleList = ( NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    return peopleList;
}
@end
