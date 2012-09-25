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
    NSMutableArray* GmailContactList= [[ABAddressBookInf getGmailContactsListAfterParsing:contactsResponse]init];
    
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
                    [contactsToBeAddedToGmail addObject:[self mergeContact1:p1 Contact2:p2]];
                    [contactsToBeAddedToPhone addObject:[self mergeContact1:p1 Contact2:p2]];
                }
            }
        }
    }
}


-(BOOL) variesInDetailsFirst:(Person*)f Second:(Person*)s {
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

-(bool) nullorempty:(NSString*)p {
    return p==(id)[NSNull null] || p.length == 0;
}

-(Person*) mergeContact1:(Person*)f Contact2:(Person*)s {
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
    
    
    /*uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFType count]: unrecognized selector sent to instance 0x6ccf070'
     *** First throw call stack:
     */
}

- (BOOL)isCommonValueFoundFirst:(NSMutableArray*)f Second:(NSMutableArray*)s {
    
    int count1 = f.count;
    int count2 = s.count;
    
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

- (void) populateXmlGoogleContactList:(NSMutableArray*) contactsToBeAddedToGmail {
    NSMutableArray *family = [[NSMutableArray alloc] init];
    for (int i = 0; i < contactsToBeAddedToGmail.count; i++) {
        // simulate person's attributes
        NSArray *keys = [[NSArray alloc] initWithObjects:
                         @"id",
                         @"FirstName",
                         @"LastName",
                         @"Nickname",
                         @"email",
                         @"phoneNumber",
                         Nil];
        
        NSArray *values = [[NSArray alloc] initWithObjects:
                           [NSNumber numberWithInt:i],
                           @"Edward",
                           [NSNumber numberWithInt:10],
                           Nil];
        
        // create a Person (a dictionary)
        NSDictionary *person = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        [family addObject:person];
        [person release];
    }
    
    // save the "person" object to the property list
    [family writeToFile:@"<path>/family.plist" atomically:YES];
    [family release];
    
}
@end
