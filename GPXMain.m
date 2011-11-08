//
//  GPXMainWindowController.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-01-29.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXMain.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABGlobals.h>
#import <AddressBook/ABGroup.h>
#import <AddressBook/ABRecord.h>

#import "GPXExportProgressPanelController.h"


@implementation GPXMain

- (id) init
{
	self = [super init];
	
	if (self != nil) 
	{
		records = [[NSMutableArray alloc] init];
		savePanelExtension = [[GPXSavePanelExtensionController alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	[records release];
	[savePanelExtension release];
	
	[super dealloc];
}

- (IBAction)clickExportButton:(id)sender
{
	NSString*		defaultFilename = NSLocalizedString(@"Address book", @"Address book label, used for default filename");
	NSArray*		groups = [peoplePickerView selectedGroups];
	[records removeAllObjects];	// Reset list of records
	
	// Disable export button and export menu item
	[exportButton setEnabled:FALSE];
	[exportMenuItem setEnabled:FALSE];

	if (([groups count] > 0) && ([[peoplePickerView selectedRecords] count] == 0))
	{
		// Get records from group members
		for (ABGroup *group in groups)
		{
			[records addObjectsFromArray:[group members]];
		}
	}
	else if ([[peoplePickerView selectedRecords] count] > 0)
	{
		// Use directly selected records
		[records addObjectsFromArray:[peoplePickerView selectedRecords]];
	}
	else
	{
		// User has not selected any records, assume entire addressbook is selected.
		ABAddressBook* addressbook = [ABAddressBook sharedAddressBook];
		[records addObjectsFromArray:[addressbook people]];
	}
	
//	DEBUG_PRINT(@"%d records selected in %d groups", [records count], [groups count]);
	
	// Try to use selected group as default filename, suggested name might be more appropriate.
	@try 
	{
		if ([groups count] == 1) 
		{
			ABGroup* group = [groups objectAtIndex:0];
			NSString* groupName = [group valueForProperty:kABGroupNameProperty];	// nil value will throw exception
			if ((groupName != nil) &&
				([groupName length] > 0))
			{
				defaultFilename = groupName;
			}
		}
	}
	@catch (NSException * e) 
	{
		DEBUG_PRINT(@"Exception %@", e);
	}
	@finally 
	{
		// Finally, don't do anything, just keep the old default filename.
	}
	
	// Add file extension.
	NSString* filename = [defaultFilename stringByAppendingString:@".gpx"]; 
	
	NSSavePanel* savePanel = [NSSavePanel savePanel];
	NSArray* fileTypes = [NSArray arrayWithObjects:@"gpx", @"csv", nil];
	[savePanel setAllowedFileTypes:fileTypes];
	[savePanel setAccessoryView:[savePanelExtension view]];
	[savePanel beginSheetForDirectory:NSHomeDirectory() 
								 file:filename 
					   modalForWindow:[NSApp mainWindow] 
						modalDelegate:self 
					   didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) 
						  contextInfo:nil];
}
	 
- (void)savePanelDidEnd:(NSSavePanel*)sheet returnCode:(int)returnCode  contextInfo:(void*)contextInfo
{
	NSString* pickedFilename = [sheet filename];
	[sheet orderOut:nil];

	if (returnCode == NSOKButton)
	{
		[self performSelector:@selector(showExportPanel:) withObject:pickedFilename afterDelay:0.01];
	}
	else
	{
		[self exportCompleted];
	}
}

- (void)showExportPanel:(NSString*)aFilename
{
	[exportProgressPanelController setExportFilterWork:[savePanelExtension includeWork] 
												  home:[savePanelExtension includeHome] 
												 other:[savePanelExtension includeOther]];
	[exportProgressPanelController setRecords:records];
	[exportProgressPanelController setFilename:aFilename];
	[exportProgressPanelController showPanel:self];
}

- (void)windowWillClose:(NSNotification*)aNotification 
{
	[NSApp terminate:self];
}

- (IBAction)clickViewMapButton:(id)sender
{
}

- (void)exportCompleted
{
	[exportButton setEnabled:TRUE];
	[exportMenuItem setEnabled:TRUE];
}

- (void)geoCodeLookupResult
{
}

// Make sheets appear where address book picker view seems to have it's upper edge.
- (NSRect)window:(NSWindow*)window willPositionSheet:(NSWindow*)sheet usingRect:(NSRect)rect 
{
    NSRect fieldRect = [peoplePickerView frame];
    fieldRect.size.height = ((-2) * fieldRect.size.height) + 76;
	
    return fieldRect;	
}

@end
