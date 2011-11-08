//
//  GPXWaypoint.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXWaypoint.h"

#import "GPXLink.h"

const NSString* NEWLINE = @"\n";
const NSString* HOME_SYMBOL = @"Residence";
const NSString* WORK_SYMBOL = @"Waypoint";
const NSString* OTHER_SYMBOL = @"Waypoint";


@implementation GPXWaypoint

#pragma mark --- Properties ---
@synthesize name;
@synthesize desc;
@synthesize src;
@synthesize sym;
@synthesize type;

@synthesize street;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize country;

@synthesize links;
@synthesize phoneNumbers;
@synthesize mobileNumbers;
@synthesize faxNumbers;
@synthesize emailAddresses;

- (id)init
{
	self = [super init];
	
	if (self != nil) 
	{
		latitude = 0.0;
		longitude = 0.0;
		
		name = nil;
		desc = nil;
		src = nil;
		sym = nil;
		type = nil;
		
		street = nil;
		city = nil;
		state = nil;
		zip = nil;
		country = nil;
		
		phoneNumbers = [[NSMutableArray alloc] init];
		mobileNumbers = [[NSMutableArray alloc] init];
		faxNumbers = [[NSMutableArray alloc] init];
		emailAddresses = [[NSMutableArray alloc] init];
		links = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	[name release];
	[desc release];
	[src release];
	[sym release];
	[type release];
	
	[street release];
	[city release];
	[state release];
	[zip release];
	[country release];
	
	[phoneNumbers release];
	[mobileNumbers release];
	[faxNumbers release];
	[emailAddresses release];
	[links release];
	
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Lon: %.6f  Lat: %.6f", longitude, latitude];
}

- (GPXError)setLatitude:(float)aLatitude
{
	if ((-90.0 <= aLatitude) && (aLatitude <= 90.0))
	{
		latitude = aLatitude;
		return GPX_OK;
	}
	
	return GPX_BAD_ARGUMENT;
}

- (float)latitude
{
	return latitude;
}

- (GPXError)setLongitude:(float)aLongitude
{
	if ((-180.0 <= aLongitude) && (aLongitude < 180.0))
	{
		longitude = aLongitude;
		return GPX_OK;
	}
	
	return GPX_BAD_ARGUMENT;
}

- (float)longitude
{
	return longitude;
}

- (GPXError)addLink:(GPXLink *)aLink
{
	NSUInteger pos = [links indexOfObject:aLink];
	
	if (pos != NSNotFound) 
	{
		return GPX_DUPLICATE_NOT_ALLOWED;
	}
	
	[links addObject:aLink];
	return GPX_OK;
}

- (GPXError)removeLink:(GPXLink *)aLink
{
	NSUInteger pos = [links indexOfObject:aLink];
	
	if (pos != NSNotFound)
	{
		[links removeObjectAtIndex:pos];
		return GPX_OK;
	}
	
	return GPX_NOT_FOUND;
}

- (GPXError)removeAllLinks
{
	[links removeAllObjects];
	return GPX_OK;
}

- (GPXError)addPhoneNumber:(NSString*)aPhoneNumber
{
	NSUInteger pos = [phoneNumbers indexOfObject:aPhoneNumber];
	
	if (pos != NSNotFound)
	{
		return GPX_DUPLICATE_NOT_ALLOWED;
	}
	
	[phoneNumbers addObject:aPhoneNumber];
	return GPX_OK;
}

- (GPXError)removePhoneNumber:(NSString*)aPhoneNumber
{
	NSUInteger pos = [phoneNumbers indexOfObject:aPhoneNumber];
	
	if (pos != NSNotFound)
	{
		[phoneNumbers removeObjectAtIndex:pos];
		return GPX_OK;
	}
	
	return GPX_NOT_FOUND;
}

- (GPXError)removeAllPhoneNumbers
{
	[phoneNumbers removeAllObjects];
	return GPX_OK;
}

- (GPXError)addMobileNumber:(NSString*)aMobileNumber
{
	NSUInteger pos = [mobileNumbers indexOfObject:aMobileNumber];
	
	if (pos != NSNotFound)
	{
		return GPX_DUPLICATE_NOT_ALLOWED;
	}
	
	[mobileNumbers addObject:aMobileNumber];
	return GPX_OK;
}

- (GPXError)removeMobileNumber:(NSString*)aMobileNumber
{
	NSUInteger pos = [mobileNumbers indexOfObject:aMobileNumber];
	
	if (pos != NSNotFound)
	{
		[mobileNumbers removeObjectAtIndex:pos];
		return GPX_OK;
	}
	
	return GPX_NOT_FOUND;
}

- (GPXError)removeAllMobileNumbers
{
	[mobileNumbers removeAllObjects];
	return GPX_OK;
}

- (GPXError)addFaxNumber:(NSString*)aFaxNumber
{
	NSUInteger pos = [faxNumbers indexOfObject:aFaxNumber];
	
	if (pos != NSNotFound)
	{
		return GPX_DUPLICATE_NOT_ALLOWED;
	}
	
	[faxNumbers addObject:aFaxNumber];
	return GPX_OK;
}

- (GPXError)removeFaxNumber:(NSString*)aFaxNumber
{
	NSUInteger pos = [faxNumbers indexOfObject:aFaxNumber];
	
	if (pos != NSNotFound)
	{
		[faxNumbers removeObjectAtIndex:pos];
		return GPX_OK;
	}
	
	return GPX_NOT_FOUND;
}

- (GPXError)removeAllFaxNumbers
{
	[faxNumbers removeAllObjects];
	return GPX_OK;
}

- (GPXError)addEmailAddress:(NSString*)aEmailAddress
{
	NSUInteger pos = [emailAddresses indexOfObject:aEmailAddress];
	
	if (pos != NSNotFound)
	{
		return GPX_DUPLICATE_NOT_ALLOWED;
	}
	
	[emailAddresses addObject:aEmailAddress];
	return GPX_OK;
}

- (GPXError)removeEmailAddress:(NSString*)aEmailAddress
{
	NSUInteger pos = [emailAddresses indexOfObject:aEmailAddress];
	
	if (pos != NSNotFound)
	{
		[emailAddresses removeObjectAtIndex:pos];
		return GPX_OK;
	}
	
	return GPX_NOT_FOUND;
}

- (GPXError)removeAllEmailAddresses
{
	[emailAddresses removeAllObjects];
	return GPX_OK;
}

@end
