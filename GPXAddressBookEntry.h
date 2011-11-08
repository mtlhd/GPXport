//
//  GPXAddressBookEntry.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-12.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/ABMultiValue.h>

@interface GPXAddressBookEntry : NSObject {
	NSString*		displayName;
	NSString*		addressKey;
	NSString*		street;
	NSString*		city;
	NSString*		state;
	NSString*		zip;
	NSString*		country;
	
	NSMutableArray*	phoneNumbers;
	NSMutableArray*	mobileNumbers;
	NSMutableArray*	faxNumbers;
	NSMutableArray*	emailAddresses;
}

@property(readwrite, copy) NSString* displayName;
@property(readwrite, copy) NSString* addressKey;
@property(readwrite, copy) NSString* street;
@property(readwrite, copy) NSString* city;
@property(readwrite, copy) NSString* state;
@property(readwrite, copy) NSString* zip;
@property(readwrite, copy) NSString* country;

@property(readonly) NSArray* phoneNumbers;
@property(readonly) NSArray* mobileNumbers;
@property(readonly) NSArray* faxNumbers;
@property(readonly) NSArray* emailAddresses;

- (void)addPhoneNumbers:(ABMultiValue*)phones matchingLabel:(NSString*)label;
- (void)addEmailAddresses:(ABMultiValue*)emails matchingLabel:(NSString*)label;

@end
