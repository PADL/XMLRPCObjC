//
//  XMLRPCArray.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCArray
+ (XMLRPCArray *)arrayWithXMLRPCValue:(XMLRPCValue *)value
{
	return [[[self alloc] initWithXMLRPCValue:value] autorelease];
}

- initWithXMLRPCValue:(XMLRPCValue *)value
{
	[super init];
	mValue = [value retain];
	return self;
}

- (void)dealloc
{
	[mValue release];
	[super dealloc];
}

- (unsigned)count
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	size_t result = xmlrpc_array_size([env rpcEnv], [mValue borrowReference]);

	[env raiseIfFaultOccurred];
	[env release];
	
	return result;
}

- (id)objectAtIndex:(unsigned)index
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	XMLRPCValue *tmp;
	id obj;

	xmlrpc_value *result = xmlrpc_array_get_item([env rpcEnv], [mValue borrowReference], index);
	[env raiseIfFaultOccurred];
	[env release];

	tmp = [[XMLRPCValue alloc] initWithRpcValue:result];
	obj = [tmp object];
	[tmp release];

	return obj;		
}

@end
