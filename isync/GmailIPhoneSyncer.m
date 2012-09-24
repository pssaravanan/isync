//
//  GmailIPhoneSyncer.m
//  isync
//
//  Created by Nithya on 22/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "GmailIPhoneSyncer.h"
#import "AuthTokenFetcher.h"

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
    [authTokenFetcher fetchAuthTokenWithGmailId:gmailId GmailPassword:gmailpass AppleID:appleId ApplePassword:applepass Delegate:self];
}

- (id) parseXML: (NSString *) xmlData{
    NSLog(@"%@",@"inside ParseXML");
    [[[UIAlertView alloc] initWithTitle:@"contacts fetched" message:@"Contacts were fetched." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}
@end
