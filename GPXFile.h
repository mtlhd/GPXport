//
//  GPXFile.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-18.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPXError.h"
#import "GPXWaypoint.h"

@interface GPXFile : NSObject 
{
@protected
	NSString*		fileExtension;
	NSString*		fileFormatDescription;

@private
	NSMutableArray*	waypoints;
}

@property(readonly) NSArray* waypoints;

- (GPXError)addWaypoint:(GPXWaypoint *)aWaypoint;
- (GPXError)removeWaypoint:(GPXWaypoint *)aWaypoint;
- (GPXError)removeAllWaypoints;
- (GPXError)save:(NSString *)aFilename;
- (NSString*)addFileExtension:(NSString*)aFilename;

@end
