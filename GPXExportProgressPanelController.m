//
//  GPXExportProgressDialogController.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABMultiValue.h>
#import <AddressBook/ABPerson.h>

#import "GPXExportProgressPanelController.h"
#import	"GPXWaypoint.h"
#import "GPXGoogleMaps.h"
#import "GPXFile.h"
#import "GPXGpxFile.h"
#import "GPXGarminPoiFile.h"
#import "GPXAddressBookEntry.h"


@interface GPXExportProgressPanelController (Private)

- (void)startProcessing;
- (void)startGeoCoding;
- (void)finalizeGeoCoding:(GPXWaypoint *)aWaypoint;
- (void)parseAddressBookRecords;
- (void)updateProgressbarValue:(double)aValue;
- (void)setProgressBarMaxValue:(double)aMaxValue;
- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;

@end


@implementation GPXExportProgressPanelController

- (id)init
{
	self = [super initWithWindowNibName:@"GPXExportProgressDialog"];
	
	if (self != nil) 
	{
		waypointCache = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}

- (void)dealloc
{
	[waypointCache release];

	[super dealloc];
}

- (IBAction)cancelButtonClick:(id)sender
{
	cancelExport = TRUE;
}

- (IBAction)showPanel:(id)sender;
{
	[progressIndicator setMinValue:(double)0.0];
	[self setProgressBarMaxValue:(double)100.0];
	[self updateProgressbarValue:(double)0.0];

	[NSApp beginSheet:progressPanel 
	   modalForWindow:parentWindow
		modalDelegate:self 
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:sender];

	[self startProcessing];
}

- (void)hidePanel
{
	[progressPanel orderOut:nil];
	[NSApp endSheet:progressPanel];
}

- (void)setRecords:(NSMutableArray *)aRecords
{
	records = [aRecords retain];
}

- (void)setFilename:(NSString *)aFilename
{
	filename = [aFilename copy];
}

- (void)setExportFilterWork:(BOOL)work home:(BOOL)home other:(BOOL)other
{
	includeWork = work;
	includeHome = home;
	includeOther = other;
}

- (void)startProcessing
{
	[geoCoder release];
	geoCoder = [[GPXGoogleMaps alloc] initWithClient:self];
	
	if ([filename hasSuffix:@"csv"])
	{
		gpxFile = [[GPXGarminPoiFile alloc] init];
	}
	else if ([filename hasSuffix:@"gpx"])
	{
		gpxFile = [[GPXGpxFile alloc] init];
	}
	else
	{
		gpxFile = [[GPXGpxFile alloc] init];	// Default to GPX file
	}
	
	cancelExport = FALSE;
	
	[self parseAddressBookRecords];

	[self setProgressBarMaxValue:(double)[addressBook count]];
	[self updateProgressbarValue:(double)0.0];

	[self startGeoCoding];
}

- (void)parseAddressBookRecords
{
	addressBook = [[NSMutableArray alloc] init];

	while ([records count] > 0)
	{
		ABPerson *record = [records lastObject];
		BOOL company = FALSE;
		
		if ([record class] == [ABPerson class])
		{
			NSMutableString *displayName = [NSMutableString string];

			if (([[record valueForProperty:kABPersonFlags] intValue] & kABShowAsMask) == kABShowAsCompany)
			{
				company = TRUE;
				[displayName appendString:[record valueForProperty:kABOrganizationProperty]];
			}
			else
			{
				if ([record valueForProperty:kABFirstNameProperty] != nil)
				{
					[displayName appendString:[record valueForProperty:kABFirstNameProperty]];
					[displayName appendString:@" "];
				}
				if ([record valueForProperty:kABLastNameProperty] != nil)
				{
					[displayName appendString:[record valueForProperty:kABLastNameProperty]];
					[displayName appendString:@" "];
				}
			}

			ABMultiValue *adresses = [record valueForProperty:kABAddressProperty];
			ABMultiValue *phones = [record valueForProperty:kABPhoneProperty];
			ABMultiValue *emails = [record valueForProperty:kABEmailProperty];
			
			if (adresses != nil)
			{
				for (int idx = 0; idx < [adresses count]; ++idx)
				{
					// Filter out categories
					if (([[adresses labelAtIndex:idx] isEqualToString:kABWorkLabel] && !includeWork) ||
						([[adresses labelAtIndex:idx] isEqualToString:kABHomeLabel] && !includeHome) ||
						([[adresses labelAtIndex:idx] isEqualToString:kABOtherLabel] && !includeOther))
					{
						continue;
					}
						
					NSDictionary *addressEntry = [adresses valueAtIndex:idx];
					NSString* street = [addressEntry valueForKey:kABAddressStreetKey];
					NSString* city = [addressEntry valueForKey:kABAddressCityKey];
					NSString* state = [addressEntry valueForKey:kABAddressStateKey];
					NSString* zip = [addressEntry valueForKey:kABAddressZIPKey];
					NSString* country = [addressEntry valueForKey:kABAddressCountryKey];
					
					NSString* addressKey = [GPXGeoCoder convertStreet:street
																 city:city 
																state:state
																  zip:zip
															  country:country];
					
					GPXAddressBookEntry *addressBookEntry = [[GPXAddressBookEntry alloc] init];
					
					if (!company && ([[adresses labelAtIndex:idx] isEqualToString:kABHomeLabel]))
					{
						[addressBookEntry setDisplayName:[NSString stringWithFormat:@"%@(%@)", 
														  displayName, 
														  NSLocalizedString(@"home", @"Home address label")]];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneHomeLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneHomeFAXLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneMobileLabel];
						[addressBookEntry addEmailAddresses:emails matchingLabel:kABHomeLabel];
					}
					else if (!company && ([[adresses labelAtIndex:idx] isEqualToString:kABWorkLabel]))
					{
						[addressBookEntry setDisplayName:[NSString stringWithFormat:@"%@(%@)", 
														  displayName, 
														  NSLocalizedString(@"work", @"Work address label")]];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneWorkLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneWorkFAXLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneMobileLabel];
						[addressBookEntry addEmailAddresses:emails matchingLabel:kABWorkLabel];
					}
					else if (company && ([[adresses labelAtIndex:idx] isEqualToString:kABWorkLabel]))
					{
						// Company address
						[addressBookEntry setDisplayName:displayName];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneWorkLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneWorkFAXLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneMobileLabel];
						[addressBookEntry addEmailAddresses:emails matchingLabel:kABWorkLabel];
					}
					else
					{
						[addressBookEntry setDisplayName:displayName];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABOtherLabel];
						[addressBookEntry addPhoneNumbers:phones matchingLabel:kABPhoneMobileLabel];
						[addressBookEntry addEmailAddresses:emails matchingLabel:kABOtherLabel];
					}
					
					[addressBookEntry setAddressKey:addressKey];
					
					[addressBookEntry setStreet:street];
					[addressBookEntry setCity:city];
					[addressBookEntry setState:state];
					[addressBookEntry setZip:zip];
					[addressBookEntry setCountry:country];
					
					[addressBook addObject:addressBookEntry];
					[addressBookEntry release];
				}
			}
		}
		
		[records removeLastObject];
	}
	
	[records release];
}

- (void)startGeoCoding
{
	DEBUG_PRINT(@"%d entries remaining to be geo coded", [addressBook count]);

	if (!cancelExport && ([addressBook count] > 0))
	{
		GPXAddressBookEntry *entry = [addressBook lastObject];
		GPXWaypoint *tmpWaypoint = [waypointCache objectForKey:[entry addressKey]];
		
		if (tmpWaypoint != nil)
		{
			GPXWaypoint *waypoint = [[GPXWaypoint alloc] init];
			(void)[waypoint setLatitude:[tmpWaypoint latitude]];
			(void)[waypoint setLongitude:[tmpWaypoint longitude]];
			[self finalizeGeoCoding:[waypoint autorelease]];
		}
		else
		{
			[geoCoder queryGeoCodeServerWithStreet:[entry street] 
											  city:[entry city]
											 state:[entry state]
											   zip:[entry zip]
										   country:[entry country]];
		}
	}
	else
	{
		[gpxFile save:filename];
		[gpxFile release];
		
		[addressBook release];
		[filename release];
		[self hidePanel];
	}
}

- (void)finalizeGeoCoding:(GPXWaypoint *)aWaypoint
{
	if (aWaypoint != nil)
	{
		GPXAddressBookEntry *entry = [addressBook lastObject];
		[aWaypoint setName:[entry displayName]];
		[aWaypoint setSym:@"Waypoint"];

		for (NSString* phone in [entry phoneNumbers]) {
			[aWaypoint addPhoneNumber:phone];
		}
		for (NSString* mobile in [entry mobileNumbers]) {
			[aWaypoint addMobileNumber:mobile];
		}
		for (NSString* fax in [entry faxNumbers]) {
			[aWaypoint addFaxNumber:fax];
		}
		for (NSString* email in [entry emailAddresses]) {
			[aWaypoint addEmailAddress:email];
		}
		
		[aWaypoint setStreet:[entry street]];
		[aWaypoint setCity:[entry city]];
		[aWaypoint setCountry:[entry country]];
		[aWaypoint setState:[entry state]];
		[aWaypoint setZip:[entry zip]];
		
		if ([waypointCache objectForKey:[entry addressKey]] == nil)
		{
			[waypointCache setObject:aWaypoint 
							  forKey:[entry addressKey]];
		}
		[gpxFile addWaypoint:aWaypoint];
		DEBUG_PRINT(@"%@: %@", entry, aWaypoint);
	}

	[self updateProgressbarValue:(progressBarValue + 1.0)];
	[addressBook removeLastObject];
	[self startGeoCoding];
}

- (void)transferComplete:(GPXWaypoint *)aWaypoint
{
	[self finalizeGeoCoding:aWaypoint];
}

- (void)transferFailed:(NSError *)aError
{
	[self finalizeGeoCoding:nil];
}

- (void)updateProgressbarValue:(double)aValue
{
	progressBarValue = aValue;
	[progressIndicator setDoubleValue:progressBarValue];
	[progressLabel setStringValue:[NSString stringWithFormat:@"%d/%d (%.0f%%)", 
								   (int)progressBarValue, 
								   (int)progressBarMaxValue, 
								   ((progressBarValue / progressBarMaxValue) * 100)]];
}

- (void)setProgressBarMaxValue:(double)aMaxValue
{
	progressBarMaxValue = aMaxValue;
	[progressIndicator setMaxValue:progressBarMaxValue];
	[progressLabel setStringValue:@""];
}

- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo
{
	NSObject* obj = (NSObject*)contextInfo;
	SEL exportComplete = @selector(exportCompleted);
	
	if ((obj != nil) &&
		[obj respondsToSelector:exportComplete])
	{
		[obj performSelector:exportComplete];
	}
}

@end
