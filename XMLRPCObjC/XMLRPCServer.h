//
//  XMLRPCServer.h
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XMLRPC_EXPORT extern

/*
 * Deliver an NSInvocation to an arbitary object for
 * the XML-RPC method methodName and argument array
 * args. See below for a description of the mapping
 * of method names.
 */
XMLRPC_EXPORT id XMLRPCInvokeObjCMethod(id obj, NSString *methodName, NSArray *args);

/*
 * Implement this protocol if you want your object to
 * handle an arbitary method. Useful for proxies.
 * We provide a default implementation for NSObject
 * and NSProxy as a category, and special cased
 * implementations for XMLRPCClient and XMLRPCProxy.
 */
@protocol XMLRPCMethodHandling <NSObject>
- (id)invoke:(NSString *)methodName withArguments:(NSArray *)args;
@end

/*
 * We implement XMLRPCMethodHandling on NSObject by using
 * introspection (creating an NSInvocation object for
 * the method). Additionally, if the method contains 
 * periods beyond the target specifier, then we use
 * NSKeyValueCoding to trace a path. So, a method call
 * of:
 *
 *	someObject.coffeeMachine.makeCoffee
 *
 * would translate to:
 *
 *	id someObject = ... // retrieved from XMLRPCServer
 *	id tmp = [someObject coffeeMachine];
 *	return [tmp makeCoffee];
 */

@interface NSObject (XMLRPCMethodHandling) <XMLRPCMethodHandling>
- (id)invoke:(NSString *)methodName withArguments:(NSArray *)args;
@end

@interface NSProxy (XMLRPCMethodHandling) <XMLRPCMethodHandling>
- (id)invoke:(NSString *)methodName withArguments:(NSArray *)args;
@end

/*
 * Abstract class for XML-RPC servers.
 */
@interface XMLRPCServer : NSObject {
	NSMutableDictionary *mObjectCache;
	NSDictionary *mConfig;
	BOOL mAutoCreate;
	void *mReserved;
}

/*
 * Factory methods
 */
+ (XMLRPCServer *)server;
+ (XMLRPCServer *)serverWithConfiguration:(NSDictionary *)configDict;

/*
 * Designated initializer.
 */
- initWithConfiguration:(NSDictionary *)configDict;

/*
 * Run the server; never returns. No support
 * for runloops just yet.
 */
- (void)run;

/*
 * check in an object for a particular target
 */
- (void)setObject:(id)object forKey:(NSString *)target;
- (void)removeObjectForKey:(id)aKey;

/*
 * retrieve an object for a particular target
 */
- (id)objectForKey:(NSString *)target;

/*
 * create objects where target == a class name automatically
 */
- (void)setObjectAutoCreation:(BOOL)yorn;
- (BOOL)willAutoCreateObjects;

@end

XMLRPC_EXPORT NSString *const XMLRPCAbyssServerConfigurationKey;

