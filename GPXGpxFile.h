//
//  GPXFile.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPXFile.h"

@class GPXLink;

@interface GPXGpxFile : GPXFile 
{
@public
//	GPXMetadata*	metadata;
//	GPXExtension*	extension;
	
@private
//	NSMutableArray*	routes;
//	NSMutableArray*	tracks;
	NSString*		cmt;	// Waypoint comment
}

@end
