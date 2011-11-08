//
//  GPXFile.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-18.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXFile.h"

@implementation GPXFile

@synthesize waypoints;

- (id)init
{
	self = [super init];
	
	if (self != nil) 
	{
		waypoints = [[NSMutableArray alloc] init];
		fileExtension = nil;
		fileFormatDescription = nil;
	}
	
	return self;
}

- (void)dealloc
{
	[waypoints release];
	[fileExtension release];
	
	[super dealloc];
}

- (GPXError)addWaypoint:(GPXWaypoint *)aWaypoint
{
	NSUInteger pos = [waypoints indexOfObject:aWaypoint];
	
	if (pos != NSNotFound)
	{
		[waypoints removeObjectAtIndex:pos];
		return GPX_DUPLICATE_NOT_ALLOWED;
	}
	
	[waypoints addObject:aWaypoint];
	return GPX_OK;
}

- (GPXError)removeWaypoint:(GPXWaypoint *)aWaypoint
{
	NSUInteger pos = [waypoints indexOfObject:aWaypoint];
	
	if (pos != NSNotFound)
	{
		[waypoints removeObjectAtIndex:pos];
		return GPX_OK;
	}
	
	return GPX_NOT_FOUND;
}

- (GPXError)removeAllWaypoints
{
	[waypoints removeAllObjects];
	return GPX_OK;
}

- (GPXError)save:(NSString *)aFilename
{
	NSAssert1(FALSE, @"Not implemented!", nil);
	return GPX_GENERAL_ERROR;
}

- (NSString*)addFileExtension:(NSString*)aFilename
{
	if ([aFilename hasSuffix:fileExtension])
	{
		return [NSString stringWithString:aFilename];
	}
	else
	{
		return [aFilename stringByAppendingString:fileExtension];
	}
}

- (NSString*)fileExtension
{
	return fileExtension;
}

@end
