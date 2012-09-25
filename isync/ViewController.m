
#import "ViewController.h"
#import "GmailContactsParser.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"
#import "GmailIPhoneSyncer.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize GmailID,GmailPassword,AppleID,ApplePassword;
- (void)viewDidLoad
{
    [super viewDidLoad];
    GmailPassword.secureTextEntry=YES;
    ApplePassword.secureTextEntry=YES;
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

-(IBAction)hideKeyBoard:(id)sender{
    [GmailID resignFirstResponder];
    [GmailPassword resignFirstResponder];
    [AppleID resignFirstResponder];
    [ApplePassword resignFirstResponder];
}

-(IBAction)synchronizeButtonPressed:(id)sender{

//  NSString *gmailIDRetrieved=GmailID.text;
//  NSString *gmailPasswordRetrieved=GmailPassword.text;
//  NSString *appleIDRetrieved=AppleID.text;
//  NSString *applePasswordRetrieved=ApplePassword.text;
//  AuthTokenFetcher *authTokenFetcher=[[AuthTokenFetcher alloc]init];
//  [authTokenFetcher fetchAuthTokenWithGmailId:gmailIDRetrieved GmailPassword:gmailPasswordRetrieved AppleID:appleIDRetrieved ApplePassword:applePasswordRetrieved];


    [[GmailIPhoneSyncer alloc] SyncGmailId:[GmailID text] GmailPass:[GmailPassword text] AppleId:[AppleID text] ApplePass:[ApplePassword text]];

}

@end
