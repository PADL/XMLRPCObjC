//
//  XMLRPCGlueProxy.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Wed Feb 14 2001.
//  Copyright (c) 2000 __CompanyName__. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCGlueProxy
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

- (XMLRPCValue *)_invoke:(NSString *)methodName withArguments:(XMLRPCValue *)args
{
	return [mClient _invoke:methodName withArguments:args];
}
@end
