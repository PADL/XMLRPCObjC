//
//  XMLRPCMethodSignature.h
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *_XMLRPCMakeMethodName(NSString *distantObject, SEL selector);
const char *_XMLRPCTypeFromObjCType(const char *objCType);
const char *_XMLRPCObjCTypeFromRpcType(const char *xmlType);

@interface NSMethodSignature (XMLRPCMethodSignature)
/*
 * Return a method signature as used by the
 * xmlrpc-c library for this NSMethodSignature.
 */
- (NSString *)XMLRPCSignature;

/*
 * Create an NSMethodSignature with an array of
 * XML types, as returned by the xmlrpc-c registry.
 */
+ (NSMethodSignature *)signatureWithXMLRPCTypes:(NSArray *)types;
@end
