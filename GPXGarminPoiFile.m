//
//  GPXGarminPoiFile.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-18.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXGarminPoiFile.h"

// TODO: Refactor and create as plugin, this is to be the example plugin

@interface GPXGarminPoiFile (Private)

- (NSData*)poiData;

@end


@implementation GPXGarminPoiFile

- (id) init
{
	self = [super init];
	
	if (self != nil) 
	{
		fileExtension = @".csv";
		fileFormatDescription = @"Garmin POI File";
	}
	
	return self;
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
													 contents:[self poiData] 
												   attributes:nil])
		{
			DEBUG_PRINT(@"GPXport: Error writing to file %@", filename);
			err = GPX_GENERAL_ERROR;
		}
	}
	
	return err;
}

- (NSData*)poiData
{
	NSMutableData *data = [[NSMutableData alloc] init];
	
	for (GPXWaypoint *wpt in [self waypoints])
	{
		[data appendData:[[NSString stringWithFormat:@"%.6f,%.6f,\"%@\",\"\n", 
						   [wpt longitude], 
						   [wpt latitude], 
						   [wpt name]] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	return [data autorelease];
}

@end
