

#import <UIKit/UIKit.h>
#import "AddressBookUI/AddressBookUI.h"
#import "AddressBook/AddressBook.h"

@interface Person : NSObject


@property (atomic) int recordId;

@property (nonatomic,strong) NSString* FirstName ;
@property (nonatomic,strong) NSString* LastName ;
@property (nonatomic,strong) NSString* MiddleName ;
@property (nonatomic,strong) NSString* Prefix ;
@property (nonatomic,strong) NSString* Suffix ;
@property (nonatomic,strong) NSString* Nickname ;
@property (nonatomic,strong) NSString* FirstNamePhonetic ;
@property (nonatomic,strong) NSString* LastNamePhonetic ;
@property (nonatomic,strong) NSString* MiddleNamePhonetic ;
@property (nonatomic,strong) NSString* Organization ;
@property (nonatomic,strong) NSString* JobTitle ;
@property (nonatomic,strong) NSString* Department ;

@property (nonatomic,strong) NSString* CreationDate ;
@property (nonatomic,strong) NSString* ModificationDate ;

//Phone Numbers
@property (nonatomic,strong) NSMutableArray* PhoneNumbers;
@property (nonatomic,strong) NSString* PhoneMain ;
@property (nonatomic,strong) NSString* PhoneMobile ;
@property (nonatomic,strong) NSString* PhoneIPhone ;
@property (nonatomic,strong) NSString* PhoneHomeFax ;
@property (nonatomic,strong) NSString* PhoneWorkFax ;
@property (nonatomic,strong) NSString* PhoneOtherFax ;
@property (nonatomic,strong) NSString* PhonePager ;

//Emails
@property (nonatomic,strong) NSMutableArray* EMails;
@property (nonatomic,strong) NSString* WorkEmail;
@property (nonatomic,strong) NSString* HomeEmail;
@property (nonatomic,strong) NSString* OtherEmail;


@end
