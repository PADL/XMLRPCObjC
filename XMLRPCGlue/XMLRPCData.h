//
//  XMLRPCData.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLRPCValue;

@interface XMLRPCData : NSData {
@private
	XMLRPCValue *mValue;
	char *mData;
	size_t mLength;
}

/*
 * Factory methods.
 */
+ (XMLRPCData *)dataWithXMLRPCValue:(XMLRPCValue *)value;

/*
 * Designated initializers
 */
- initWithXMLRPCValue:(XMLRPCValue *)value;

/*
 * Length of data
 */
- (unsigned)length;

/*
 * Contents of data
 */
- (const void *)bytes;

@end
