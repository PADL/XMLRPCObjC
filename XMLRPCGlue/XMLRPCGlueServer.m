//
//  XMLRPCServerPrivate.m
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

/* proxy function for forwarding methods */
xmlrpc_value *_XMLRPCDefaultMethod(xmlrpc_env *env,
			char *host,
			char *method_name,
			xmlrpc_value *param_array,
			void *user_data)
{
	XMLRPCValue *argFrame, *retVal;
	char *p;
	id <XMLRPCShortCircuitMethodHandling> obj;
	XMLRPCServer *server = (XMLRPCServer *)user_data;
	xmlrpc_value *rpcRet;
		
	p = strchr(method_name, '.');
	if (p == NULL) {
		xmlrpc_env_set_fault(env, XMLRPC_NO_SUCH_METHOD_ERROR,
			"XML-RPC method names for Objective-C objects must contain at least one period");
		return NULL;
	}

	*p = '\0';
	
	argFrame = [[XMLRPCValue alloc] initWithRpcValue:param_array];

	/* the first argument is the class / cache key */
	obj = [server objectForKey:[NSString stringWithCString:method_name]];
	*p = '.';
	
	if (obj == nil) {
		xmlrpc_env_set_fault(env, XMLRPC_REQUEST_REFUSED_ERROR, "Could not create object");
		[argFrame release];
		return NULL;
	}
		
	retVal = [obj _invoke:[NSString stringWithCString:method_name] withArguments:argFrame];
	rpcRet = [retVal makeReference];
	
	[argFrame release];
	[retVal release];

	return rpcRet;
}

XMLRPCValue *_XMLRPCInvokeObjCMethodShortCircuit(id obj, NSString *method, XMLRPCValue *argFrame)
{
	XMLRPCValue *retVal;
	NSArray *arguments;
	id retObject;
	
	arguments = [argFrame arrayValue];
	retObject = [obj invoke:method withArguments:arguments];
	retVal = [[XMLRPCValue alloc] initWithObject:retObject];
	
	return retVal;
}

@implementation NSObject (XMLRPCShortCircuitMethodHandling)
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)argFrame
{
	return _XMLRPCInvokeObjCMethodShortCircuit(self, method, argFrame);
}
@end

@implementation NSProxy (XMLRPCShortCircuitMethodHandling)
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)argFrame
{
	return _XMLRPCInvokeObjCMethodShortCircuit(self, method, argFrame);
}
@end

@implementation XMLRPCGlueServer

@end

