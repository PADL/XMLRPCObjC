//
//  XMLRPCDictionary.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLRPCValue;

@interface XMLRPCDictionary : NSDictionary {
@private
	XMLRPCValue *mValue;
}

/*
 * Factory method.
 */
+ (XMLRPCDictionary *)dictionaryWithXMLRPCValue:(XMLRPCValue *)value;

/*
 * Designated initializer.
 */
- initWithXMLRPCValue:(XMLRPCValue *)value;

- (unsigned)count;
- (NSEnumerator *)keyEnumerator;
- (id)objectForKey:(id)aKey;
- (XMLRPCValue *)value;

@end
