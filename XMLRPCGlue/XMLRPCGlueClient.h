//
//  XMRPCClientPrivate.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import <XMLRPCObjC/XMLRPCClient.h>

#import "XMLRPCGlueServer.h"

@class XMLRPCValue;

/*
 * does the actual method invocation. 
 */
@interface XMLRPCGlueClient : XMLRPCClient <XMLRPCShortCircuitMethodHandling>
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)args;
@end


