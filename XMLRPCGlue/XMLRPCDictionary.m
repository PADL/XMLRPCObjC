//
//  XMLRPCDictionary.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@interface XMLRPCDictionaryKeyEnumerator : NSEnumerator {
@private
	XMLRPCDictionary *mStructValue;
	int mIndex;
	int mSize;
}
+ (XMLRPCDictionaryKeyEnumerator *)enumeratorWithXMLRPCDictionary:(XMLRPCDictionary *)sv;
- initWithXMLRPCDictionary:(XMLRPCDictionary *)sv;
- (id)nextObject;
@end

@implementation XMLRPCDictionary

+ (XMLRPCDictionary *)dictionaryWithXMLRPCValue:(XMLRPCValue *)value
{
	return [[[self alloc] initWithXMLRPCValue:value] autorelease];
}

- initWithXMLRPCValue:(XMLRPCValue *)value
{
	[super init];
	mValue = [value retain];
	return self;
}

- (void)dealloc
{
	[mValue release];
	[super dealloc];
}

- (XMLRPCValue *)value
{
	return mValue;
}

- (unsigned)count
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	size_t result = xmlrpc_struct_size([env rpcEnv], [mValue borrowReference]);

	[env raiseIfFaultOccurred];
	[env release];
	
	return result;
}

- (NSEnumerator *)keyEnumerator
{
	return [XMLRPCDictionaryKeyEnumerator enumeratorWithXMLRPCDictionary:self];
}

- (id)objectForKey:(id)aKey
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	XMLRPCValue *tmp;
	id obj;
	NSString *keyNSString = [aKey description];
	const char *keystr = [keyNSString cString];
	size_t keylen = [keyNSString cStringLength];
	xmlrpc_value *result = xmlrpc_struct_get_value_n([env rpcEnv], [mValue borrowReference], (char *)keystr, keylen);
	
	if ([env hasFaultOccurred] && [env faultCode] == XMLRPC_INDEX_ERROR) {
		[env release];
		return nil;
	}
	
	[env raiseIfFaultOccurred];
	[env release];

	tmp = [[XMLRPCValue alloc] initWithRpcValue:result];
	obj = [tmp object];
	[tmp release];

	return obj;	
}

@end

@implementation XMLRPCDictionaryKeyEnumerator
+ (XMLRPCDictionaryKeyEnumerator *)enumeratorWithXMLRPCDictionary:(XMLRPCDictionary *)sv
{
	return [[[self alloc] initWithXMLRPCDictionary:sv] autorelease];
}

- initWithXMLRPCDictionary:(XMLRPCDictionary *)sv
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	
	[super init];

	mSize = xmlrpc_struct_size([env rpcEnv], [[sv value] borrowReference]);

	[env raiseIfFaultOccurred];
	[env release];
	
	mIndex = 0;
	
	mStructValue = [sv retain];
		
	return self;
}

- (void)dealloc
{
	[mStructValue release];
	[super dealloc];
}

- (id)nextObject
{
	XMLRPCEnv *env;
	XMLRPCValue *tmp;
	xmlrpc_value *key, *value;
	xmlrpc_value *dict;
	id obj;
	
	if (mIndex >= mSize) {
		return nil;
	}
	
	env = [[XMLRPCEnv alloc] init];
	dict = [[mStructValue value] borrowReference];
	
	xmlrpc_struct_get_key_and_value([env rpcEnv], dict, mIndex, &key, &value);

	[env raiseIfFaultOccurred];
	[env release];

	tmp = [[XMLRPCValue alloc] initWithRpcValue:key];
	obj = [tmp object];
	[tmp release];	
	
	++mIndex;
	
	return obj;
}
@end

