
#import "ABAddressBookInf.h"
#import "GDataXMLNode.h"
#import "Person.h"

@implementation ABAddressBookInf

+( NSMutableArray* )getPhoneContactList{
    ABAddressBookRef addressBook =  ABAddressBookCreate();
    CFArrayRef peopleList = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    
    //generate list of person objects and return -WIP
    return (__bridge NSMutableArray *)(peopleList);
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
                
        for(GDataXMLElement *element in emailElement){
            NSString *emailAddress = [[element attributeForName:@"address"] stringValue];
            
            [person.EMails addObject:emailAddress];

            NSString *label = [[element attributeForName:@"rel"]stringValue];
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
