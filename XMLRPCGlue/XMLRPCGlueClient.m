//
//  XMLRPCClientPrivate.m
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCGlueClient
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)argFrame
{
	[NSException raise:NSGenericException format:@"Not a concrete subclass of XMLRPCGlueClient"];
	return nil;
}
@end

