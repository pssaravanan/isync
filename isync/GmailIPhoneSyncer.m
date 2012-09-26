#import "GmailIPhoneSyncer.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"
#import "Person.h"

@implementation GmailIPhoneSyncer

- (void)SyncGmailId:(NSString *)gmailId GmailPass:(NSString *)gmailpass
            AppleId:(NSString *)appleId ApplePass:(NSString *)applepass {
    
    AuthTokenFetcher *authTokenFetcher = [[AuthTokenFetcher alloc]init];
    [authTokenFetcher fetchAuthTokenWithGmailId:gmailId GmailPassword:gmailpass
                                        AppleID:appleId ApplePassword:applepass
                                    CallbackObj:self];
    
}

- (void) authTokenFetched: (NSString *) token {
    
    NSLog(@"%@\n%@",@"authToken Fetched",token);
    [[[GmailContactsFetcher alloc] init] fetchGmailContactswithAuthToken:token CallbackObj:self];
    
}

-(void) contactsFetched:(NSMutableData*)contactsResponse {
    
    NSMutableArray* IPhoneContactList=[[ABAddressBookInf getPhoneContactList] init];
    NSMutableArray* GmailContactList= [[ABAddressBookInf getGmailContactsListAfterParsing:contactsResponse] init];
    
    NSMutableArray* mergedListOfContacts=[[NSMutableArray alloc] init];
    
    NSMutableArray* contactsToBeAddedToGmail=[[NSMutableArray alloc] init];
    NSMutableArray* contactsToBeAddedToPhone=[[NSMutableArray alloc] init];
    
    NSMutableArray* contactsToBeUpdatedInGmail=[[NSMutableArray alloc] init];
    NSMutableArray* contactsToBeUpdatedInPhone=[[NSMutableArray alloc] init];
    
    
    for (Person *p1 in GmailContactList) {
        bool foundInPhone=false;
        for (Person *p2 in IPhoneContactList) {
            if ([self isSameFirst:p1 Second:p2]) {
                foundInPhone=true;
                NSLog(@"foundInPhone\t%d",foundInPhone);
                //foundInPhone = [self isSameFirst:p1 Second:p2];
            }
        }
        if(!foundInPhone)
            [contactsToBeAddedToPhone addObject:p1];
    }
    
    
    for (Person *p1 in IPhoneContactList) {
        bool foundInGmail=false;
        for (Person *p2 in GmailContactList) {
            if ([self isSameFirst:p1 Second:p2]) {
                foundInGmail=true;
                NSLog(@"foundInGmail\t%d",foundInGmail);
                //foundInGmail = [self isSameFirst:p1 Second:p2];
            }
        }
        if(!foundInGmail)
            [contactsToBeAddedToGmail addObject:p1];
    }
    
    for (Person *p1 in GmailContactList) {
        for (Person *p2 in IPhoneContactList) {
            if ([self isSameFirst:p1 Second:p2]) {
                if([self variesInDetailsFirst:p1 Second:p2]){
                    [contactsToBeUpdatedInGmail addObject:[self mergeContact1:p1 Contact2:p2]];
                    [contactsToBeUpdatedInPhone addObject:[self mergeContact1:p1 Contact2:p2]];
                }
            }
        }
    }
    
[self addContactsToPhone:contactsToBeAddedToPhone];
[self addContactsToGmail:contactsToBeAddedToGmail];


[self mergeContactsToPhone:contactsToBeUpdatedInPhone];
[self mergeContactsToGmail:contactsToBeUpdatedInGmail];

}

- (void) addContactsToPhone:(NSMutableArray*) contactsToBeAddedToPhone{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    for (Person* person in contactsToBeAddedToPhone) {
        
        ABRecordRef newRecord = ABPersonCreate();        
        
        ABRecordSetValue(newRecord, kABPersonFirstNameProperty,(__bridge CFTypeRef)(person.FirstName) , &error);
        ABRecordSetValue(newRecord, kABPersonLastNameProperty,(__bridge CFTypeRef)(person.LastName) , &error);
        ABRecordSetValue(newRecord, kABPersonMiddleNameProperty,(__bridge CFTypeRef)(person.MiddleName) , &error);
        ABRecordSetValue(newRecord, kABPersonOrganizationProperty,(__bridge CFTypeRef)(person.Organization) , &error);
        ABRecordSetValue(newRecord, kABPersonJobTitleProperty,(__bridge CFTypeRef)(person.JobTitle) , &error);
        ABRecordSetValue(newRecord, kABPersonDepartmentProperty,(__bridge CFTypeRef)(person.Department) , &error);
        
        //Phone Numbers
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        if(![self nullorempty:person.PhoneMain])
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(person.PhoneMain) , kABPersonPhoneMainLabel, NULL);
        if(![self nullorempty:person.PhoneMobile])
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(person.PhoneMobile) , kABPersonPhoneMobileLabel, NULL);
        if(![self nullorempty:person.PhoneIPhone])
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(person.PhoneIPhone), kABPersonPhoneIPhoneLabel, NULL);
        
        ABRecordSetValue(newRecord, kABPersonPhoneProperty, multiPhone, &error);
        
        
        //Emails
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        if(![self nullorempty:person.HomeEmail])
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(person.HomeEmail), kABHomeLabel, NULL);
        if(![self nullorempty:person.WorkEmail])
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(person.WorkEmail), kABWorkLabel, NULL);
        if(![self nullorempty:person.OtherEmail])
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(person.OtherEmail), kABOtherLabel, NULL);
        
        ABRecordSetValue(newRecord, kABPersonEmailProperty, multiEmail, &error);
        
        
        ABAddressBookAddRecord(addressBook, newRecord, &error);
        
    }
    
    ABAddressBookSave(addressBook, &error);
    if(error != NULL){
        NSLog(@"Save Failed");
    }
    
}

- (void) addContactsToGmail:(NSMutableArray*) contactsToBeAddedToGmail{
    
}


- (void) mergeContactsToPhone:contactsToBeUpdatedInPhone{
    
//    ABAddressBookRef updatedAddressBook = ABAddressBookCreate();
//    ABRecordRef record = ABAddressBookGetPersonWithRecordID(updatedAddressBook, person.id);
//
//    ABRecordSetValue(record, kABPersonFirstNameProperty, person.FirstName,&error);
//    ABRecordSetValue(record, kABPersonLastNameProperty, person.LastName,&error);
//    
//    
//    ABAddressBookSave(updatedAddressBook, &error);
    
}

- (void) mergeContactsToGmail:contactsToBeUpdatedInGmail{
    
}




- (BOOL) variesInDetailsFirst:(Person*)f Second:(Person*)s {
    bool same=true;
    
    same = same && f.FirstName         == s.FirstName           ;
    same = same && f.LastName          == s.LastName            ;
    same = same && f.MiddleName        == s.MiddleName          ;
    same = same && f.Organization      == s.Organization        ;
    same = same && f.JobTitle          == s.JobTitle            ;
    same = same && f.Department        == s.Department          ;
    same = same && f.PhoneMain         == s.PhoneMain           ;
    same = same && f.PhoneMobile       == s.PhoneMobile         ;
    same = same && f.PhoneIPhone       == s.PhoneIPhone         ;
    same = same && f.WorkEmail         == s.WorkEmail           ;
    same = same && f.HomeEmail         == s.HomeEmail           ;
    same = same && f.OtherEmail        == s.OtherEmail          ;
    
    return !same;
    
}

- (bool) nullorempty:(NSString*)p {
    return p==(id)[NSNull null] || p.length == 0;
}

- (Person*) mergeContact1:(Person*)f Contact2:(Person*)s {
    Person *person = [[Person alloc]init];
    
    if([self nullorempty:f.FirstName])  person.FirstName = s.FirstName;
    else                                person.FirstName = f.FirstName;
    if([self nullorempty:f.LastName])   person.LastName = s.LastName;
    else                                person.LastName = f.LastName;
    if([self nullorempty:f.MiddleName]) person.MiddleName = s.MiddleName;
    else                                person.MiddleName = f.MiddleName;
    
    if([self nullorempty:f.Organization])person.Organization = s.Organization;
    else                                person.Organization = f.Organization;
    if([self nullorempty:f.JobTitle])   person.JobTitle = s.JobTitle;
    else                                person.JobTitle = f.JobTitle;
    if([self nullorempty:f.Department]) person.Department = s.Department;
    else                                person.Department = f.Department;
    
    if([self nullorempty:f.PhoneMain])  person.PhoneMain = s.PhoneMain;
    else                                person.PhoneMain = f.PhoneMain;
    if([self nullorempty:f.PhoneMobile])person.PhoneMobile = s.PhoneMobile;
    else                                person.PhoneMobile = f.PhoneMobile;
    if([self nullorempty:f.PhoneIPhone])person.PhoneIPhone = s.PhoneIPhone;
    else                                person.PhoneIPhone = f.PhoneIPhone;
    
    if([self nullorempty:f.WorkEmail])  person.WorkEmail = s.WorkEmail;
    else                                person.WorkEmail = f.WorkEmail;
    if([self nullorempty:f.HomeEmail])  person.HomeEmail = s.HomeEmail;
    else                                person.HomeEmail = f.HomeEmail;
    if([self nullorempty:f.OtherEmail]) person.OtherEmail = s.OtherEmail;
    else                                person.OtherEmail = f.OtherEmail;
    
    return person;
}

- (BOOL)isSameFirst:(Person*)first Second:(Person*)second {
    return [ self isCommonValueFoundFirst:first.PhoneNumbers Second:second.PhoneNumbers] ||
    [ self isCommonValueFoundFirst:first.EMails Second:second.EMails];
}

- (BOOL)isCommonValueFoundFirst:(NSMutableArray*)f Second:(NSMutableArray*)s {
    
    int count1 = [f count];
    int count2 = [s count];
    
    if (count1 > 0 && count2 > 0) {
        for (int i = 0; i < count1; i++) {
            for (int j = 0; j < count2; j++) {
                
                NSString *str1=[f objectAtIndex:i];
                NSString *str2=[s objectAtIndex:j];
                if([str1 isEqualToString:str2])
                    return true;
            }
        }
    }
    return false;
}
@end
