//
//  GPXExportProgressDialogController.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPXGeoCodeClient.h"

@class ABRecord;
@class GPXWaypoint;
@class GPXGoogleMaps;
@class GPXFile;


@interface GPXExportProgressPanelController : NSWindowController <GPXGeoCodeClient>
{
@public
	IBOutlet NSProgressIndicator*	progressIndicator;
	IBOutlet NSTextField*			progressLabel;
	IBOutlet NSButton*				cancelButton;
	IBOutlet NSPanel*				progressPanel;
	IBOutlet NSWindow*				parentWindow;
	
@private
	NSMutableArray*					addressBook;
	NSMutableArray*					records;
	NSString*						filename;
	BOOL							cancelExport;
	GPXGoogleMaps*					geoCoder;
	GPXFile*						gpxFile;
	BOOL							includeWork;
	BOOL							includeHome;
	BOOL							includeOther;
	double							progressBarValue;
	double							progressBarMaxValue;
	
	NSMutableDictionary*			waypointCache;
	
	NSObject*						parentObject;
}

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)showPanel:(id)sender;

- (void)hidePanel;

- (void)setRecords:(NSMutableArray *)aRecords;
- (void)setFilename:(NSString *)aFilename;
- (void)setExportFilterWork:(BOOL)work home:(BOOL)home other:(BOOL)other;

@end
