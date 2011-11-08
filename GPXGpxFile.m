//
//  GPXFile.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXGpxFile.h"
#import "GPXWaypoint.h"
#import "GPXLink.h"

// TODO: Refactor and create as plugin

@interface GPXGpxFile (Private)

- (NSXMLDocument*)xmlDocument;

- (NSXMLNode*)waypointElement:(GPXWaypoint*)aWaypoint;

- (NSXMLNode*)linkElement:(GPXLink*)aLink;

- (void)addExtensionElement:(NSMutableArray*)aElements 
					   name:(NSString*)aName 
				stringValue:(NSString*)aStringValue 
				   children:(NSArray*)aChildren 
				 attributes:(NSArray*)aAttributes;

- (void)commentFromAddress:(GPXWaypoint*)aWaypoint;

@end


@implementation GPXGpxFile

- (id) init
{
	self = [super init];
	
	if (self != nil) 
	{
		cmt = nil;

		fileExtension = @".gpx";
		fileFormatDescription = @"Garmin GPX File with Extensions v2";
	}
	
	return self;
}

- (void) dealloc
{
	[cmt release];

	[super dealloc];
}

- (GPXError)save:(NSString *)aFilename
{
	GPXError err = GPX_OK;
	
	NSString* filename = [super addFileExtension:aFilename];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filename])
	{
		err =  GPX_BAD_ARGUMENT;
	}
	else
	{
		if (![[NSFileManager defaultManager] createFileAtPath:filename 
													 contents:[[self xmlDocument] XMLData] 
												   attributes:nil])
		{
			DEBUG_PRINT(@"GPXport: Error writing to file %@", filename);
			err = GPX_GENERAL_ERROR;
		}
		
	}

	return err;
}


#pragma mark --- Private parts ---
- (NSXMLDocument *)xmlDocument
{
	NSArray *attributes = [NSArray arrayWithObjects:
						   [NSXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.topografix.com/GPX/1/1"],
						   [NSXMLNode attributeWithName:@"xmlns:gpxx" stringValue:@"http://www.garmin.com/xmlschemas/GpxExtensions/v3"],
						   [NSXMLNode attributeWithName:@"creator" stringValue:@"GPXport"],
						   [NSXMLNode attributeWithName:@"version" stringValue:@"1.1"],
						   [NSXMLNode attributeWithName:@"xmlns:xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"],
						   [NSXMLNode attributeWithName:@"xsi:schemaLocation" stringValue:@"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensions/v3/GpxExtensionsv3.xsd"],
						   nil];
	
	NSMutableArray *children = [NSMutableArray array];
	for (GPXWaypoint *wpt in [self waypoints])
	{
		[children addObject:[self waypointElement:wpt]];
	}
	
	NSXMLDocument *xmlDocument = [NSXMLDocument documentWithRootElement:[NSXMLElement elementWithName:@"gpx" 
																							 children:children 
																						   attributes:attributes]];
	
	[xmlDocument setDocumentContentKind:NSXMLDocumentXMLKind];
	[xmlDocument setCharacterEncoding:@"UTF-8"];
	[xmlDocument setVersion:@"1.0"];
	[xmlDocument setStandalone:FALSE];
	
	return xmlDocument;
}

- (NSXMLNode *)waypointElement:(GPXWaypoint*)aWaypoint
{
	NSMutableArray *children = [NSMutableArray array];
	NSMutableArray *attributes = [NSMutableArray arrayWithObjects:[NSXMLNode attributeWithName:@"lat" 
																				   stringValue:[NSString stringWithFormat:@"%.6f", [aWaypoint latitude]]],
								  [NSXMLNode attributeWithName:@"lon" 
												   stringValue:[NSString stringWithFormat:@"%.6f", [aWaypoint longitude]]],
								  nil];
	
	if (([aWaypoint name] != nil) && ([[aWaypoint name] length] > 0))
	{
		[children addObject:[NSXMLNode elementWithName:@"name" 
										   stringValue:[aWaypoint name]]];
	}
	
	[self commentFromAddress:aWaypoint];
	if ([cmt length] == 0) 
		cmt = [[aWaypoint name] retain];
	[children addObject:[NSXMLNode elementWithName:@"cmt" 
									   stringValue:cmt]];
	
	if (([aWaypoint desc] != nil) && ([[aWaypoint desc] length] > 0))
	{
		[children addObject:[NSXMLNode attributeWithName:@"desc" 
											 stringValue:[aWaypoint desc]]];
	}
	
	if (([aWaypoint src] != nil) && ([[aWaypoint src] length] > 0))
	{
		[children addObject:[NSXMLNode elementWithName:@"src" 
										   stringValue:[aWaypoint src]]];
	}
	
	if (([aWaypoint sym] != nil) && ([[aWaypoint sym] length] > 0))
	{
		[children addObject:[NSXMLNode elementWithName:@"sym" 
										   stringValue:[aWaypoint sym]]];
	}
	
	if (([aWaypoint type] != nil) && ([[aWaypoint type] length] > 0))
	{
		[children addObject:[NSXMLNode elementWithName:@"type" 
										   stringValue:[aWaypoint type]]];
	}
	
	// Handle extensions
	NSMutableArray* gpxxElements = [NSMutableArray array];
	
	if ([[aWaypoint phoneNumbers] count] > 0)
	{
		[self addExtensionElement:gpxxElements 
							 name:@"gpxx:PhoneNumber" 
					  stringValue:[[aWaypoint phoneNumbers] objectAtIndex:0]
						 children:nil 
					   attributes:[NSArray arrayWithObject:[NSXMLNode attributeWithName:@"Category" 
																			stringValue:@"Phone"]]];
	}
	
	if ([[aWaypoint mobileNumbers] count] > 0)
	{
		[self addExtensionElement:gpxxElements 
							 name:@"gpxx:PhoneNumber" 
					  stringValue:[[aWaypoint mobileNumbers] objectAtIndex:0] 
						 children:nil 
					   attributes:[NSArray arrayWithObject:[NSXMLNode attributeWithName:@"Category" 
																			stringValue:@"Phone2"]]];
	}

	if ([[aWaypoint faxNumbers] count] > 0)
	{
		[self addExtensionElement:gpxxElements 
							 name:@"gpxx:PhoneNumber" 
					  stringValue:[[aWaypoint faxNumbers] objectAtIndex:0]  
						 children:nil 
					   attributes:[NSArray arrayWithObject:[NSXMLNode attributeWithName:@"Category" 
																			stringValue:@"Fax"]]];
	}

	if ([[aWaypoint emailAddresses] count] > 0)
	{
		[self addExtensionElement:gpxxElements 
							 name:@"gpxx:PhoneNumber" 
					  stringValue:[[aWaypoint emailAddresses] objectAtIndex:0]  
						 children:nil 
					   attributes:[NSArray arrayWithObject:[NSXMLNode attributeWithName:@"Category" 
																			stringValue:@"Email"]]];
	}
	
	// Handle address information
	NSMutableArray *gpxxAddressElements = [NSMutableArray array];
	[self addExtensionElement:gpxxAddressElements name:@"gpxx:StreetAddress" stringValue:[aWaypoint street] children:nil attributes:nil];
	[self addExtensionElement:gpxxAddressElements name:@"gpxx:City" stringValue:[aWaypoint city] children:nil attributes:nil];
	[self addExtensionElement:gpxxAddressElements name:@"gpxx:State" stringValue:[aWaypoint state] children:nil attributes:nil];
	[self addExtensionElement:gpxxAddressElements name:@"gpxx:Country" stringValue:[aWaypoint country] children:nil attributes:nil];
	[self addExtensionElement:gpxxAddressElements name:@"gpxx:PostalCode" stringValue:[aWaypoint zip] children:nil attributes:nil];
	if ([gpxxAddressElements count] > 0)
	{
		[self addExtensionElement:gpxxElements 
							 name:@"gpxx:Address" 
					  stringValue:nil 
						 children:gpxxAddressElements 
					   attributes:nil];
	}
	
	// Add extensions
	if ([gpxxElements count] > 0)
	{
		NSXMLNode *waypointExtensionNode = [NSXMLNode elementWithName:@"gpxx:WaypointExtension" 
															 children:gpxxElements 
														   attributes:nil];
		
		NSXMLNode *extensionNode = [NSXMLNode elementWithName:@"extensions" 
													 children:[NSArray arrayWithObject:waypointExtensionNode] 
												   attributes:nil];
		[children addObject:extensionNode];
	}
	
	for (GPXLink *link in [aWaypoint links])
	{
		[children addObject:[self linkElement:link]];
	}
	
	return [NSXMLNode elementWithName:@"wpt" children:children attributes:attributes];
}

- (NSXMLNode *)linkElement:(GPXLink*)aLink
{
	NSMutableArray *children = [NSMutableArray array];
	NSMutableArray *attributes = [NSMutableArray arrayWithObject:[NSXMLNode attributeWithName:@"href" 
																				  stringValue:[[aLink href] absoluteString]]];
	
	if (([aLink text] != nil) && ([[aLink text] length] > 0))
	{
		[children addObject:[NSXMLNode elementWithName:@"text" 
										   stringValue:[aLink text]]];
	}
	
	if (([aLink mimeType] != nil) && ([[aLink mimeType] length] > 0))
	{
		[children addObject:[NSXMLNode elementWithName:@"type" 
										   stringValue:[aLink mimeType]]];
	}
	
	return [NSXMLElement elementWithName:@"link" children:children attributes:attributes];
}

- (void)addExtensionElement:(NSMutableArray*)aElements 
					   name:(NSString*)aName 
				stringValue:(NSString*)aStringValue 
				   children:(NSArray*)aChildren 
				 attributes:(NSArray*)aAttributes
{
	if ((aStringValue != nil) && ([aStringValue length] > 0))
	{
		if ((aAttributes != nil) || (aChildren != nil))
		{
			NSXMLNode* node = [NSXMLNode elementWithName:aName 
												children:aChildren
											  attributes:aAttributes];
			[node setStringValue:aStringValue];
			[aElements addObject:node];
		}
		else
		{
			[aElements addObject:[NSXMLNode elementWithName:aName 
												stringValue:aStringValue]];
		}
	}
}

- (void)commentFromAddress:(GPXWaypoint*)aWaypoint
{
	NSMutableString *tmpString = [NSMutableString string];
	
	if (([aWaypoint street] != nil) && ([[aWaypoint street] length] > 0))
	{
		[tmpString appendString:[aWaypoint street]];
		
		if (([aWaypoint city] != nil) && ([[aWaypoint city] length] > 0))
		{
			[tmpString appendString:@"\n"];
			[tmpString appendString:[aWaypoint city]];
			
			if (([aWaypoint state] != nil) && ([[aWaypoint state] length] > 0))
			{
				[tmpString appendString:@", "];
				[tmpString appendString:[aWaypoint state]];
			}
		}
	}
	
	[cmt release];
	cmt = [[NSString stringWithString:tmpString] retain];
}

@end
