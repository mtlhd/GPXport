//
//  GPXMainWindowController.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-01-29.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/ABPeoplePickerView.h>

#import "GPXExportProgressPanelController.h"
#import "GPXSavePanelExtensionController.h"


@interface GPXMain : NSObject {
	IBOutlet NSButton*							exportButton;
	IBOutlet NSMenuItem*						exportMenuItem;
	IBOutlet NSButton*							viewMapButton;
	IBOutlet ABPeoplePickerView*				peoplePickerView;
	IBOutlet GPXExportProgressPanelController*	exportProgressPanelController;
	
@private
	NSMutableArray*						records;
	GPXSavePanelExtensionController*	savePanelExtension;
}

- (IBAction)clickExportButton:(id)sender;
- (IBAction)clickViewMapButton:(id)sender;

- (void)exportCompleted;

- (void)savePanelDidEnd:(NSSavePanel*)sheet returnCode:(int)returnCode  contextInfo:(void*)contextInfo;
- (void)showExportPanel:(NSString*)aFilename;
- (void)windowWillClose:(NSNotification*)aNotification;

@end
