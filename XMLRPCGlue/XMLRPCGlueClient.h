//
//  XMRPCClientPrivate.h
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
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

