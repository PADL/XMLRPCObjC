//
//  XMLRPCServerPrivate.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#include <xmlrpc.h>
#include <xmlrpc_client.h>

#import <XMLRPCObjC/XMLRPCObjC.h>

@class XMLRPCValue;

xmlrpc_value *_XMLRPCDefaultMethod(xmlrpc_env *env, char *host,
					  char *method_name, xmlrpc_value *param_array,
					  void *user_data);

XMLRPCValue *_XMLRPCInvokeObjCMethodShortCircuit(id obj, NSString *methodName, XMLRPCValue *args);

/*
 * This method MUST return a non-autoreleased object with a
 * retain count of 1.
 */
@protocol XMLRPCShortCircuitMethodHandling
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)args;
@end

@interface NSObject (XMLRPCShortCircuitMethodHandling) <XMLRPCShortCircuitMethodHandling>
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)args;
@end

@interface NSProxy (XMLRPCShortCircuitMethodHandling) <XMLRPCShortCircuitMethodHandling>
- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)args;
@end

@interface XMLRPCGlueServer : XMLRPCServer

@end
