//
//  AddressBookViewController.m
//  AB
//
//  Created by Nithya on 19/09/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookUI/AddressBookUI.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController
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
CFTypeRef Email ;
CFTypeRef Birthday ;
CFTypeRef Note ;
CFTypeRef CreationDate ;
CFTypeRef ModificationDate ;




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
    return YES;
    
}



- (IBAction)click:(id)sender {
    
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
        Email = (ABRecordCopyValue(record, kABPersonEmailProperty));
        Birthday = (ABRecordCopyValue(record, kABPersonBirthdayProperty));
        Note = (ABRecordCopyValue(record, kABPersonNoteProperty));
        CreationDate = (ABRecordCopyValue(record, kABPersonCreationDateProperty));
        ModificationDate = (ABRecordCopyValue(record, kABPersonModificationDateProperty));
        
        
        NSLog(@"%@\n", FirstName );
        NSLog(@"%@\n", LastName );
        NSLog(@"%@\n", MiddleName );
        NSLog(@"%@\n", Prefix );
        NSLog(@"%@\n", Suffix );
        NSLog(@"%@\n", Nickname );
        NSLog(@"%@\n", FirstNamePhonetic );
        NSLog(@"%@\n", LastNamePhonetic );
        NSLog(@"%@\n", MiddleNamePhonetic );
        NSLog(@"%@\n", Organization );
        NSLog(@"%@\n", JobTitle );
        NSLog(@"%@\n", Department );
        NSLog(@"%@\n", Email );
        NSLog(@"%@\n", Birthday );
        NSLog(@"%@\n", Note ); 
        NSLog(@"%@\n", CreationDate ); 
        NSLog(@"%@\n", ModificationDate );
        
   }
    
}

- (IBAction)clickAdd:(id)sender {
    CFErrorRef error = NULL;    
    ABAddressBookRef addressBook = ABAddressBookCreate();
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
    ABRecordSetValue(newRecord, kABPersonEmailProperty,Email , &error);
    ABRecordSetValue(newRecord, kABPersonBirthdayProperty,Birthday , &error);
    ABRecordSetValue(newRecord, kABPersonNoteProperty,Note , &error);
    ABRecordSetValue(newRecord, kABPersonCreationDateProperty,CreationDate , &error);
    ABRecordSetValue(newRecord, kABPersonModificationDateProperty,ModificationDate , &error);
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    ABAddressBookSave(addressBook, &error);
}
@end
