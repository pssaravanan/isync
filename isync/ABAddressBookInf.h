
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ABAddressBookInf : NSObject

+(NSMutableArray *)getPhoneContactList;
+(NSMutableArray *)getGmailContactsListAfterParsing:(NSMutableData *)xmlData;

@end
