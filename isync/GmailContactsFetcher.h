//
//  GmailContactsFetcher.h
//  isync
//
//  Created by Admin on 18/09/12.
//  Copyright (c) 2012 saravanp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmailContactsFetcher : NSObject{
    
}

-(void)fetchGmailContactswithAuthToken:(NSString *)authToken CallbackObj:(id)callbackObj;
@end
