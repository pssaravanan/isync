#import <Foundation/Foundation.h>

@protocol FetcherDelegate <NSObject>

-(void) fetched;

@end


@interface AuthTokenFetcher : NSObject {
    NSString *AuthToken;
    id <FetcherDelegate> delegate;
}

@property(nonatomic,weak) id<FetcherDelegate> delegate;
@property(nonatomic,strong) NSString *AuthToken;

-(void)fetchAuthTokenWithGmailId:(NSString *)GmailID GmailPassword:(NSString *)GmailPassword
                         AppleID:(NSString *)AppleID ApplePassword:(NSString *)ApplePassword
                         CallbackObj:(id)callbackObj;

@end
