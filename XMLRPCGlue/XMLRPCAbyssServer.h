//
//  XMLRPCAbyssServer.h
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <XMLRPCGlue/XMLRPCGlueServer.h>

/*
 * Server using the builtin Abyss web server.
 */
@interface XMLRPCAbyssServer : XMLRPCGlueServer {
}
@end

XMLRPC_EXPORT NSString *const XMLRPCAbyssServerConfigurationKey;
