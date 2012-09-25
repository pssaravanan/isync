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
//-(void) contactsFetched:(NSMutableData*)contactsResponse{
//    NSMutableArray* IPhoneContactList=[ABAddressBookInf getPhoneContactList];
//    
//    NSMutableArray* GmailContactList= [ABAddressBookInf getGmailContactsListAfterParsing:contactsResponse];
//    
//    NSMutableArray* contactsToBeAddedToGmail=[[NSMutableArray alloc] init];
//    NSMutableArray* contactsToBeAddedToPhone=[[NSMutableArray alloc] init];
//    
//    for (Person *p1 in IPhoneContactList) {
//        for (Person *p2 in GmailContactList) {
//            if ([self isSameFirst:p1 Second:p2]) {
//                
//            }
//        }
//    }
//    
//    
//    for (int i=0; i<IPhoneContactList.count;i++){
//        for (int j=0; j<GmailContactList.count; j++) {
//            ABRecordRef record1 = CFArrayGetValueAtIndex(IPhoneContactList,i);
//            ABRecordRef record2 = CFArrayGetValueAtIndex(GmailContactList,j);
//            
//            Person p1=[IPhoneContactList objectAtIndex:i
//            
//            
//            [[[UIAlertView alloc] initWithTitle:@"Alert!!"
//                                        message:(([self isSameFirst:record1 Second:record2])? @"TRUE" : @"FALSE")
//                                       delegate:self
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil
//              ]
//             show];
//
//        }
//    }
//    
//}
//
//                   
//                       - (BOOL)isSameFirst:(Person*)first Second:(Person*)second {
//                           
//                           ABMutableMultiValueRef PhoneNumbers1 = ABRecordCopyValue(first,kABPersonPhoneProperty);
//                           ABMutableMultiValueRef PhoneNumbers2 = ABRecordCopyValue(second,kABPersonPhoneProperty);
//                           if( [ self isCommonValueFoundFirst:PhoneNumbers1 Second:PhoneNumbers2])
//                               return YES;
//                           
//                           ABMutableMultiValueRef EMail1 = ABRecordCopyValue(first,kABPersonEmailProperty);
//                           ABMutableMultiValueRef EMail2 = ABRecordCopyValue(second,kABPersonEmailProperty);
//                           return [ self isCommonValueFoundFirst:EMail1 Second:EMail2];
//                           
//                       }

- (BOOL)isCommonValueFoundFirst:(ABMutableMultiValueRef) first Second :(ABMutableMultiValueRef) second{
    
    
    int count1 = ABMultiValueGetCount(first);
    int count2 = ABMultiValueGetCount(second);
    
    if (count1 > 0 && count2 > 0) {
        for (CFIndex i = 0; i < count1; i++) {
            for (CFIndex j = 0; j < count2; j++) {
                
                NSString *str1=(__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(first, i);
                NSString *str2=(__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(second, j);
                if([str1 isEqualToString:str2])
                    return YES;
            }
        }
    }
    return NO;
}


@end
