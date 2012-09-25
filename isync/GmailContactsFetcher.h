#import <Foundation/Foundation.h>

@interface GmailContactsFetcher : NSObject{
    
}

-(void)fetchGmailContactswithAuthToken:(NSString *)authToken CallbackObj:(id)callbackObj;
@end
