//
//  XMLRPCData.m
//  XMLRPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCData

+ (XMLRPCData *)dataWithXMLRPCValue:(XMLRPCValue *)value
{
	return [[[self alloc] initWithXMLRPCValue:value] autorelease];
}

- initWithXMLRPCValue:(XMLRPCValue *)value
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	
	[super init];
	mValue = [value retain];
	xmlrpc_parse_value([env rpcEnv], [mValue borrowReference], "6", &mData, &mLength);
	[env raiseIfFaultOccurred];
	[env release];
	
	return self;
}

- (void)dealloc
{
	[mValue release];
	[super dealloc];
}

- (unsigned)length
{
	return mLength;
}

- (const void *)bytes
{
	return mData;
}

@end
