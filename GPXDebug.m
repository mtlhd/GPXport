//
//  GPXDebug.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-03-20.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXDebug.h"

#define USE_NSLOG

@interface GPXDebug (Private)

+ (NSInteger)currentThreadNumber;

@end

@implementation GPXDebug

+ (NSInteger)currentThreadNumber
{
    NSString*	threadString;
    NSRange		numRange;
    NSUInteger	numLength;
	
	// NSThread descritption returns something like <NSThread: 0x1234567>{name = (null), num = 1}
	// Get the part after "num = "
    threadString = [NSString stringWithFormat:@"%@", [NSThread currentThread]];
    numRange = [threadString rangeOfString:@"num = "];
    numLength = [threadString length] - numRange.location - numRange.length;
    numRange.location = numRange.location + numRange.length;
    numRange.length   = numLength - 1;
    threadString = [threadString substringWithRange:numRange];
    return [threadString integerValue];
}

+ (void)log:(char*)aFile line:(int)aLineNumber format:(NSString*)format, ...;
{
    va_list		listOfArguments;
    NSString*	formattedString;
    NSString*	sourceFile;
    NSString*	logString;
	
    va_start(listOfArguments, format);
    formattedString = [[NSString alloc] initWithFormat:format
                                             arguments:listOfArguments];
    va_end(listOfArguments);
	
    sourceFile = [[NSString alloc] initWithBytes:aFile
                                          length:strlen(aFile)
                                        encoding:NSUTF8StringEncoding];
	
    if ([[NSThread currentThread] name] == nil)
    {
        // The thread has no name, try to find the threadnumber instead.
        logString = [NSString stringWithFormat:@"Thread %d | %s[%d] %@",
					 [self currentThreadNumber],
					 [[sourceFile lastPathComponent] UTF8String],
					 aLineNumber,
					 formattedString];
    }
    else
    {
        logString = [NSString stringWithFormat:@"%@ | %s[%d] %@",
					 [[NSThread currentThread] name],
					 [[sourceFile lastPathComponent] UTF8String],
					 aLineNumber,
					 formattedString];
    }
	
#ifdef  USE_NSLOG
    NSLog(@"%@", logString);
#else
    printf("%s\n", [logString UTF8String]);
#endif /* USE_NSLOG */
	
    [formattedString release];
    [sourceFile release];
}

@end 