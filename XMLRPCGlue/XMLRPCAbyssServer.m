//
//  XMLRPCAbyssServer.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCAbyssServer

- init
{
	id ret;
	NSMutableDictionary *d = [[NSMutableDictionary alloc] init];

	[d setObject:@"abyss.conf" forKey:XMLRPCAbyssServerConfigurationKey];
	ret = [self initWithConfiguration:d];
	[d release];

	return ret;
}

- initWithConfiguration:(NSDictionary *)config
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	xmlrpc_registry *registry;
	const char *configFile;

	configFile = [[config objectForKey:XMLRPCAbyssServerConfigurationKey] cString];
	if (configFile == NULL) {
		[NSException raise:NSInvalidArgumentException format:@"No value for XMLRPCAbyssServerConfigurationKey in configuration dictionary"];
		return nil;
	}

	[super initWithConfiguration:config];

	xmlrpc_server_abyss_init(XMLRPC_SERVER_ABYSS_NO_FLAGS, (char *)configFile);

	registry = xmlrpc_server_abyss_registry();
	xmlrpc_registry_set_default_method([env rpcEnv], registry, NULL, _XMLRPCDefaultMethod, self);

	[env raiseIfFaultOccurred];
	
	return self;
}

- (void)run
{
	xmlrpc_server_abyss_run();
}

@end


