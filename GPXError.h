/*
 *  GPXError.h
 *  GPXport
 *
 *  Created by Henrik Söderqvist on 2009-02-06.
 *  Copyright 2009-2011 metalhead. All rights reserved.
 *
 */

typedef enum errors {
	GPX_OK = 0,
	GPX_BAD_ARGUMENT,
	GPX_NOT_FOUND,
	GPX_DUPLICATE_NOT_ALLOWED, 
	GPX_GENERAL_ERROR
} GPXError;


// GPXGeoCoder
#define GPX_MALFORMED_URL		11
#define GPX_NO_DATA_RECEIVED	12

