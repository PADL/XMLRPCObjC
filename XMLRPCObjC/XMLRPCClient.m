//
//  XMLRPCClient.m
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import "XMLRPCPrivate.h"

static Class _defaultClass = NULL;

@implementation XMLRPCClient
+ (void)initialize
{
	/* for the moment use the W3C client 
	 * it bloats the framework like something huge but
	 * it seems to work better than Apple's
	 */
	_defaultClass = [XMLRPCW3CClient class];
}

+ (XMLRPCClient *)client:(NSURL *)url userInfo:(NSDictionary *)info
{
	return [[[_defaultClass alloc] initWithURL:url userInfo:info] autorelease];
}

+ (XMLRPCClient *)client:(NSURL *)url
{
	return [[[_defaultClass alloc] initWithURL:url] autorelease];
}

+ (XMLRPCClient *)client:(NSString *)host port:(unsigned)port
{
	return [[[_defaultClass alloc] initWithHost:[NSHost hostWithName:host] port:port] autorelease];
}

- initWithURL:(NSURL *)url userInfo:(NSDictionary *)info
{	
	if (url == nil) {
		[NSException raise:NSInvalidArgumentException
			format:@"XMLRPCClient must be initialized with a valid URL"];
	}
	
	[super init];

	if (info == nil) {
		info = [NSDictionary dictionary];
	}
	
	mURL = [url retain];
	mUserInfo = [info retain];
	
	return self;
}

- initWithHost:(NSHost *)host port:(unsigned)port
{
	NSURL *url;
	
	url = [[NSURL alloc] initWithScheme:@"http" host:[NSString stringWithFormat:@"%@:%d",
		host, port] path:@"/RPC2"];
	
	[self initWithURL:url];
	[url release];
	
	return self;
}

- initWithURL:(NSURL *)url
{
	NSMutableDictionary *d;
	
	d = [[NSMutableDictionary alloc] init];
	[d setObject:[[NSProcessInfo processInfo] processName] forKey:XMLRPCClientApplicationNameKey];
	[d setObject:@"1" forKey:XMLRPCClientApplicationVersionKey];
	
	self = [self initWithURL:url userInfo:d];
	[d release];
	
	return self;
}

- init
{
	return [self initWithHost:[NSHost currentHost] port:80];
}

- (void)dealloc
{
	[mUserInfo release];
	[mURL release];
	[super dealloc];	
}

- (id)invoke:(NSString *)method withArguments:(NSArray *)args
{
	[NSException raise:NSGenericException format:@"not a concrete subclass of XMLRPCClient"];
	
	return nil;
}

- (XMLRPCProxy *)rootProxy
{
	return [XMLRPCProxy proxyWithTarget:nil client:self];
}

- (XMLRPCProxy *)proxyForTarget:(NSString *)name
{
	return [XMLRPCProxy proxyWithTarget:name client:self];
}

@end

#undef XMLRPC_EXPORT
#define XMLRPC_EXPORT

XMLRPC_EXPORT NSString *const XMLRPCClientBasicAuthUsernameKey = @"XMLRPCClientBasicAuthUsernameKey";
XMLRPC_EXPORT NSString *const XMLRPCClientBasicAuthPasswordKey = @"XMLRPCClientBasicAuthPasswordKey";
XMLRPC_EXPORT NSString *const XMLRPCClientApplicationNameKey = @"XMLRPCClientApplicationNameKey";
XMLRPC_EXPORT NSString *const XMLRPCClientApplicationVersionKey = @"XMLRPCClientApplicationVersionKey";

