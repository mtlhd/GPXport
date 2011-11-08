//
//  GPXGpxXmlWaypoint.m
//  LatLongFinder
//
//  Created by Henrik Söderqvist on 2009-02-06.
//  Copyright 2009 Helsinki Heavy Metal Ltd. All rights reserved.
//

#import "GPXGpxXmlWaypoint.h"


@implementation GPXGpxXmlWaypoint

- (id)init
{
	self = [super initWithKind:NSXMLElementKind];
	
	if (self != nil) {
		[self setName:@"wpt"];
	}
	
	return self;
}

- (void)setLatitude(double aLatitude)
{
	[self set
}

XML Instance Representation
//<...
//lat="latitudeType [1] ?"
//lon="longitudeType [1] ?">
//<ele> xsd:decimal </ele> [0..1] ?
//<time> xsd:dateTime </time> [0..1] ?
//<magvar> degreesType </magvar> [0..1] ?
//<geoidheight> xsd:decimal </geoidheight> [0..1] ?
//<name> xsd:string </name> [0..1] ?
//<cmt> xsd:string </cmt> [0..1] ?
//<desc> xsd:string </desc> [0..1] ?
//<src> xsd:string </src> [0..1] ?
//<link> linkType </link> [0..*] ?
//<sym> xsd:string </sym> [0..1] ?
//<type> xsd:string </type> [0..1] ?
//<fix> fixType </fix> [0..1] ?
//<sat> xsd:nonNegativeInteger </sat> [0..1] ?
//<hdop> xsd:decimal </hdop> [0..1] ?
//<vdop> xsd:decimal </vdop> [0..1] ?
//<pdop> xsd:decimal </pdop> [0..1] ?
//<ageofdgpsdata> xsd:decimal </ageofdgpsdata> [0..1] ?
//<dgpsid> dgpsStationType </dgpsid> [0..1] ?
//<extensions> extensionsType </extensions> [0..1] ?
//</...>

//Schema Component Representation
//<xsd:complexType name="wptType">
//	<xsd:sequence>
//		<-- elements must appear in this order -->
//		<-- Position info -->
//		<xsd:element name="ele" type="xsd:decimal" minOccurs="0"/>
//		<xsd:element name="time" type="xsd:dateTime" minOccurs="0"/>
//		<xsd:element name="magvar" type="degreesType" minOccurs="0"/>
//		<xsd:element name="geoidheight" type="xsd:decimal" minOccurs="0"/>
//		<-- Description info -->
//		<xsd:element name="name" type="xsd:string" minOccurs="0"/>
//		<xsd:element name="cmt" type="xsd:string" minOccurs="0"/>
//		<xsd:element name="desc" type="xsd:string" minOccurs="0"/>
//		<xsd:element name="src" type="xsd:string" minOccurs="0"/>
//		<xsd:element name="link" type="linkType" minOccurs="0" maxOccurs="unbounded"/>
//		<xsd:element name="sym" type="xsd:string" minOccurs="0"/>
//		<xsd:element name="type" type="xsd:string" minOccurs="0"/>
//		<-- Accuracy info -->
//		<xsd:element name="fix" type="fixType" minOccurs="0"/>
//		<xsd:element name="sat" type="xsd:nonNegativeInteger" minOccurs="0"/>
//		<xsd:element name="hdop" type="xsd:decimal" minOccurs="0"/>
//		<xsd:element name="vdop" type="xsd:decimal" minOccurs="0"/>
//		<xsd:element name="pdop" type="xsd:decimal" minOccurs="0"/>
//		<xsd:element name="ageofdgpsdata" type="xsd:decimal" minOccurs="0"/>
//		<xsd:element name="dgpsid" type="dgpsStationType" minOccurs="0"/>
//		<xsd:element name="extensions" type="extensionsType" minOccurs="0"/>
//	</xsd:sequence>
//	<xsd:attribute name="lat" type="latitudeType" use="required"/>
//	<xsd:attribute name="lon" type="longitudeType" use="required"/>
//</xsd:complexType>

@end
