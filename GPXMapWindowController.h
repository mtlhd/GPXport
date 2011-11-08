//
//  GPXMapWindowController.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GPXMapWindowController : NSWindowController {
	IBOutlet NSImageView			*mapView;
	IBOutlet NSProgressIndicator	*mapLoadingIndicator;
	IBOutlet NSTextField			*mapProgress;
	IBOutlet NSButton				*nextButton;
	IBOutlet NSButton				*prevButton;
	IBOutlet NSButton				*closeButton;
}

//- (IBAction)nextButtonClick:(id)sender;
//- (IBAction)prevButtonClick:(id)sender;
//- (IBAction)closeButtonClick:(id)sender;

@end
