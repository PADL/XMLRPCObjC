//
//  XMLRPCEnv.h
//  XMLRPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLRPCFault;

/*
 * This class is used as an error context (a la CORBA)
 * for XMLRPC client library calls. Pass [env rpcEnv]
 * to xmlrpc-c functions, and always call
 * [env raiseIfFaultOccurred] after invoking a client
 * library function. This will raise a subclass of
 * NSException.
 */
@interface XMLRPCEnv : NSObject {
@private
	xmlrpc_env mEnv;
}

+ (XMLRPCEnv *)env;
- init;
- (int)faultCode;
- (BOOL)hasFaultOccurred;
- (XMLRPCFault *)fault;
- (void)raiseIfFaultOccurred;
- (xmlrpc_env *)rpcEnv;

@end

