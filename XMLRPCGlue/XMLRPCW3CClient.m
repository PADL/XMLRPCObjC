//
//  XMLRPCW3CClient.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCW3CClient

- initWithURL:(NSURL *)url userInfo:(NSDictionary *)info
{	
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	char *appname, *version;
	char *username, *password;
	
	[super initWithURL:url userInfo:info];

	appname = (char *)[[mUserInfo objectForKey:XMLRPCClientApplicationNameKey] cString];
	if (appname == NULL) {
		[NSException raise:NSInvalidArgumentException format:@"userInfo must contain value for XMLRPCClientApplicationNameKey"];
	}
	
	version = (char *)[[mUserInfo objectForKey:XMLRPCClientApplicationVersionKey] cString];
	if (version == NULL) {
		[NSException raise:NSInvalidArgumentException format:@"userInfo must contain value for XMLRPCClientApplicationVersionKey"];
	}
		
	xmlrpc_client_init(XMLRPC_CLIENT_NO_FLAGS, appname, version);

	mServerInfo = xmlrpc_server_info_new([env rpcEnv], (char *)[[mURL description] cString]);
	[env raiseIfFaultOccurred];

	username = (char *)[[mUserInfo objectForKey:XMLRPCClientBasicAuthUsernameKey] cString];
	password = (char *)[[mUserInfo objectForKey:XMLRPCClientBasicAuthPasswordKey] cString];

	if (username != NULL && password != NULL) {
		xmlrpc_server_info_set_basic_auth([env rpcEnv], mServerInfo, username, password);
		[env raiseIfFaultOccurred];
	}
	
	[env release];

	return self;
}

- (void)dealloc
{
	xmlrpc_client_cleanup();
	xmlrpc_server_info_free(mServerInfo);
	[super dealloc];
}

- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)argFrame
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	xmlrpc_value *result;
	XMLRPCValue *value;
	
	result = xmlrpc_client_call_server_params([env rpcEnv],
				mServerInfo,
				(char *)[method cString],
				[argFrame borrowReference]);
	
	[env raiseIfFaultOccurred];
	[env release];
	
	value = [[XMLRPCValue alloc] initWithRpcValue:result behaviour:XMLRPCConsumeReference];

	return value;
}
@end

