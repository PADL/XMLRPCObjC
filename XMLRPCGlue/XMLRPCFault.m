//
//  XMLRPCFault.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

static NSString *XMLRPCError2ExceptionName(int code);

static NSString *XMLRPCError2ExceptionName(int code)
{
	switch (code) {
		case XMLRPC_INTERNAL_ERROR:
			return XMLRPCInternalException;
		case XMLRPC_TYPE_ERROR:
			return XMLRPCTypeException;
		case XMLRPC_INDEX_ERROR:
			return XMLRPCIndexException;
		case XMLRPC_PARSE_ERROR:
			return XMLRPCParseException;
		case XMLRPC_NETWORK_ERROR:
			return XMLRPCNetworkException;
		case XMLRPC_NO_SUCH_METHOD_ERROR:
			return XMLRPCNoSuchMethodException;
		case XMLRPC_REQUEST_REFUSED_ERROR:
			return XMLRPCRequestRefusedException;
		case XMLRPC_INTROSPECTION_DISABLED_ERROR:
			return XMLRPCIntrospectionDisabledException;
		default:
			break;
	}
	
	return [NSString stringWithFormat:@"Unknown fault %d", code];
}

@implementation XMLRPCFault
+ (XMLRPCFault *)faultWithRpcEnv:(xmlrpc_env *)env
{
	return [[[self alloc] initWithRpcEnv:env] autorelease];
}

+ (XMLRPCFault *)faultWithCode:(int)faultCode string:(NSString *)faultString
{
	return [[[self alloc] initWithCode:faultCode string:faultString] autorelease];
}

- (id)initWithName:(NSString *)aName reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo
{
	int faultCode;
	
	[super initWithName:aName reason:aReason userInfo:aUserInfo];
		
	if ([aName isEqualToString:XMLRPCInternalException])
		faultCode = XMLRPC_INTERNAL_ERROR;
	else if ([aName isEqualToString:XMLRPCTypeException])
		faultCode = XMLRPC_TYPE_ERROR;
	else if ([aName isEqualToString:XMLRPCIndexException])
		faultCode = XMLRPC_INDEX_ERROR;
	else if ([aName isEqualToString:XMLRPCParseException])
		faultCode = XMLRPC_PARSE_ERROR;
	else if ([aName isEqualToString:XMLRPCNetworkException])
		faultCode = XMLRPC_NETWORK_ERROR;
	else if ([aName isEqualToString:XMLRPCNoSuchMethodException])
		faultCode = XMLRPC_NO_SUCH_METHOD_ERROR;
	else if ([aName isEqualToString:XMLRPCRequestRefusedException])
		faultCode = XMLRPC_REQUEST_REFUSED_ERROR;
	else if ([aName isEqualToString:XMLRPCIntrospectionDisabledException])
		faultCode = XMLRPC_INTROSPECTION_DISABLED_ERROR;
	else
		faultCode = XMLRPC_INTERNAL_ERROR;

	xmlrpc_env_init(&mFault);		
	xmlrpc_env_set_fault(&mFault, faultCode, (char *)[aReason cString]);

	return self;
}

- (XMLRPCFault *)initWithRpcEnv:(xmlrpc_env *)env
{	
	if (env->fault_string == NULL) {
		[[XMLRPCFault faultWithCode:XMLRPC_INTERNAL_ERROR string:@"Tried to create empty fault"] raise];
	}

	[super initWithName:XMLRPCError2ExceptionName(env->fault_code) reason:[NSString stringWithCString:env->fault_string] userInfo:nil];
		
	xmlrpc_env_init(&mFault);
	xmlrpc_env_set_fault(&mFault, env->fault_code, env->fault_string);
	
	return self;
}

- (XMLRPCFault *)initWithCode:(int)faultCode string:(NSString *)faultString
{
	[super initWithName:XMLRPCError2ExceptionName(faultCode) reason:faultString userInfo:nil];
	
	xmlrpc_env_init(&mFault);
	xmlrpc_env_set_fault(&mFault, faultCode, (char *)[faultString cString]);
	
	return self;
}

- (int)faultCode
{
	return mFault.fault_code;
}

- (NSString *)faultString
{
	XMLRPC_ASSERT(mFault.fault_occurred);
	return [NSString stringWithCString:mFault.fault_string];
}

- (xmlrpc_env *)faultEnv
{
	return &mFault;
}

@end

#undef XMLRPC_EXPORT
#define XMLRPC_EXPORT

XMLRPC_EXPORT NSString *const XMLRPCInternalException = @"XMLRPCInternalException";
XMLRPC_EXPORT NSString *const XMLRPCTypeException = @"XMLRPCTypeException";
XMLRPC_EXPORT NSString *const XMLRPCIndexException = @"XMLRPCIndexException";
XMLRPC_EXPORT NSString *const XMLRPCParseException = @"XMLRPCParseException";
XMLRPC_EXPORT NSString *const XMLRPCNetworkException = @"XMLRPCNetworkException";
XMLRPC_EXPORT NSString *const XMLRPCNoSuchMethodException = @"XMLRPCNoSuchMethodException";
XMLRPC_EXPORT NSString *const XMLRPCRequestRefusedException = @"XMLRPCRequestRefusedException";
XMLRPC_EXPORT NSString *const XMLRPCIntrospectionDisabledException = @"XMLRPCIntrospectionDisabledException";
