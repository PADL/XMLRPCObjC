//
//  XMLRPCArray.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import <Foundation/Foundation.h>

@class XMLRPCValue;

@interface XMLRPCArray : NSArray {
@private
	XMLRPCValue *mValue;
}

/*
 * Create an autoreleased array with an XMLRPC
 * value.
 */
+ (XMLRPCArray *)arrayWithXMLRPCValue:(XMLRPCValue *)value;

/*
 * Initialize with an XMLRPC value.
 */
- initWithXMLRPCValue:(XMLRPCValue *)value;

/*
 * Returns the number of elements in the array.
 */
- (unsigned)count;

/*
 * Returns an object at a specified index.
 */
- (id)objectAtIndex:(unsigned)index;

@end
