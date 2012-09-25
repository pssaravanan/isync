//
//  GmailIPhoneSyncer.m
//  isync
//
//  Created by Nithya on 22/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "GmailIPhoneSyncer.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"

@implementation GmailIPhoneSyncer
- (void)SyncGmailId:(NSString *)gmailId GmailPass:(NSString *)gmailpass AppleId:(NSString *)appleId ApplePass:(NSString *)applepass{

    /****Steps****/
    //gmail Auth
    //gmail fetch
    //gmail parse
        //[contacts]
    //phone fetch
        //[contacts]
    //Merge
        //G'[] P'[]
    //Phone Update
    //Google generate XML
    //Google Update contacts
    
    
    
    /**Implementation**/
    //gmail auth:
    AuthTokenFetcher *authTokenFetcher=[[AuthTokenFetcher alloc]init];
    [authTokenFetcher fetchAuthTokenWithGmailId:gmailId GmailPassword:gmailpass AppleID:appleId ApplePassword:applepass CallbackObj:self];
}

- (void) authTokenFetched: (NSString *) token{
    NSLog(@"%@\n%@",@"authToken Fetched",token);
    [[[GmailContactsFetcher alloc] init] fetchGmailContactswithAuthToken:token CallbackObj:self];
}
-(void) contactsFetched:(NSMutableData*)contactsResponse{
    NSArray *IPhoneContactList=[ABAddressBookInf getAddressContactList];
    
    NSArray *GmailContactList=[ABAddressBookInf constructAddressBookListAfterParsing:contactsResponse];
    
}
@end
