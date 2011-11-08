//
//  GPXGeoCodeClient.m
//  GPXport
//
//  Created by Henrik Söderqvist on 2009-02-03.
//  Copyright 2009-2011 metalhead. All rights reserved.
//

#import "GPXGeoCoder.h"
#import "GPXWaypoint.h"
#import "GPXError.h"


@implementation GPXGeoCoder

- (id) init
{
	self = [super init];
	
	if (self != nil) 
	{
		targetUrl = [[NSString stringWithString:@"http://maps.google.com/maps/geo?q=%@&output=xml&oe=utf8&sensor=false&key=your_api_key"] retain];
		xmlPath = [[NSString stringWithString:@"kml/Response/Placemark/Point/coordinates"] retain];
	}
	
	return self;
}

- (id)initWithClient:(NSObject<GPXGeoCodeClient>*)aClient
{
	[self init];
	
	if (self != nil) 
	{
		owner = aClient;
	}
	return self;
}

- (void)queryGeoCodeServerWithStreet:(NSString*)aStreet 
								city:(NSString*)aCity 
							   state:(NSString*)aState 
								 zip:(NSString*)aZip 
							 country:(NSString*)aCountry;
{
	NSString* urlString = [NSString stringWithFormat:
						   targetUrl,
						   [GPXGeoCoder convertStreet:aStreet 
												 city:aCity 
												state:aState 
												  zip:aZip 
											  country:aCountry]];
	//	DEBUG_PRINT(@"Request URL %@", urlString);
	
	NSURL* url = [NSURL URLWithString:urlString];
	
//	DEBUG_PRINT(@"Requested URL %@", [url absoluteString]);

	if (url == nil) 
	{
		NSError* err = [NSError errorWithDomain:@"GeoCoder" 
										   code:GPX_MALFORMED_URL 
									   userInfo:[NSDictionary dictionaryWithObject:urlString 
																			forKey:@"URL"]];
		[owner transferFailed:err];	
	}
		
	// Clear data
	[xmlData release];
	xmlData = [[NSMutableData alloc] init];
	
	NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url 
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
											timeoutInterval:30];
	(void)[NSURLConnection connectionWithRequest:urlRequest 
										delegate:self];
}

- (void)dealloc
{
	[xmlData release];
	[xmlPath release];
	[targetUrl release];
	
	[super dealloc];
}

+ (NSString*)convertStreet:(NSString*)aStreet 
					  city:(NSString*)aCity 
					 state:(NSString*)aState 
					   zip:(NSString*)aZip 
				   country:(NSString*)aCountry
{
	NSMutableArray* arguments = [NSMutableArray array];
	NSMutableString* qArg = [NSMutableString string];

	if (aStreet != nil) [arguments addObject:aStreet];
	if (aCity != nil) [arguments addObject:aCity];
	if (aState != nil) [arguments addObject:aState];
//	if (aZip != nil) [arguments addObject:aZip];
	if (aCountry != nil) [arguments addObject:aCountry];
	
	bool firstIteration = TRUE;
	for (NSString* str in arguments)
	{
		if (!firstIteration)
		{
			[qArg appendFormat:@",+"];
		}
		[qArg appendString:[GPXGeoCoder stripWhiteSpaces:str]];
		firstIteration = FALSE;
	}
	
	//DEBUG_PRINT(@"Converted address %@", qArg);
	
	// Make RFC 2396 string
	return (NSString*)[(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		  (CFStringRef)qArg, 
																		  NULL, 
																		  NULL, 
																		  kCFStringEncodingUTF8) autorelease];
}

+ (NSString*)stripWhiteSpaces:(NSString*)aString
{
	NSMutableString* result = [NSMutableString string];

	NSCharacterSet* WS = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSArray* components = [aString componentsSeparatedByCharactersInSet:WS];

	for (NSString* component in components)
	{
		if ((component != nil) && ([component length] > 0))
		{
			[result appendString:[component stringByTrimmingCharactersInSet:WS]];
			[result appendString:@"+"];
		}
	}
	
	return [result substringToIndex:([result length] - 1)];
}

- (NSCachedURLResponse*)connection:(NSURLConnection*)connection 
				 willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;	// No cache
}

- (void)connection:(NSURLConnection*)connection 
didReceiveResponse:(NSURLResponse*)response
{
	//DEBUG_PRINT(@"Geo coder received response");
	// Do nothing
}

- (void)connection:(NSURLConnection*)connection 
	didReceiveData:(NSData*)data
{
	//DEBUG_PRINT(@"Geo coder received data");
	[xmlData appendData:data];
}

- (NSURLRequest*)connection:(NSURLConnection*)connection 
			willSendRequest:(NSURLRequest*)request 
		   redirectResponse:(NSURLResponse*)redirectResponse
{
//	DEBUG_PRINT(@"Geo coder recieved redirect request");
	return request;
}

- (void)connection:(NSURLConnection*)connection 
  didFailWithError:(NSError*)error
{
	//DEBUG_PRINT(@"Geo coder connection failed with error %@", error);
	// Transfer error occured
	[owner transferFailed:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	//DEBUG_PRINT(@"Geo coder finished loading");
	// Transfer successful
	GPXWaypoint* waypoint = [[GPXWaypoint alloc] init];
	
	NSError* error;
	NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData:xmlData 
													 options:0 
													   error:&error];
	if (error != nil)
	{
		[owner transferFailed:error];
		return;
	}
	
	NSArray* itemNodes = [doc nodesForXPath:xmlPath 
									  error:&error];
	if (error != nil)
	{
		[owner transferFailed:error];
		return;
	}
	
	if ([itemNodes count] > 0)
	{
		NSXMLNode* xmlNode = [itemNodes objectAtIndex:0];
		
//		DEBUG_PRINT(@"Coordinates %@", [xmlNode stringValue]);

		NSArray* pos = [[xmlNode stringValue] componentsSeparatedByString:@","];

		if ([pos count] >= 2)
		{
//			DEBUG_PRINT(@"Longitude = %@    Latitude = %@", [pos objectAtIndex:0], [pos objectAtIndex:1]);
			[waypoint setLongitude:[(NSString*)[pos objectAtIndex:0] floatValue]];
			[waypoint setLatitude:[(NSString*)[pos objectAtIndex:1] floatValue]];
			[owner transferComplete:[waypoint autorelease]];
		}
	}
	else
	{
		[waypoint release];
		NSError* err = [NSError errorWithDomain:@"GeoCoder" 
										   code:GPX_NO_DATA_RECEIVED 
									   userInfo:[NSDictionary dictionaryWithObject:doc 
																			forKey:@"XML"]];
		[owner transferFailed:err];	
	}
}

@end
