//
//  XMLRPCMemBlock.h
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
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
