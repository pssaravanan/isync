#import "GmailIPhoneSyncer.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"
#import "Person.h"
#import "GData.h"
#import "GDataContacts.h"

@implementation GmailIPhoneSyncer
@synthesize authToken;

- (void)SyncGmailId:(NSString *)gmailId GmailPass:(NSString *)gmailpass
            AppleId:(NSString *)appleId ApplePass:(NSString *)applepass {
    
    AuthTokenFetcher *authTokenFetcher = [[AuthTokenFetcher alloc]init];
    [authTokenFetcher fetchAuthTokenWithGmailId:gmailId GmailPassword:gmailpass
                                        AppleID:appleId ApplePassword:applepass
                                    CallbackObj:self];
    
}

- (void) authTokenFetched: (NSString *) token {
    
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
    
    
    
    [[[UIAlertView alloc] initWithTitle:@"Alert!!"
                                message:@"Contacts Synced"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
      ]
     show];

}


- (ABRecordRef) setRecordForPhone:(ABRecordRef) newRecord Person :(Person *)person Error : (CFErrorRef) error{
    
    if(![self nullorempty:person.FirstName])
        ABRecordSetValue(newRecord, kABPersonFirstNameProperty,(__bridge CFTypeRef)(person.FirstName) , &error);
    if(![self nullorempty:person.LastName])
        ABRecordSetValue(newRecord, kABPersonLastNameProperty,(__bridge CFTypeRef)(person.LastName) , &error);
    if(![self nullorempty:person.MiddleName])
        ABRecordSetValue(newRecord, kABPersonMiddleNameProperty,(__bridge CFTypeRef)(person.MiddleName) , &error);
    if(![self nullorempty:person.Organization])
        ABRecordSetValue(newRecord, kABPersonOrganizationProperty,(__bridge CFTypeRef)(person.Organization) , &error);
    if(![self nullorempty:person.JobTitle])
        ABRecordSetValue(newRecord, kABPersonJobTitleProperty,(__bridge CFTypeRef)(person.JobTitle) , &error);
    if(![self nullorempty:person.Department])
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

    return newRecord;
    
}


- (void) addContactsToPhone:(NSMutableArray*) contactsToBeAddedToPhone{
    
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    for (Person* person in contactsToBeAddedToPhone) {
        
        ABRecordRef newRecord = ABPersonCreate();
        
        newRecord = [self setRecordForPhone: newRecord  Person:person  Error:error];
        
        ABAddressBookAddRecord(addressBook, newRecord, &error);
        
    }
    
    ABAddressBookSave(addressBook, &error);
    if(error != NULL){
        NSLog(@"Save Failed");
    }
    
}
- (void) addContactsToGmail:(NSMutableArray*) contactsToBeAddedToGmail{
    GDataServiceGoogleContact *service = [[GDataServiceGoogleContact alloc]init];
    NSURL *postURL = [NSURL URLWithString:@"https://www.google.com/m8/feeds/contacts/default/full/"];
    [service setShouldCacheResponseData:YES];
    [service setServiceShouldFollowNextLinks:YES];
    [service setAuthToken:self.authToken];
    
    for(Person *person in contactsToBeAddedToGmail){
        GDataEmail *emailObj;
        GDataEntryContact *newContact = [GDataEntryContact contactEntryWithFullNameString:person.FirstName];
        if(person.EMails.count  >0){
            if(![self nullorempty:person.HomeEmail]){
                emailObj = [GDataEmail emailWithLabel:nil
                                              address:person.HomeEmail];
                [emailObj setRel:kGDataContactOther];
                [emailObj setIsPrimary:YES];
                
            }
            
            if(![self nullorempty:person.OtherEmail]){
                emailObj = [GDataEmail emailWithLabel:nil
                                              address:person.OtherEmail];
                [emailObj setRel:kGDataContactOther];
                [emailObj setIsPrimary:NO];
                
            }
            
            if(![self nullorempty:person.WorkEmail]){
                emailObj = [GDataEmail emailWithLabel:nil
                                              address:person.WorkEmail];
                [emailObj setRel:kGDataContactOther];
                [emailObj setIsPrimary:NO];
                
            }
            [newContact addEmailAddress:emailObj];
            
            //
            //        GDataEmail *otherEmail = [GDataEmail emailWithLabel:@"other"
            //                                                  address:person.OtherEmail];
            //        [otherEmail setRel:kGDataContactOther];
            //        [otherEmail setIsPrimary:NO];
            
            //[newContact addEmailAddress:otherEmail];
            [service fetchEntryByInsertingEntry:newContact
                                     forFeedURL:postURL
                                       delegate:self
                              didFinishSelector:@selector(addContactTicket:addedEntry:error:)];
        }
    }
}
// add contact callback
- (void)addContactTicket:(GDataServiceTicket *)ticket
              addedEntry:(GDataEntryContact *)object
                   error:(NSError *)error {
    
}



- (void) mergeContactsToPhone:contactsToBeUpdatedInPhone{
    
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    for (Person* person in contactsToBeUpdatedInPhone) {
        
        ABRecordRef newRecord = ABAddressBookGetPersonWithRecordID(addressBook, person.phonePersonId);
        
        newRecord = [self setRecordForPhone: newRecord  Person:person  Error:error];
        
        ABAddressBookAddRecord(addressBook, newRecord, &error);
        
    }
    
    ABAddressBookSave(addressBook, &error);
    if(error != NULL){
        NSLog(@"Save Failed");
    }
    
}

- (void) mergeContactsToGmail:contactsToBeUpdatedInGmail{
    
}




- (BOOL) variesInDetailsFirst:(Person*)f Second:(Person*)s {
    bool same=true;
    
    same = same && ([self nullorempty:f.FirstName] || [self nullorempty:s.FirstName] ? [self nullorempty:f.FirstName] && [self nullorempty:s.FirstName] : [f.FirstName isEqualToString:s.FirstName]);
    same = same && ([self nullorempty:f.LastName    ] || [self nullorempty: s.LastName    ] ? [self nullorempty:f.LastName    ] && [self nullorempty:s.LastName    ] : [f.LastName     isEqualToString:s.LastName    ]);
    same = same && ([self nullorempty:f.MiddleName  ] || [self nullorempty: s.MiddleName  ] ? [self nullorempty:f.MiddleName  ] && [self nullorempty:s.MiddleName  ] : [f.MiddleName   isEqualToString:s.MiddleName  ]);
    same = same && ([self nullorempty:f.Organization] || [self nullorempty: s.Organization] ? [self nullorempty:f.Organization] && [self nullorempty:s.Organization] : [f.Organization isEqualToString:s.Organization]);
    same = same && ([self nullorempty:f.JobTitle    ] || [self nullorempty: s.JobTitle    ] ? [self nullorempty:f.JobTitle    ] && [self nullorempty:s.JobTitle    ] : [f.JobTitle     isEqualToString:s.JobTitle    ]);
    same = same && ([self nullorempty:f.Department  ] || [self nullorempty: s.Department  ] ? [self nullorempty:f.Department  ] && [self nullorempty:s.Department  ] : [f.Department   isEqualToString:s.Department  ]);
    same = same && ([self nullorempty:f.PhoneMain   ] || [self nullorempty: s.PhoneMain   ] ? [self nullorempty:f.PhoneMain   ] && [self nullorempty:s.PhoneMain   ] : [f.PhoneMain    isEqualToString:s.PhoneMain   ]);
    same = same && ([self nullorempty:f.PhoneMobile ] || [self nullorempty: s.PhoneMobile ] ? [self nullorempty:f.PhoneMobile ] && [self nullorempty:s.PhoneMobile ] : [f.PhoneMobile  isEqualToString:s.PhoneMobile ]);
    same = same && ([self nullorempty:f.PhoneIPhone ] || [self nullorempty: s.PhoneIPhone ] ? [self nullorempty:f.PhoneIPhone ] && [self nullorempty:s.PhoneIPhone ] : [f.PhoneIPhone  isEqualToString:s.PhoneIPhone ]);
    same = same && ([self nullorempty:f.WorkEmail   ] || [self nullorempty: s.WorkEmail   ] ? [self nullorempty:f.WorkEmail   ] && [self nullorempty:s.WorkEmail   ] : [f.WorkEmail    isEqualToString:s.WorkEmail   ]);
    same = same && ([self nullorempty:f.HomeEmail   ] || [self nullorempty: s.HomeEmail   ] ? [self nullorempty:f.HomeEmail   ] && [self nullorempty:s.HomeEmail   ] : [f.HomeEmail    isEqualToString:s.HomeEmail   ]);
    same = same && ([self nullorempty:f.OtherEmail  ] || [self nullorempty: s.OtherEmail  ] ? [self nullorempty:f.OtherEmail  ] && [self nullorempty:s.OtherEmail  ] : [f.OtherEmail   isEqualToString:s.OtherEmail  ]);
    
    
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
    [ self isCommonValueFoundFirst:first.EMails Second:second.EMails];// || ![self variesInDetailsFirst:first Second:second];
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
