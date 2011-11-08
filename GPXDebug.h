//
//  GPXDebug.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-03-20.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define GPXLog(s, ...) [GPXDebug log:__FILE__ line:__LINE__ format:(s), ##__VA_ARGS__]

@interface GPXDebug : NSObject

+ (void)log:(char*)aFile line:(int)aLineNumber format:(NSString*)format, ...;
	
@end
