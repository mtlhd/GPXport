//
//  GPXGpxXmlDocument.h
//  LatLongFinder
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009 Helsinki Heavy Metal Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GPXGpxXmlDocument : NSObject {
	GPXGpxXmlMetadata	*metadata;	// [0..1]
	NSMutableArray		*waypoints;	// [0..*]

// Not yet implemented
//	NSMutableArray		*routes;	// [0..*]
//	NSMutableArray		*tracks;	// [0..*]
//	GPXGpxXmlExtension	*extension;	// [0..1]
}

@end
