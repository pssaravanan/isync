#import <Foundation/Foundation.h>

@interface GmailIPhoneSyncer : NSObject{
}
@property(nonatomic,retain)NSString *authToken;
- (void) SyncGmailId:(NSString *)gmailId GmailPass:(NSString *)gmailpass
             AppleId:(NSString *)appleId ApplePass:(NSString *)applepass;
- (void) authTokenFetched: (NSString *) token;
@end
