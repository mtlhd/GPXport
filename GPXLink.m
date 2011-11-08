//
//  GPXLink.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXLink.h"


@implementation GPXLink

@synthesize text;
@synthesize mimeType;

- (id)init
{
	self = [super init];
	
	if (self != nil) 
	{
		href = nil;
		text = nil;
		mimeType = nil;
	}
	
	return self;
}

- (void)dealloc
{
	[href release];
	[text release];
	[mimeType release];

	[super dealloc];
}

- (GPXError)setHref:(NSURL *)aHref
{
	if ((aHref == nil) || ([[aHref absoluteString] length] == 0))
	{
		return GPX_BAD_ARGUMENT;
	}
	
	[href release];
	href = [aHref copy];
	
	return GPX_OK;
}

- (NSURL *)href
{
	return href;
}

@end
