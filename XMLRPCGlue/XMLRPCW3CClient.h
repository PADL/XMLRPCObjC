//
//  XMLRPCW3CClient.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLRPCW3CClient : XMLRPCGlueClient
{
	xmlrpc_server_info *mServerInfo;
}
@end

