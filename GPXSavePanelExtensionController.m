//
//  GPXAddressFilter.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-19.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXSavePanelExtensionController.h"


@implementation GPXSavePanelExtensionController

- (id)init
{
	self = [super initWithNibName:@"GPXSavePanelExtension"
						   bundle:[NSBundle mainBundle]];
	
	if (self != nil) 
	{
		[self setExportFilterWork:TRUE 
							 home:TRUE 
							other:TRUE];
		[self loadView];
	}
	
	return self;
}

- (IBAction)settingsChanged:(id)sender
{
	if (([self includeWork] | 
		 [self includeHome] | 
		 [self includeOther]) == FALSE)
	{
		NSButton* lastChangedCheckBox = (NSButton*)sender;
		[lastChangedCheckBox setState:NSOnState];
	}
}

- (void)setExportFilterWork:(BOOL)work home:(BOOL)home other:(BOOL)other
{
	NSAssert((work | home | other) != FALSE, @"At least one checkbox has to be selected");
	[includeWorkCheckBox setState:(work ? NSOnState : NSOffState)];
	[includeHomeCheckBox setState:(home ? NSOnState : NSOffState)];
	[includeOtherCheckBox setState:(other ? NSOnState : NSOffState)];
}

- (BOOL)includeWork
{
	return ([includeWorkCheckBox state] == NSOnState);
}

- (BOOL)includeHome
{
	return ([includeHomeCheckBox state] == NSOnState);
}

- (BOOL)includeOther
{
	return ([includeOtherCheckBox state] == NSOnState);
}

@end
