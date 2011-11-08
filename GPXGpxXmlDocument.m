//
//  GPXGpxXmlDocument.m
//  LatLongFinder
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009 Helsinki Heavy Metal Ltd. All rights reserved.
//

#import "GPXGpxXmlDocument.h"


@implementation GPXGpxXmlDocument

- (id)init
{
	NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"gpx"];
	
	if (root != nil)
	{
		self = [super initWithRootElement:root];
		
		if (self != nil) {
			NSXMLNode *attribute;
			
			attribute = [NSXMLNode elementWithName:@"version"];
			[attribute setStringValue:@"1.1"];
			[root addAttribute:attribute];
			
			attribute = [NSXMLNode elementWithName:@"creator"];
			[attribute setStringValue:@"GPXport"];
			[root addAttribute:attribute];
			
			waypoints = [[NSMutableArray alloc] init];
		}
	}

	return self;
}

- (void) dealloc
{
	[waypoints release];
	
	[super dealloc];
}


#pragma mark Meta Data
//metadata
//<name> xsd:string </name> [0..1] ?
//<desc> xsd:string </desc> [0..1] ?
//<author> personType </author> [0..1] ?
//<copyright> copyrightType </copyright> [0..1] ?
//<link> linkType </link> [0..*] ?
//<time> xsd:dateTime </time> [0..1] ?
//<keywords> xsd:string </keywords> [0..1] ?
//<bounds> boundsType </bounds> [0..1] ?
//<extensions> extensionsType </extensions> [0..1] ?

//<xsd:complexType name="metadataType">
//<xsd:sequence>
//<-- elements must appear in this order -->
//<xsd:element name="name" type="xsd:string" minOccurs="0"/>
//<xsd:element name="desc" type="xsd:string" minOccurs="0"/>
//<xsd:element name="author" type="personType" minOccurs="0"/>
//<xsd:element name="copyright" type="copyrightType" minOccurs="0"/>
//<xsd:element name="link" type="linkType" minOccurs="0" maxOccurs="unbounded"/>
//<xsd:element name="time" type="xsd:dateTime" minOccurs="0"/>
//<xsd:element name="keywords" type="xsd:string" minOccurs="0"/>
//<xsd:element name="bounds" type="boundsType" minOccurs="0"/>
//<xsd:element name="extensions" type="extensionsType" minOccurs="0"/>
//</xsd:sequence>
//</xsd:complexType>

#pragma mark Waypoint



@end
