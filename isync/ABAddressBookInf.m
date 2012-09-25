
#import "ABAddressBookInf.h"
#import "GDataXMLNode.h"
#import "Person.h"

@implementation ABAddressBookInf

+( NSMutableArray* )getPhoneContactList{
    
    NSMutableArray* phoneContactsList=[NSMutableArray alloc];
    Person *person;
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i=0; i<CFArrayGetCount(people);i++)
    {
        person=[[Person alloc] init];

        ABRecordRef record = CFArrayGetValueAtIndex(people,i);
        
        person.FirstName = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonFirstNameProperty)));
        person.LastName = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonLastNameProperty)));
        person.MiddleName = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonMiddleNameProperty)));
        person.Prefix = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonPrefixProperty)));
        person.Suffix = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonSuffixProperty)));
        person.Nickname = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonNicknameProperty)));
        person.FirstNamePhonetic = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty)));
        person.LastNamePhonetic = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty)));
        person.MiddleNamePhonetic = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty)));
        person.Organization = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonOrganizationProperty)));
        person.JobTitle = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonJobTitleProperty)));
        person.Department = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonDepartmentProperty)));
        person.CreationDate = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonCreationDateProperty)));
        person.ModificationDate = (__bridge NSString *)((ABRecordCopyValue(record, kABPersonModificationDateProperty)));
        
        person.PhoneNumbers = (__bridge NSMutableArray *)(ABRecordCopyValue(record,kABPersonPhoneProperty));
        
        NSLog(@"Phone Numbers");
        int phoneNumberCount = ABMultiValueGetCount((__bridge ABMultiValueRef)(person.PhoneNumbers));
        if (phoneNumberCount > 0) {
            for (CFIndex i = 0; i < phoneNumberCount; i++) {
                NSLog(@"\n%@\t%@",
                      (__bridge NSString*) ABAddressBookCopyLocalizedLabel(
                                                                           ABMultiValueCopyLabelAtIndex((__bridge ABMultiValueRef)(person.PhoneNumbers), i)),
                      (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex((__bridge ABMultiValueRef)(person.PhoneNumbers), i));
            }
        }
        
        person.EMails = (__bridge NSMutableArray *)((ABRecordCopyValue(record, kABPersonEmailProperty)));
        NSLog(@"EMails");
        int EMailCount = ABMultiValueGetCount((__bridge ABMultiValueRef)(person.EMails));
        if (EMailCount > 0) {
            for (CFIndex i = 0; i < EMailCount; i++) {
                NSLog(@"\n%@\t%@",
                      (__bridge NSString*) ABAddressBookCopyLocalizedLabel(
                                                                           ABMultiValueCopyLabelAtIndex((__bridge ABMultiValueRef)(person.EMails), i)),
                      (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex((__bridge ABMultiValueRef)(person.EMails), i));
            }
        }
        
        [phoneContactsList addObject:person];
    }
    
    return phoneContactsList;    
}

+(NSMutableArray *)getGmailContactsListAfterParsing:(NSMutableData *)xmlData{
    NSError *xmlError;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&xmlError];
    if (doc == nil) { return NULL; }
    NSLog(@"%@", doc.rootElement);
    NSArray *allContacts = [doc.rootElement elementsForName:@"entry"];
    NSLog(@"%u",allContacts.count);
    
    NSMutableArray* gmailContactsList=[NSMutableArray alloc];
    Person *person;
    
    for (GDataXMLElement *contactElement in allContacts) {
        person=[[Person alloc] init];
        person.FirstName = [[[contactElement elementsForName:@"title"] objectAtIndex:0] stringValue];
        
        
        //Email
        NSArray *emailElement=[contactElement elementsForName:@"gd:email"];
        person.EMails=[[NSMutableArray alloc] init];                
        for(GDataXMLElement *email in emailElement){
            NSString *emailAddress = [[email attributeForName:@"address"] stringValue];
            [person.EMails addObject:emailAddress];
            
            NSString *label = [[email attributeForName:@"rel"]stringValue];
            if(label == (id)[NSNull null] || label.length == 0){
                label = [[email attributeForName:@"label"] stringValue];
            }
            
            if([label rangeOfString:@"home"].length != 0){
                person.HomeEmail=emailAddress;
            }
            if([label rangeOfString:@"work"].length != 0){
                person.WorkEmail=emailAddress;
            }
            if([label rangeOfString:@"other"].length != 0){
                person.OtherEmail=emailAddress;
            }            
        }
        
        NSArray *phoneNumbers = [contactElement elementsForName:@"gd:phoneNumber"];
        person.PhoneNumbers=[[NSMutableArray alloc] init];
        for(GDataXMLElement *phoneNumber in phoneNumbers){
            NSString *phone = [phoneNumber stringValue];
            [person.PhoneNumbers addObject:phone];
            
            NSString *label = [[phoneNumber attributeForName:@"rel"]stringValue];
            if(label == (id)[NSNull null] || label.length == 0){
                label = [[phoneNumber attributeForName:@"label"] stringValue];
            }
            
            if([label rangeOfString:@"main"].length != 0){
                person.PhoneMain=phone;
            }
            if([label rangeOfString:@"mobile"].length != 0){
                person.PhoneMobile=phone;
            }
        }
        
        
        [gmailContactsList addObject:person];
    }
    
    return gmailContactsList;
}
@end
