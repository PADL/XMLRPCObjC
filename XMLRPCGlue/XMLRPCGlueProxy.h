//
//  XMLRPCProxyPrivate.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import <XMLRPCObjC/XMLRPCProxy.h>

#import "XMLRPCGlueServer.h"

@interface XMLRPCGlueProxy : XMLRPCProxy <XMLRPCShortCircuitMethodHandling>
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)args;
@end

