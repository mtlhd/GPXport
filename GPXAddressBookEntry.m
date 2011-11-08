//
//  GPXAddressBookEntry.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-12.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <AddressBook/ABGlobals.h>

#import "GPXAddressBookEntry.h"

@interface GPXAddressBookEntry (Private)

typedef enum 
{
	NONE = 0,
	PHONE,
	MOBILE,
	FAX,
	EMAIL
} PhoneType;

+ (NSString *)stripWhiteSpaces:(NSString *)aString;
- (void)addPhone:(NSString*)aPhone withType:(PhoneType)aType;
- (void)addEmail:(NSString*)aEmail;
+ (PhoneType)convertLabelToPhoneType:(NSString*)aLabel;

@end


@implementation GPXAddressBookEntry

@synthesize displayName;
@synthesize addressKey;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize country;

@synthesize phoneNumbers;
@synthesize mobileNumbers;
@synthesize faxNumbers;
@synthesize emailAddresses;

- (id) init
{
	self = [super init];
	
	if (self != nil) 
	{
		displayName = nil;
		addressKey = nil;
		
		street = nil;
		city = nil;
		state = nil;
		zip = nil;
		country = nil;
	
		phoneNumbers = [[NSMutableArray alloc] init];
		mobileNumbers = [[NSMutableArray alloc] init];
		faxNumbers = [[NSMutableArray alloc] init];
		emailAddresses = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	[displayName release];
	[addressKey release];
	
	[street release];
	[city release];
	[state release];
	[zip release];
	[country release];
	
	[phoneNumbers release];
	[mobileNumbers release];
	[faxNumbers release];
	[emailAddresses release];
	
	[super dealloc];
}

- (NSString*)description
{
	return [NSString stringWithString:displayName];
}

- (void)addPhoneNumbers:(ABMultiValue*)phones matchingLabel:(NSString*)label
{
	if ((phones == nil) ||
		(label == nil))
		return;
	
	for (int idx = 0; idx < [phones count]; ++idx)
	{
		if ([[phones labelAtIndex:idx] isEqualToString:label])
		{
			DEBUG_PRINT(@"Adding %@", [phones valueAtIndex:idx]);
			[self addPhone:[phones valueAtIndex:idx] withType:[GPXAddressBookEntry convertLabelToPhoneType:label]];
		}
	}
}

- (void)addEmailAddresses:(ABMultiValue*)emails matchingLabel:(NSString*)label
{
	if ((emails == nil) ||
		(label == nil))
		return;
	
	for (int idx = 0; idx < [emails count]; ++idx)
	{
		if ([[emails labelAtIndex:idx] isEqualToString:label])
		{
			DEBUG_PRINT(@"Adding %@", [emails valueAtIndex:idx]);
			[self addEmail:[emails valueAtIndex:idx]];
		}
	}
}

#pragma mark --- Private parts ---
+ (NSString *)stripWhiteSpaces:(NSString *)aString
{
	NSMutableString* result = [NSMutableString string];
	
	NSCharacterSet* WS = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSArray* components = [aString componentsSeparatedByCharactersInSet:WS];
	
	for (NSString* component in components)
	{
		if ((component != nil) && ([component length] > 0))
		{
			[result appendString:[component stringByTrimmingCharactersInSet:WS]];
		}
	}
	
	return [result substringToIndex:[result length]];
}

- (void)addPhone:(NSString*)aPhone withType:(PhoneType)aType
{
	if ((aPhone != nil) &&
		([aPhone length] > 0))
	{
		NSString* tmpPhone = [GPXAddressBookEntry stripWhiteSpaces:aPhone];
		if ([tmpPhone length] > 0)
		{
			switch (aType) {
				case PHONE:
					DEBUG_PRINT(@"Phone number");
					[phoneNumbers addObject:tmpPhone];
					break;
				case MOBILE:
					DEBUG_PRINT(@"Mobile number");
					[mobileNumbers addObject:tmpPhone];
					break;
				case FAX:
					DEBUG_PRINT(@"Fax number");
					[faxNumbers addObject:tmpPhone];
					break;
				case NONE:
				case EMAIL:
				default:
					DEBUG_PRINT(@"Skipped phone number");
					break;
			}
		}
	}
}

- (void)addEmail:(NSString*)aEmail
{
	if ((aEmail != nil) &&
		([aEmail length] > 0))
	{
		NSString* tmpEmail = [GPXAddressBookEntry stripWhiteSpaces:aEmail];
		if ([tmpEmail length] > 0)
		{
			[emailAddresses addObject:tmpEmail];
		}
	}
}

+ (PhoneType)convertLabelToPhoneType:(NSString*)aLabel
{
	if (([aLabel isEqualToString:kABPhoneWorkLabel]) ||			// Phone numbers
		([aLabel isEqualToString:kABPhoneHomeLabel]) ||
		([aLabel isEqualToString:kABPhoneMainLabel]))
	{
		return PHONE;
	}
	else if ([aLabel isEqualToString:kABPhoneMobileLabel])		// Mobile numbers
	{
		return MOBILE;
	}
	else if (([aLabel isEqualToString:kABPhoneWorkFAXLabel]) ||	// Fax numbers
			 ([aLabel isEqualToString:kABPhoneHomeFAXLabel]))
	{
		return FAX;
	}
	
	return NONE;
}

@end
