//
//  GPXWaypoint.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPXError.h"

@class GPXLink;

@interface GPXWaypoint : NSObject 
{
@public
//	float			elevation;
//	NSDate			*dateTime;		// ISO8601 output
//	float			magvar;			// 0.0 <= value < 360.0
//	float			geoidheight;	
	NSString*		name;			// Waypoint name
	NSString*		desc;			// Description
	NSString*		src;			// Source
	NSString*		sym;			// Symbol
	NSString*		type;			// Waypoint type
	
	// Extensions
	NSString*		street;
	NSString*		city;
	NSString*		state;
	NSString*		zip;
	NSString*		country;
	
//	GPXFix			*fix;
//	unsigned int	sat;
//	float			hdop;
//	float			vdop;
//	float			pdop;
//	float			ageofdgpsdata;
//	GPXStation		*dgpsid;
//	GPXExtension	*extension;

@private
	float			latitude;		// -90.0 <= value <= 90.0
	float			longitude;		// -180.0 <= value < 180.0
	NSMutableArray*	links;			// Links to more information about the waypoint
	NSMutableArray*	phoneNumbers;
	NSMutableArray*	mobileNumbers;
	NSMutableArray*	faxNumbers;
	NSMutableArray*	emailAddresses;
}

- (GPXError)setLatitude:(float)aLatitude;
- (float)latitude;

- (GPXError)setLongitude:(float)aLongitude;
- (float)longitude;

//- (NSArray*)links;
- (GPXError)addLink:(GPXLink *)aLink;
- (GPXError)removeLink:(GPXLink *)aLink;
- (GPXError)removeAllLinks;

- (NSArray*)phoneNumbers;
- (GPXError)addPhoneNumber:(NSString*)aPhoneNumber;
- (GPXError)removePhoneNumber:(NSString*)aPhoneNumber;
- (GPXError)removeAllPhoneNumbers;

- (NSArray*)mobileNumbers;
- (GPXError)addMobileNumber:(NSString*)aMobileNumber;
- (GPXError)removeMobileNumber:(NSString*)aMobileNumber;
- (GPXError)removeAllMobileNumbers;

- (NSArray*)faxNumbers;
- (GPXError)addFaxNumber:(NSString*)aFaxNumber;
- (GPXError)removeFaxNumber:(NSString*)aFaxNumber;
- (GPXError)removeAllFaxNumbers;

- (NSArray*)emailAddresses;
- (GPXError)addEmailAddress:(NSString*)aEmailAddress;
- (GPXError)removeEmailAddress:(NSString*)aEmailAddress;
- (GPXError)removeAllEmailAddresses;

@property(readwrite, copy) NSString	*name;
@property(readwrite, copy) NSString	*desc;
@property(readwrite, copy) NSString	*src;
@property(readwrite, copy) NSString	*sym;
@property(readwrite, copy) NSString *type;

@property(readwrite, copy) NSString *street;
@property(readwrite, copy) NSString *city;
@property(readwrite, copy) NSString *state;
@property(readwrite, copy) NSString *zip;
@property(readwrite, copy) NSString *country;

@property(readonly) NSArray* links;
@property(readonly) NSArray* phoneNumbers;
@property(readonly) NSArray* mobileNumbers;
@property(readonly) NSArray* faxNumbers;
@property(readonly) NSArray* emailAddresses;

@end
