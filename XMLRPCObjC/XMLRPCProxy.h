//
//  XMLRPCProxy.h
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMLRPCServer.h"

@class XMLRPCClient;

XMLRPC_EXPORT void _XMLRPCObjCValueFromObject(NSObjCValue *val, id obj);

/*
 * This proxy class allows a remote XMLRPC service
 * to be accessed as if it were a local Objective-C
 * object.
 */

@interface XMLRPCProxy : NSProxy {
	XMLRPCClient *mClient;
	NSString *mTarget;
	Protocol *mProtocol;
	void *mReserved;
}

/*
 * Factory method. target is the method prefix (can
 * be nil)
 */
+ (XMLRPCProxy *)proxyWithTarget:(NSString *)target client:(XMLRPCClient *)client;

/*
 * Designated initializer. target is the method prefix
 * (can be nil).
 */
- initWithTarget:(NSString *)target client:(XMLRPCClient *)client;

/*
 * Create a proxy with a target concatenated with
 * the current target, a period, and the supplied
 * argument. Retains the current proxy's protocol.
 */
- (XMLRPCProxy *)proxyForTarget:(NSString *)name;

/*
 * If you don't have a method registry, or you want
 * to avoid an extra round trip, set the protocol for
 * this proxy.
 */
- (void)setProtocolForProxy:(Protocol *)proto;

/*
 * Accessor for XMLRPCClient instance variable.
 */
- (XMLRPCClient *)clientForProxy;

@end

