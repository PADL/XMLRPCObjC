//
//  XMLRPCClientPrivate.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
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

- (id)invoke:(NSString *)method withArguments:(NSArray *)args
{
	id object;
	XMLRPCValue *value, *argFrame;

	/* whilst we're still build on xmlrpc-c, we should
	 * use the _invoke method to do the dirty work
	 */	
	argFrame = [[XMLRPCValue alloc] initWithArray:args];
	value = [self _invoke:method withArguments:argFrame];
	
	object = [value object];

	[value release];
	[argFrame release];

	return object;
}
@end

