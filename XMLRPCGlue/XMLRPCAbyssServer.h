//
//  XMLRPCAbyssServer.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import <XMLRPCGlue/XMLRPCGlueServer.h>

/*
 * Server using the builtin Abyss web server.
 */
@interface XMLRPCAbyssServer : XMLRPCGlueServer {
}
@end

XMLRPC_EXPORT NSString *const XMLRPCAbyssServerConfigurationKey;
