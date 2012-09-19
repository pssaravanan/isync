//
//  ViewController.m
//  isync
//
//  Created by saravanp on 13/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import "ViewController.h"
#import "GmailContactsParser.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
-(IBAction)synchronizeButtonPressed:(id)sender{
    NSString *gmailIDRetrieved=GmailID.text;
    NSString *gmailPasswordRetrieved=GmailPassword.text;
    NSString *appleIDRetrieved=AppleID.text;
    NSString *applePasswordRetrieved=ApplePassword.text;
    AuthTokenFetcher *authTokenFetcher=[[AuthTokenFetcher alloc]init];
    [authTokenFetcher fetchAuthTokenWithGmailId:gmailIDRetrieved GmailPassword:gmailPasswordRetrieved AppleID:appleIDRetrieved ApplePassword:applePasswordRetrieved];
    //[GmailContactsParser parseGmailContacts];
 
    
    
}

@end
