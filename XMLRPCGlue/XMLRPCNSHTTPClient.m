//
//  XMLRPCNSHTTPClient.m
//  XMLRPCObjC
//
//  Created by lukeh on Mon Feb 12 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCPrivate.h"
#import "NSHTTPConnection.h"

@implementation XMLRPCNSHTTPClient
- initWithURL:(NSURL *)url userInfo:(NSDictionary *)info
{
	NSNumber *urlPort;
	int port;

	[super initWithURL:url userInfo:info];

	urlPort = [mURL port];
	port = (urlPort == nil) ? 80 : [urlPort intValue];	

	mConnection = [[NSHTTPConnection alloc]
		initWithHost:[NSHost hostWithName:[mURL host]]
		port:port];
	
	return self;
}

- (void)dealloc
{
	[mConnection release];
	[super dealloc];
}

- (XMLRPCValue *)_invoke:(NSString *)method withArguments:(XMLRPCValue *)argFrame
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	xmlrpc_value *result;
	XMLRPCValue *value;
	NSHTTPRequest *request;
	XMLRPCMemBlock *serializedParams;
	NSData *response;
	id responseHeaders;
	xmlrpc_mem_block *block;
	
	serializedParams = [[XMLRPCMemBlock alloc] init];
	block = [serializedParams xmlRpcMemBlock];	
	xmlrpc_serialize_call([env rpcEnv], block, (char *)[method cString], [argFrame borrowReference]);
	[env raiseIfFaultOccurred];

	request = [[NSHTTPRequest alloc] initWithMethod:@"POST" URL:mURL];
	[request setData:serializedParams];
	[request addHeader:@"User-Agent" value:@"XMLRPCObjC/1.0 (Mac OS X)"];
	[request addHeader:@"Host" value:[[NSHost currentHost] name]];
	[request addHeader:@"Content-Type" value:@"text/xml"];
	[request addHeader:@"Content-Length" value:[NSString stringWithFormat:@"%u", [serializedParams length]]];

	response = [mConnection sendRequestSynchronously:request headers:&responseHeaders];
	if (response == nil) {
		[[XMLRPCFault faultWithCode:XMLRPC_NETWORK_ERROR
			string:@"-[XMLRPCNSHTTPClient _invoke:withArguments:]"] raise];
	}
	
	result = xmlrpc_parse_response([env rpcEnv], (char *)[response bytes], [response length]);
	[env raiseIfFaultOccurred];
	
	value = [[XMLRPCValue alloc] initWithRpcValue:result behaviour:XMLRPCConsumeReference];

	[serializedParams release];
	[request release];
	[env release];
	
	return value;
}

@end
