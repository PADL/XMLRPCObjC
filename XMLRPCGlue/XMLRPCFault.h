//
//  XMLRPCFault.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import "XMLRPCGluePrivate.h"

/*
 * An XMLRPC exception. Do not use this class directly,
 * instead use XMLRPCEnv.
 */
@interface XMLRPCFault : NSException {
@private
	xmlrpc_env mFault;
}

/*
 * Factory methods.
 */
+ (XMLRPCFault *)faultWithRpcEnv:(xmlrpc_env *)e;
+ (XMLRPCFault *)faultWithCode:(int)faultCode string:(NSString *)faultString;

/*
 * Designated initializers
 */
- initWithRpcEnv:(xmlrpc_env *)e;
- initWithCode:(int)faultCode string:(NSString *)faultString;

- (int)faultCode;
- (NSString *)faultString;
- (xmlrpc_env *)faultEnv;

@end

/*
 * Exception types.
 */
XMLRPC_EXPORT NSString *const XMLRPCInternalException;
XMLRPC_EXPORT NSString *const XMLRPCTypeException;
XMLRPC_EXPORT NSString *const XMLRPCIndexException;
XMLRPC_EXPORT NSString *const XMLRPCParseException;
XMLRPC_EXPORT NSString *const XMLRPCNetworkException;
XMLRPC_EXPORT NSString *const XMLRPCNoSuchMethodException;
XMLRPC_EXPORT NSString *const XMLRPCRequestRefusedException;
XMLRPC_EXPORT NSString *const XMLRPCIntrospectionDisabledException;
