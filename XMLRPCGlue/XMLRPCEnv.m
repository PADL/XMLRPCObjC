//
//  XMLRPCEnv.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@interface XMLRPCEnv (Private)
- (void)raiseMe;
@end

@implementation XMLRPCEnv

+ (XMLRPCEnv *)env
{
	return [[[self alloc] init] autorelease];
}

- (void)dealloc
{
	xmlrpc_env_clean(&mEnv);
	[super dealloc];
}

- init
{
	[super init];
	
	xmlrpc_env_init(&mEnv);
	
	return self;
}

- (BOOL)hasFaultOccurred
{
	return mEnv.fault_occurred;
}

- (XMLRPCFault *)fault
{
	return [XMLRPCFault faultWithRpcEnv:&mEnv];
}

- (void)raiseIfFaultOccurred
{
	if ([self hasFaultOccurred])
		[self raiseMe];
}

- (xmlrpc_env *)rpcEnv
{
	return &mEnv;
}

- (int)faultCode
{
	return mEnv.fault_code;
}

@end

@implementation XMLRPCEnv (Private)
- (void)raiseMe
{
	return [[self fault] raise];
}
@end
