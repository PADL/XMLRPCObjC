//
//  XMLRPCMemBlock.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import <Foundation/Foundation.h>

#import "XMLRPCGlue.h"

@interface XMLRPCMemBlock : NSData {
	xmlrpc_mem_block *mBlock;
}

- initWithMemBlock:(xmlrpc_mem_block *)block;
- (unsigned)length;
- (const void *)bytes;
- (xmlrpc_mem_block *)xmlRpcMemBlock;

@end
