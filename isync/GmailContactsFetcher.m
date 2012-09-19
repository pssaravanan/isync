//
//  GmailContactsFetcher.m
//  isync
//
//  Created by Admin on 18/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "GmailContactsFetcher.h"
@interface GmailContactsFetcher ()

@property(nonatomic, strong) NSMutableData *responseData;

@end

@implementation GmailContactsFetcher
@synthesize responseData = _responseData;
-(void)fetchGmailContactswithAuthToken:(NSString *)authToken{
    NSLog(@"View Loaded");
    self.responseData = [NSMutableData data];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.google.com/m8/feeds/contacts/default/full"]];
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
    NSLog(@"conn");
    NSLog(@"Success..Received %d bytes",[self.responseData length]);
    NSString *results = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(results);
   
}



@end
