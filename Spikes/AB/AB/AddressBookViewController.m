
#import "AddressBookViewController.h"
#import "AddressBookUI/AddressBookUI.h"
#import "AddressBook/AddressBook.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

ABRecordID recordId;

CFTypeRef FirstName ;
CFTypeRef LastName ;
CFTypeRef MiddleName ;
CFTypeRef Prefix ;
CFTypeRef Suffix ;
CFTypeRef Nickname ;
CFTypeRef FirstNamePhonetic ;
CFTypeRef LastNamePhonetic ;
CFTypeRef MiddleNamePhonetic ;
CFTypeRef Organization ;
CFTypeRef JobTitle ;
CFTypeRef Department ;

CFTypeRef CreationDate ;
CFTypeRef ModificationDate ;

//Phone Numbers
ABMutableMultiValueRef PhoneNumbers;
CFTypeRef PhoneMain ;
CFTypeRef PhoneMobile ;
CFTypeRef PhoneIPhone ;
CFTypeRef PhoneHomeFax ;
CFTypeRef PhoneWorkFax ;
CFTypeRef PhoneOtherFax ;
CFTypeRef PhonePager ;

//Emails
ABMutableMultiValueRef EMails;
CFTypeRef WorkLabel;
CFTypeRef HomeLabel;
CFTypeRef OtherLabel;

CFErrorRef error = NULL; 



- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
    
}



- (IBAction)clickView:(id)sender {
    
    [[[UIAlertView alloc] initWithTitle:@"Alert!!"
                                message:@"View Contacts Info in Terminal!!"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
      ]
     show];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i=0; i<CFArrayGetCount(people);i++)
    {
        ABRecordRef record = CFArrayGetValueAtIndex(people,i);
        
        FirstName = (ABRecordCopyValue(record, kABPersonFirstNameProperty));
        LastName = (ABRecordCopyValue(record, kABPersonLastNameProperty));
        MiddleName = (ABRecordCopyValue(record, kABPersonMiddleNameProperty));
        Prefix = (ABRecordCopyValue(record, kABPersonPrefixProperty));
        Suffix = (ABRecordCopyValue(record, kABPersonSuffixProperty));
        Nickname = (ABRecordCopyValue(record, kABPersonNicknameProperty));
        FirstNamePhonetic = (ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty));
        LastNamePhonetic = (ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty));
        MiddleNamePhonetic = (ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty));
        Organization = (ABRecordCopyValue(record, kABPersonOrganizationProperty));
        JobTitle = (ABRecordCopyValue(record, kABPersonJobTitleProperty));
        Department = (ABRecordCopyValue(record, kABPersonDepartmentProperty));
        CreationDate = (ABRecordCopyValue(record, kABPersonCreationDateProperty));
        ModificationDate = (ABRecordCopyValue(record, kABPersonModificationDateProperty));
        
        NSLog(@"FirstName\t%@\n", FirstName );
        NSLog(@"LastName\t%@\n", LastName );
        NSLog(@"MiddleName\t%@\n", MiddleName );
        NSLog(@"Prefix\t%@\n", Prefix );
        NSLog(@"Suffix\t%@\n", Suffix );
        NSLog(@"Nickname\t%@\n", Nickname );
        NSLog(@"%@\n", FirstNamePhonetic );
        NSLog(@"%@\n", LastNamePhonetic );
        NSLog(@"%@\n", MiddleNamePhonetic );
        NSLog(@"%@\n", Organization );
        NSLog(@"%@\n", JobTitle );
        NSLog(@"%@\n", Department );
        NSLog(@"%@\n", CreationDate ); 
        NSLog(@"%@\n", ModificationDate );
        
        
        PhoneNumbers = ABRecordCopyValue(record,kABPersonPhoneProperty);
        
        NSLog(@"Phone Numbers");
        int phoneNumberCount = ABMultiValueGetCount(PhoneNumbers);
        if (phoneNumberCount > 0) {
            for (CFIndex i = 0; i < phoneNumberCount; i++) {
                NSLog(@"\n%@\t%@",
                      (__bridge NSString*) ABAddressBookCopyLocalizedLabel(
                                                    ABMultiValueCopyLabelAtIndex(PhoneNumbers, i)),
                      (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(PhoneNumbers, i));
            }
        } else {
            NSLog(@"\t [None]");
        }

        EMails = (ABRecordCopyValue(record, kABPersonEmailProperty));
        NSLog(@"EMails");
        int EMailCount = ABMultiValueGetCount(EMails);
        if (EMailCount > 0) {
            for (CFIndex i = 0; i < EMailCount; i++) {
                NSLog(@"\n%@\t%@",
                      (__bridge NSString*) ABAddressBookCopyLocalizedLabel(
                                                                           ABMultiValueCopyLabelAtIndex(EMails, i)),
                      (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(EMails, i));
            }
        } else {
            NSLog(@"\t [None]");
        }
        
    }
    
}

- (IBAction)clickCreate:(id)sender {
    
    FirstName = @"Nithya";
    LastName = @"Natarajan";
    MiddleName = @"";
    Prefix = @"Prefix";
    Suffix = @"Suffix";
    Nickname =@"Natty";
    FirstNamePhonetic = @"FP";
    LastNamePhonetic = @"LP";
    MiddleNamePhonetic = @"MP";
    Organization = @"TW";
    JobTitle = @"App Dev";
    Department = @"Dev ops";
    
    //Phone Numbers
    PhoneMain = @"15555555555";
    PhoneMobile = @"11234567890";
    PhoneIPhone = @"15555555555";
    PhoneHomeFax = @"11234567890";
    PhoneWorkFax = @"11234567890";
    PhoneOtherFax = @"1123456890";
    PhonePager = @"11234567890";
    
    
    //EMails
    WorkLabel = @"nithya@thoughtworks";
    HomeLabel = @"nithya@gmail.com";
    OtherLabel = @"nithya@evernote";
    
}

- (IBAction)clickAdd:(id)sender {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef newRecord = [self createRecord];
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    ABAddressBookSave(addressBook, &error);
    recordId = ABRecordGetRecordID( newRecord);
    if(error != NULL){
        NSLog(@"Save Failed");
    }
    
}

- (IBAction)clickDuplicateCheck:(id)sender {
      
    ABRecordRef newRecord1 = [self createRecord];
    ABRecordRef newRecord2 = [self createRecord];
    
    [[[UIAlertView alloc] initWithTitle:@"Alert!!"
                                message:([self isSameFirst:newRecord1 Second:newRecord2])? @"TRUE" : @"FALSE"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
      ]
     show];
}

- (IBAction)clickMerge:(id)sender {
    
    ABAddressBookRef updatedAddressBook = ABAddressBookCreate();
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(updatedAddressBook, recordId);
    ABRecordSetValue(person, kABPersonFirstNameProperty, @"New Name" ,&error);
    
    ABAddressBookSave(updatedAddressBook, &error);
}




-(BOOL) isCommonValueFoundFirst:(ABMutableMultiValueRef) first Second :(ABMutableMultiValueRef) second{
    
    
    int count1 = ABMultiValueGetCount(first);
    int count2 = ABMultiValueGetCount(second);
    
    if (count1 > 0 && count2 > 0) {
        for (CFIndex i = 0; i < count1; i++) {
            for (CFIndex j = 0; j < count2; j++) {
                
                if(
                   [ (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(first, i) isEqualToString:
                    (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(second, j)]
                   ==true
                   )
                    return YES;
                
            }
        }
    }
    return NO;
}

- (BOOL)isSameFirst:(ABRecordRef)first Second:(ABRecordRef)second {
    
    ABMutableMultiValueRef PhoneNumbers1 = ABRecordCopyValue(first,kABPersonPhoneProperty);
    ABMutableMultiValueRef PhoneNumbers2 = ABRecordCopyValue(second,kABPersonPhoneProperty);
    return [ self isCommonValueFoundFirst:PhoneNumbers1 Second:PhoneNumbers2];
    
    
    ABMutableMultiValueRef EMail1 = ABRecordCopyValue(first,kABPersonEmailProperty);
    ABMutableMultiValueRef EMail2 = ABRecordCopyValue(second,kABPersonEmailProperty);
    return [ self isCommonValueFoundFirst:EMail1 Second:EMail2];
    
    return NO;
    
}


- (ABRecordRef) createRecord {
    
    ABRecordRef newRecord = ABPersonCreate();
    ABRecordSetValue(newRecord, kABPersonFirstNameProperty,FirstName , &error);
    ABRecordSetValue(newRecord, kABPersonLastNameProperty,LastName , &error);
    ABRecordSetValue(newRecord, kABPersonMiddleNameProperty,MiddleName , &error);
    ABRecordSetValue(newRecord, kABPersonPrefixProperty,Prefix , &error);
    ABRecordSetValue(newRecord, kABPersonSuffixProperty,Suffix , &error);
    ABRecordSetValue(newRecord, kABPersonNicknameProperty,Nickname , &error);
    ABRecordSetValue(newRecord, kABPersonFirstNamePhoneticProperty,FirstNamePhonetic , &error);
    ABRecordSetValue(newRecord, kABPersonLastNamePhoneticProperty,LastNamePhonetic , &error);
    ABRecordSetValue(newRecord, kABPersonMiddleNamePhoneticProperty,MiddleNamePhonetic , &error);
    ABRecordSetValue(newRecord, kABPersonOrganizationProperty,Organization , &error);
    ABRecordSetValue(newRecord, kABPersonJobTitleProperty,JobTitle , &error);
    ABRecordSetValue(newRecord, kABPersonDepartmentProperty,Department , &error);
    
    //Phone Numbers
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, PhoneMain , kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, PhoneMobile , kABPersonPhoneMobileLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, PhoneIPhone , kABPersonPhoneIPhoneLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, PhoneHomeFax , kABPersonPhoneHomeFAXLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, PhoneWorkFax , kABPersonPhoneWorkFAXLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, PhoneOtherFax , kABPersonPhoneOtherFAXLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, PhonePager , kABPersonPhonePagerLabel, NULL);
    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multiPhone, &error);
    
    
    //Emails
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, HomeLabel, kABHomeLabel, NULL);
    ABMultiValueAddValueAndLabel(multiEmail, WorkLabel, kABWorkLabel, NULL);
    ABMultiValueAddValueAndLabel(multiEmail, OtherLabel, kABOtherLabel, NULL);
    ABRecordSetValue(newRecord, kABPersonEmailProperty, multiEmail, &error);
    
    
    ABRecordSetValue(newRecord, kABPersonCreationDateProperty,CreationDate , &error);
    ABRecordSetValue(newRecord, kABPersonModificationDateProperty,ModificationDate , &error);
    
    return newRecord;
    
}


@end
