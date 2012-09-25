
#import "ViewController.h"
#import "GmailContactsParser.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"
#import "GmailIPhoneSyncer.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize GmailID, GmailPassword, AppleID, ApplePassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    GmailPassword.secureTextEntry=YES;
    ApplePassword.secureTextEntry=YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)hideKeyBoard:(id)sender {
    [GmailID resignFirstResponder];
    [GmailPassword resignFirstResponder];
    [AppleID resignFirstResponder];
    [ApplePassword resignFirstResponder];
}

- (IBAction)synchronizeButtonPressed:(id)sender {
    [[GmailIPhoneSyncer alloc] SyncGmailId:[GmailID text] GmailPass:[GmailPassword text]
                                   AppleId:[AppleID text] ApplePass:[ApplePassword text]];

}

@end
