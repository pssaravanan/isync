#import "GmailIPhoneSyncer.h"
#import "AuthTokenFetcher.h"
#import "GmailContactsFetcher.h"
#import "ABAddressBookInf.h"
#import "Person.h"

@implementation GmailIPhoneSyncer
- (void)SyncGmailId:(NSString *)gmailId GmailPass:(NSString *)gmailpass AppleId:(NSString *)appleId ApplePass:(NSString *)applepass{

    /****Steps****/
    //gmail Auth
    //gmail fetch
    //gmail parse
        //[contacts]
    //phone fetch
        //[contacts]
    //Merge
        //G'[] P'[]
    //Phone Update
    //Google generate XML
    //Google Update contacts
    
    
    
    /**Implementation**/
    //gmail auth:
    AuthTokenFetcher *authTokenFetcher=[[AuthTokenFetcher alloc]init];
    [authTokenFetcher fetchAuthTokenWithGmailId:gmailId GmailPassword:gmailpass AppleID:appleId ApplePassword:applepass CallbackObj:self];
}

- (void) authTokenFetched: (NSString *) token{
    NSLog(@"%@\n%@",@"authToken Fetched",token);
    [[[GmailContactsFetcher alloc] init] fetchGmailContactswithAuthToken:token CallbackObj:self];
}

-(void) contactsFetched:(NSMutableData*)contactsResponse{
    NSMutableArray* IPhoneContactList=[ABAddressBookInf getPhoneContactList];
    
    NSMutableArray* GmailContactList= [ABAddressBookInf getGmailContactsListAfterParsing:contactsResponse];
    
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
                    contactsToBeAddedToPhone=contactsToBeUpdatedInGmail=[self mergeContact1:p1 Contact2:p2];
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
    same = same && f.Prefix            == s.Prefix              ;
    same = same && f.Suffix            == s.Suffix              ;
    same = same && f.Nickname          == s.Nickname            ;
    same = same && f.FirstNamePhonetic == s.FirstNamePhonetic   ;
    same = same && f.LastNamePhonetic  == s.LastNamePhonetic    ;
    same = same && f.MiddleNamePhonetic== s.MiddleNamePhonetic  ;
    same = same && f.Organization      == s.Organization        ;
    same = same && f.JobTitle          == s.JobTitle            ;
    same = same && f.Department        == s.Department          ;
    same = same && f.CreationDate      == s.CreationDate        ;
    same = same && f.ModificationDate  == s.ModificationDate    ;
    same = same && f.PhoneNumbers      == s.PhoneNumbers        ;
    same = same && f.PhoneMain         == s.PhoneMain           ;
    same = same && f.PhoneMobile       == s.PhoneMobile         ;
    same = same && f.PhoneIPhone       == s.PhoneIPhone         ;
    same = same && f.PhoneHomeFax      == s.PhoneHomeFax        ;
    same = same && f.PhoneWorkFax      == s.PhoneWorkFax        ;
    same = same && f.PhoneOtherFax     == s.PhoneOtherFax       ;
    same = same && f.PhonePager        == s.PhonePager          ;
    same = same && f.EMails            == s.EMails              ;
    same = same && f.WorkEmail         == s.WorkEmail           ;
    same = same && f.HomeEmail         == s.HomeEmail           ;
    same = same && f.OtherEmail        == s.OtherEmail          ;

    
    return !same;
    
}

-(bool) nullorempty:(NSString*)p {
    return p==(id)[NSNull null] || p.length == 0;
}

-(Person*) mergeContact1:(Person*)f Contact2:(Person*)s {
    if([self nullorempty:f.FirstName         ]) f.FirstName         = s.FirstName            ; else s.FirstName         = f.FirstName           ;
    if([self nullorempty:f.LastName          ]) f.LastName          = s.LastName             ; else s.LastName          = f.LastName            ;
    if([self nullorempty:f.MiddleName        ]) f.MiddleName        = s.MiddleName           ; else s.MiddleName        = f.MiddleName          ;
    if([self nullorempty:f.Prefix            ]) f.Prefix            = s.Prefix               ; else s.Prefix            = f.Prefix              ;
    if([self nullorempty:f.Suffix            ]) f.Suffix            = s.Suffix               ; else s.Suffix            = f.Suffix              ;
    if([self nullorempty:f.Nickname          ]) f.Nickname          = s.Nickname             ; else s.Nickname          = f.Nickname            ;
    if([self nullorempty:f.FirstNamePhonetic ]) f.FirstNamePhonetic = s.FirstNamePhonetic    ; else s.FirstNamePhonetic = f.FirstNamePhonetic   ;
    if([self nullorempty:f.LastNamePhonetic  ]) f.LastNamePhonetic  = s.LastNamePhonetic     ; else s.LastNamePhonetic  = f.LastNamePhonetic    ;
    if([self nullorempty:f.MiddleNamePhonetic]) f.MiddleNamePhonetic= s.MiddleNamePhonetic   ; else s.MiddleNamePhonetic= f.MiddleNamePhonetic  ;
    if([self nullorempty:f.Organization      ]) f.Organization      = s.Organization         ; else s.Organization      = f.Organization        ;
    if([self nullorempty:f.JobTitle          ]) f.JobTitle          = s.JobTitle             ; else s.JobTitle          = f.JobTitle            ;
    if([self nullorempty:f.Department        ]) f.Department        = s.Department           ; else s.Department        = f.Department          ;
    if([self nullorempty:f.CreationDate      ]) f.CreationDate      = s.CreationDate         ; else s.CreationDate      = f.CreationDate        ;
    if([self nullorempty:f.ModificationDate  ]) f.ModificationDate  = s.ModificationDate     ; else s.ModificationDate  = f.ModificationDate    ;
    if([self nullorempty:f.PhoneNumbers      ]) f.PhoneNumbers      = s.PhoneNumbers         ; else s.PhoneNumbers      = f.PhoneNumbers        ;
    if([self nullorempty:f.PhoneMain         ]) f.PhoneMain         = s.PhoneMain            ; else s.PhoneMain         = f.PhoneMain           ;
    if([self nullorempty:f.PhoneMobile       ]) f.PhoneMobile       = s.PhoneMobile          ; else s.PhoneMobile       = f.PhoneMobile         ;
    if([self nullorempty:f.PhoneIPhone       ]) f.PhoneIPhone       = s.PhoneIPhone          ; else s.PhoneIPhone       = f.PhoneIPhone         ;
    if([self nullorempty:f.PhoneHomeFax      ]) f.PhoneHomeFax      = s.PhoneHomeFax         ; else s.PhoneHomeFax      = f.PhoneHomeFax        ;
    if([self nullorempty:f.PhoneWorkFax      ]) f.PhoneWorkFax      = s.PhoneWorkFax         ; else s.PhoneWorkFax      = f.PhoneWorkFax        ;
    if([self nullorempty:f.PhoneOtherFax     ]) f.PhoneOtherFax     = s.PhoneOtherFax        ; else s.PhoneOtherFax     = f.PhoneOtherFax       ;
    if([self nullorempty:f.PhonePager        ]) f.PhonePager        = s.PhonePager           ; else s.PhonePager        = f.PhonePager          ;
    if([self nullorempty:f.EMails            ]) f.EMails            = s.EMails               ; else s.EMails            = f.EMails              ;
    if([self nullorempty:f.WorkEmail         ]) f.WorkEmail         = s.WorkEmail            ; else s.WorkEmail         = f.WorkEmail           ;
    if([self nullorempty:f.HomeEmail         ]) f.HomeEmail         = s.HomeEmail            ; else s.HomeEmail         = f.HomeEmail           ;
    if([self nullorempty:f.OtherEmail        ]) f.OtherEmail        = s.OtherEmail           ; else s.OtherEmail        = f.OtherEmail          ;
}

- (BOOL)isSameFirst:(Person*)first Second:(Person*)second {
    return [ self isCommonValueFoundFirst:first.PhoneNumbers Second:second.PhoneNumbers] || [ self isCommonValueFoundFirst:first.EMails Second:second.EMails];
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
@end
