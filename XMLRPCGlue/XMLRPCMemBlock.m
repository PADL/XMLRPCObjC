//
//  XMLRPCMemBlock.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCMemBlock : NSData {
	xmlrpc_mem_block *mBlock;
}

- (xmlrpc_mem_block *)xmlRpcMemBlock
{
	return mBlock;
}

- init
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	xmlrpc_mem_block *b = xmlrpc_mem_block_new([env rpcEnv], 0);

	[env raiseIfFaultOccurred];
	[env release];
	
	return [self initWithMemBlock:b];
}

- initWithMemBlock:(xmlrpc_mem_block *)block
{
	[super init];
	mBlock = block;
	return self;
}

- (unsigned)length
{
	return xmlrpc_mem_block_size(mBlock);
}

- (const void *)bytes
{
	return xmlrpc_mem_block_contents(mBlock);
}

- (void)dealloc
{
	xmlrpc_mem_block_free(mBlock);
	[super dealloc];
}

@end
