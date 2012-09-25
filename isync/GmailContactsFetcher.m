#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"

@interface NSObject(){
}
-(void)contactsFetched:(NSMutableData*)contactsResponse;
@end

@interface GmailContactsFetcher (){
    id syncerObject;
}

@property(nonatomic, strong) NSMutableData *responseData;

@end

@implementation GmailContactsFetcher
@synthesize responseData = _responseData;
-(void)fetchGmailContactswithAuthToken:(NSString *)authToken CallbackObj:(id)callbackObj{
    NSLog(@"View Loaded");
    self.responseData = [NSMutableData data];
    syncerObject=callbackObj;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.google.com/m8/feeds/contacts/default/full?max-results=2500"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *authFieldValue=[@"GoogleLogin auth=\"" stringByAppendingString:authToken];
    authFieldValue=[authFieldValue stringByAppendingString:@"\""];
    
    [request setValue:authFieldValue forHTTPHeaderField:@"Authorization"];
    [[NSURLConnection alloc] initWithRequest:request delegate: self];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response");
    [self.responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connection Error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Connected..");
    NSLog(@"Success..Received %d bytes",[self.responseData length]);
    [syncerObject contactsFetched:self.responseData];
}



@end
