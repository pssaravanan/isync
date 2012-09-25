#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UITextField *AppleID;
    UITextField *ApplePassword;
    UITextField *GmailID;
    UITextField *GmailPassword;
    }
@property (nonatomic,retain)IBOutlet UITextField *AppleID;
@property (nonatomic,retain)IBOutlet UITextField *ApplePassword;
@property (nonatomic,retain)IBOutlet UITextField *GmailID;
@property (nonatomic,retain)IBOutlet UITextField *GmailPassword;


-(IBAction)hideKeyBoard:(id)sender;
-(IBAction)synchronizeButtonPressed:(id)sender;

@end
