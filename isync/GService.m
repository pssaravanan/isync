//
//  GService.m
//  isync
//
//  Created by saravanp on 26/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "GService.h"

@implementation GService

static NSString *userName;
static NString *passWord;
static GDataServiceGoogleContact *service;

+(GDataServiceGoogleContact *) authenticateWithUserName:(NSString *)username passWord:(NSString *)password{
    [service setUserCredentialsWithUsername:username
                                   password:password];
    return service;
}

+(GDataServiceGoogleContact *)getService{
    return service;
}
@end

