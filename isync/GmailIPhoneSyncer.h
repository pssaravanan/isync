//
//  GmailIPhoneSyncer.h
//  isync
//
//  Created by Nithya on 22/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmailIPhoneSyncer : NSObject{
}
- (void)SyncGmailId:(NSString *)gmailId GmailPass:(NSString *)gmailpass AppleId:(NSString *)appleId ApplePass:(NSString *)applepass;
- (id) parseXML:(NSString *) xmlData;
@end
