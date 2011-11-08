//
//  GPXGoogleMaps.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-12.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXGoogleMaps.h"


@implementation GPXGoogleMaps

- (id) init
{
	self = [super init];
	
	if (self != nil) 
	{
		// Initiated by [super init]
		[targetUrl release];
		[xmlPath release];
		
		targetUrl = [[NSString stringWithString:@"http://maps.google.se/maps?q=%@&output=kml&oe=utf8"] retain];
		xmlPath = [[NSString stringWithString:@"kml/Placemark/Point/coordinates"] retain];
	}
	
	return self;
}

@end
