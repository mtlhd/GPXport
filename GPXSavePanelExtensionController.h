//
//  GPXAddressFilter.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-19.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GPXSavePanelExtensionController : NSViewController {
	IBOutlet NSButton*	includeWorkCheckBox;
	IBOutlet NSButton*	includeHomeCheckBox;
	IBOutlet NSButton*	includeOtherCheckBox;
}

- (IBAction)settingsChanged:(id)sender;

- (void)setExportFilterWork:(BOOL)work home:(BOOL)home other:(BOOL)other;

- (BOOL)includeWork;
- (BOOL)includeHome;
- (BOOL)includeOther;

@end
