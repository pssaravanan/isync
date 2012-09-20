//
//  AuthTokenFetcher.m
//  isync
//
//  Created by Admin on 17/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "AuthTokenFetcher.h"
#include "GmailContactsFetcher.h"

@interface AuthTokenFetcher()
@property(nonatomic,strong)NSMutableData *responseData;
@end

@implementation AuthTokenFetcher
@synthesize AuthToken=_AuthToken;
@synthesize responseData=_responseData;


-(void)fetchAuthTokenWithGmailId:(NSString *)GmailID GmailPassword:(NSString *)GmailPassword AppleID:(NSString *)AppleID ApplePassword:(NSString *)ApplePassword{
    
    self.responseData = [NSMutableData data];
    NSString *post = [NSString stringWithFormat:@"Email=%@&Passwd=%@&accountType=GOOGLE&service=cp",GmailID, GmailPassword];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
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

    NSRange range=[results rangeOfString:@"Auth="];
    if (range.length>0) {
        NSUInteger fromIndex = range.location;
        self.AuthToken = [results substringFromIndex:fromIndex + range.length];
    
        NSUInteger toIndex = [self.AuthToken rangeOfString:@"\n"].location;
        self.AuthToken = [self.AuthToken substringToIndex:toIndex];

        GmailContactsFetcher *gmailContactsFetcher=[[GmailContactsFetcher alloc]init];
        [gmailContactsFetcher fetchGmailContactswithAuthToken:self.AuthToken];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Invalid Username\/Password!Try Again!!!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



@end
