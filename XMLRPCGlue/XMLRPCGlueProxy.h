//
//  XMLRPCProxyPrivate.h
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2000 PADL Software Pty Ltd. All rights reserved.
//

#import <XMLRPCObjC/XMLRPCProxy.h>

#import "XMLRPCGlueServer.h"

@interface XMLRPCGlueProxy : XMLRPCProxy <XMLRPCShortCircuitMethodHandling>
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)args;
@end

