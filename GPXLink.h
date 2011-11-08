//
//  GPXLink.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPXError.h"

@interface GPXLink : NSObject 
{
	NSURL	*href;			// URL of hyperlink.
	
	NSString	*text;		// Text of hyperlink.
	NSString	*mimeType;	// Mime type of content (image/jpeg)
}

@property(readwrite, copy) NSString *text;
@property(readwrite, copy) NSString *mimeType;

- (GPXError)setHref:(NSURL*)href;
- (NSURL*)href;

@end
