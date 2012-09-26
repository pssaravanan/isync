//
//  GService.h
//  isync
//
//  Created by saravanp on 26/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GData.h"
#import "GDataContacts.h"

@interface GService : NSObject
+(NSString *) userName;
+(NSString *) passWord;
+(GDataServiceGoogleContact *) service;
+(GDataServiceGoogleContact *) authenticateWithUserName:(NSString *)username passWord:(NSString *)password;
+(GDataServiceGoogleContact *)getService;
@end
