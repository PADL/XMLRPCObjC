//
//  XMLRPCNSHTTPClient.h
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/* a nice private Foundation class */
@class NSHTTPConnection;

@interface XMLRPCNSHTTPClient : XMLRPCClient <XMLRPCShortCircuitMethodHandling>
{
	NSHTTPConnection *mConnection;
}
@end
