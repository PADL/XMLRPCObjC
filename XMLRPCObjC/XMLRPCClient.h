//
//  XMLRPCClient.h
//  XMLRPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XMLRPCObjC/XMLRPCServer.h>

@class XMLRPCProxy, XMLRPCValue;

/*
 * Classes that implement this can be automatically
 * converted into an XMLRPC dictionary (struct) for
 * transporting on the wire.
 */
@protocol XMLRPCKeyValueCoding
- (NSArray *)keysForXMLRPCCoding;
@end

/*
 * A client handle. This is an abstract class;
 * calling a factory method will instantiate a
 * concrete subclass. 
 */
@interface XMLRPCClient : NSObject <XMLRPCMethodHandling> {
	NSDictionary *mUserInfo;
	NSURL *mURL;
	void *mReserved;
}

/*
 * Client factory methods.
 */
+ (XMLRPCClient *)client:(NSURL *)url userInfo:(NSDictionary *)dict;
+ (XMLRPCClient *)client:(NSURL *)url;
+ (XMLRPCClient *)client:(NSString *)host port:(unsigned)port;

/*  
 * Designated initializers; don't call these,
 * call the factory methods.
 */
- initWithURL:(NSURL *)url userInfo:(NSDictionary *)dict;
- initWithURL:(NSURL *)url; 
- initWithHost:(NSHost *)host port:(unsigned)port;

/*
 * this is the method used by clients to invoke an XML-RPC
 * method. I borrowed the idea from the Java bindings to
 * actually make this the same method that objects can
 * implement for server-side handling of arbitary methods.
 * This means that you can do something like:
 *
 *  XMLRPCClient *client = [XMLRPCClient client:@"localhost" port:[NSNumber
 *		numberWithInt:8000]];
 *	XMLRPCServer *server = [XMLRPCServer server];
 *  [server addObject:client forKey:@"someMethodPrefix"];
 *  [server run];
 *
 * and you have a quick and dirty proxy server. (Note that
 * the server uses private API to avoid unmarshalling and
 * marshalling the arguments and return value when an
 * instance of this class is registered with a server.)
 */
- (id)invoke:(NSString *)method withArguments:(NSArray *)args;

/*
 * Return a proxy object for this session. 
 * Forwards method invocations to the remote
 * XMLRPC server.
 */
- (XMLRPCProxy *)rootProxy;

/*
 * Returns a proxy object. 
 *
 *   XMLRPCProxy *p = [client proxyForTarget:@"foo"];
 *   [p doSomething];
 *
 * will call the method foo.doSomething.
 */
- (XMLRPCProxy *)proxyForTarget:(NSString *)name;

@end

/*
 * userInfo keys. These are only used by the
 * W3C client at the moment.
 */
XMLRPC_EXPORT NSString *const XMLRPCClientBasicAuthUsernameKey;
XMLRPC_EXPORT NSString *const XMLRPCClientBasicAuthPasswordKey;
XMLRPC_EXPORT NSString *const XMLRPCClientApplicationNameKey;
XMLRPC_EXPORT NSString *const XMLRPCClientApplicationVersionKey;

