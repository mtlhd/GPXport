#import <Cocoa/Cocoa.h>

@interface GPXPreferencesWindowController : NSWindowController 
{
    IBOutlet NSPopUpButton	*outputFormatPopUpButton;
    IBOutlet NSButton		*playSoundCheckBox;
    IBOutlet NSPopUpButton	*soundTypePopUpButton;
}

- (IBAction)outputFormatPopUpButtonChanged:(id)sender;
- (IBAction)playSoundCheckBoxChanged:(id)sender;
- (IBAction)soundTypePopUpButtonChanged:(id)sender;

@end
