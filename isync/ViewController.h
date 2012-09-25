#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UITextField *AppleID;
    UITextField *ApplePassword;
    UITextField *GmailID;
    UITextField *GmailPassword;
    }
@property (nonatomic,strong)IBOutlet UITextField *AppleID;
@property (nonatomic,strong)IBOutlet UITextField *ApplePassword;
@property (nonatomic,strong)IBOutlet UITextField *GmailID;
@property (nonatomic,strong)IBOutlet UITextField *GmailPassword;


-(IBAction)hideKeyBoard:(id)sender;
-(IBAction)synchronizeButtonPressed:(id)sender;

@end
