

#import <UIKit/UIKit.h>
#import "AddressBookUI/AddressBookUI.h"
#import "AddressBook/AddressBook.h"

@interface Person : NSObject

@property (atomic) NSInteger phonePersonId ;


@property (nonatomic,strong) NSString* FirstName ;
@property (nonatomic,strong) NSString* LastName ;
@property (nonatomic,strong) NSString* MiddleName ;
@property (nonatomic,strong) NSString* Organization ;
@property (nonatomic,strong) NSString* JobTitle ;
@property (nonatomic,strong) NSString* Department ;


//Phone Numbers
@property (nonatomic,strong) NSMutableArray* PhoneNumbers;
@property (nonatomic,strong) NSString* PhoneMain ;
@property (nonatomic,strong) NSString* PhoneMobile ;
@property (nonatomic,strong) NSString* PhoneIPhone ;

//Emails
@property (nonatomic,strong) NSMutableArray* EMails;
@property (nonatomic,strong) NSString* WorkEmail;
@property (nonatomic,strong) NSString* HomeEmail;
@property (nonatomic,strong) NSString* OtherEmail;


@end


