//
//  GPXGeoCodeClient.h
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-03.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPXGeoCodeClient.h"


@interface GPXGeoCoder : NSObject 
{
@private
	NSObject<GPXGeoCodeClient>	*owner;
	NSMutableData				*xmlData;
@protected
	NSString					*targetUrl;
	NSString					*xmlPath;
}

- (id)initWithClient:(NSObject<GPXGeoCodeClient> *)aClient;
- (void)queryGeoCodeServerWithStreet:(NSString *)aStreet city:(NSString *)aCity state:(NSString *)aState zip:(NSString *)aZip country:(NSString *)aCountry;

+ (NSString *)convertStreet:(NSString *)aStreet city:(NSString *)aCity state:(NSString *)aState zip:(NSString *)aZip country:(NSString *)aCountry;
+ (NSString *)stripWhiteSpaces:(NSString *)aString;

@end
