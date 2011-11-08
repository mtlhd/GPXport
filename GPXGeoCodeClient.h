/*
 *  GPXGeoCodeClient.h
 *  GPXport
 *
 *  Created by Henrik Söderqvist on 2009-02-07.
 *  Copyright 2009-2011 metalhead. All rights reserved.
 *
 */

@class NSError;
@class GPXWaypoint;

@protocol GPXGeoCodeClient

- (void)transferComplete:(GPXWaypoint *)aWaypoint;
- (void)transferFailed:(NSError *)aError;

@end
