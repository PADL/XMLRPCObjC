//
//  XMLRPCValue.m
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGluePrivate.h"

@implementation XMLRPCValue
+ (XMLRPCValue *)value
{
	return [[[self alloc] init] autorelease];
}

+ (XMLRPCValue *)valueWithRpcValue:(xmlrpc_value *)value
{
	return [[[self alloc] initWithRpcValue:value] autorelease];
}

+ (XMLRPCValue *)valueWithRpcValue:(xmlrpc_value *)value behaviour:(enum XMLRPCReferenceBehaviour)behaviour
{
	return [[[self alloc] initWithRpcValue:value behaviour:behaviour] autorelease];
}

+ (XMLRPCValue *)valueWithObject:(id)object
{
	return [[[self alloc] initWithObject:object] autorelease];
}

+ (XMLRPCValue *)valueWithNumber:(NSNumber *)number
{
	return [[[self alloc] initWithNumber:number] autorelease];
}

+ (XMLRPCValue *)valueWithDate:(NSDate *)date
{
	return [[[self alloc] initWithDate:date] autorelease];
}

+ (XMLRPCValue *)valueWithString:(NSString *)string
{
	return [[[self alloc] initWithString:string] autorelease];
}

+ (XMLRPCValue *)valueWithArray:(NSArray *)array
{
	return [[[self alloc] initWithArray:array] autorelease];
}

+ (XMLRPCValue *)valueWithData:(NSData *)data
{
	return [[[self alloc] initWithData:data] autorelease];
}

+ (XMLRPCValue *)valueWithDictionary:(NSDictionary *)dict
{
	return [[[self alloc] initWithDictionary:dict] autorelease];
}

+ (XMLRPCValue *)valueWithObjCValue:(NSObjCValue *)value
{
	return [[[self alloc] initWithObjCValue:value] autorelease];
}

- init
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	id obj;
	xmlrpc_value *v = xmlrpc_build_value([env rpcEnv], "b", (xmlrpc_bool)0);

	[env raiseIfFaultOccurred];
	[env release];

	obj = [self initWithRpcValue:v];
	
	return obj;
}

- initWithRpcValue:(xmlrpc_value *)value
{
	return [self initWithRpcValue:value behaviour:XMLRPCMakeReference];
}

- initWithRpcValue:(xmlrpc_value *)value behaviour:(enum XMLRPCReferenceBehaviour)behaviour
{
	mValue = value;
	
	[super init];
	
	if (behaviour == XMLRPCMakeReference)
		xmlrpc_INCREF(value);
		
	return self;
}

- (void)dealloc
{
	if (mValue != NULL) {
		xmlrpc_DECREF(mValue);
	}
	[super dealloc];
}

- (xmlrpc_type)type
{
	return xmlrpc_value_type(mValue);
}

- (xmlrpc_value *)makeReference
{
	xmlrpc_INCREF(mValue);
	return mValue;
}

- (xmlrpc_value *)borrowReference
{
	return mValue;
}

- initWithObject:(id)object
{
	if (object == nil || [object isKindOfClass:[NSNull class]]) {
		[self release];
		return nil;
	} else if ([object isKindOfClass:[NSNumber class]]) {
		return [self initWithNumber:(NSNumber *)object];
	} else if ([object isKindOfClass:[NSDate class]]) {
		return [self initWithDate:(NSDate *)object];
	} else if ([object isKindOfClass:[NSString class]]) {
		return [self initWithString:(NSString *)object];
	} else if ([object isKindOfClass:[NSArray class]]) {
		return [self initWithArray:(NSArray *)object];
	} else if ([object isKindOfClass:[NSData class]]) {
		return [self initWithData:(NSData *)object];
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		return [self initWithDictionary:(NSDictionary *)object];
	} else if ([object conformsToProtocol:@protocol(XMLRPCKeyValueCoding)]) {
		/* try key value coding */
		XMLRPCValue *v;
		NSMutableDictionary *d;
		NSArray *keys;

		keys = [(id <XMLRPCKeyValueCoding>)object keysForXMLRPCCoding];
		d = [[NSMutableDictionary alloc] init];
		[d setObject:NSStringFromClass([object class]) forKey:@"NSObjectClass"];
		[d addEntriesFromDictionary:[object valuesForKeys:keys]];
		v = [self initWithDictionary:d];
		[d release];

		return v;
	}

	[NSException raise:NSInvalidArgumentException format:
		@"Cannot convert Objective-C object of class %@ to XML-RPC value",
		NSStringFromClass([object class])];

	[self release];
	return nil;
}

- initWithNumber:(NSNumber *)number
{
	XMLRPCEnv *env;
	xmlrpc_value *value;

	if (number == nil) {
		[self release];
		return nil;
	}

	env = [[XMLRPCEnv alloc] init];

	switch (*[number objCType]) {
		case NSObjCCharType - 32:
		case NSObjCCharType: {
			char charValue = [number charValue];
			value = xmlrpc_build_value([env rpcEnv], "i", (xmlrpc_int32)charValue);
			break;
		}
		case NSObjCShortType - 32:
		case NSObjCShortType: {
			short shortValue = [number shortValue];
			value = xmlrpc_build_value([env rpcEnv], "i", (xmlrpc_int32)shortValue);
			break;
		}
		case NSObjCLongType - 32:
		case NSObjCLongType: {
			long longValue = [number longValue];
			value = xmlrpc_build_value([env rpcEnv], "i", (xmlrpc_int32)longValue);
			break;
		}
		case NSObjCLonglongType - 32:
		case NSObjCLonglongType: {
			long long longLongValue = [number longLongValue];
			value = xmlrpc_build_value([env rpcEnv], "i", (xmlrpc_int32)longLongValue);
			break;
		}
		case NSObjCFloatType - 32:
		case NSObjCFloatType: {
			float floatValue = [number floatValue];
			value = xmlrpc_build_value([env rpcEnv], "d", (double)floatValue);
			break;
		}
		case NSObjCDoubleType - 32:
		case NSObjCDoubleType: {
			double doubleValue = [number doubleValue];
			value = xmlrpc_build_value([env rpcEnv], "d", doubleValue);
			break;
		}
		default:
			[NSException raise:NSInvalidArgumentException
				format:@"Cannot convert Objective-C type %s to XML-RPC value", [number objCType]];
			value = NULL;
			break;
	}

	[env raiseIfFaultOccurred];
	[env release];
	
	return [self initWithRpcValue:value behaviour:XMLRPCConsumeReference];
}

- initWithString:(NSString *)string
{
	XMLRPCEnv *env;
	xmlrpc_value *value;
	const char *data;

	if (string == nil) {
		[self release];
		return nil;
	}

	env = [[XMLRPCEnv alloc] init];
	data = [string cString];
	
	value = xmlrpc_build_value([env rpcEnv], "s", data);
	
	[env raiseIfFaultOccurred];
	[env release];
	
	return [self initWithRpcValue:value behaviour:XMLRPCConsumeReference];
}

- initWithDate:(NSDate *)date
{
	[self release];
	return nil;
}

- initWithArray:(NSArray *)array
{
	XMLRPCEnv *env;
	xmlrpc_value *value;
	NSEnumerator *e;
	id obj;

	if (array == nil) {
		[self release];
		return nil;
	}

	env = [[XMLRPCEnv alloc] init];	
	value = xmlrpc_build_value([env rpcEnv], "()");

	e = [array objectEnumerator];
	while ((obj = [e nextObject]) != nil) {
		XMLRPCValue *tmp;

		tmp = [[XMLRPCValue alloc] initWithObject:obj];
		if (tmp != nil) {
			xmlrpc_array_append_item([env rpcEnv], value, [tmp borrowReference]);
			[tmp release];
			[env raiseIfFaultOccurred];
		}
	}
	
	[env release];

	return [self initWithRpcValue:value behaviour:XMLRPCConsumeReference];
}

- initWithDictionary:(NSDictionary *)dict
{
	XMLRPCEnv *env;
	xmlrpc_value *value;
	NSEnumerator *e;
	id obj;

	if (dict == nil) {
		[self release];
		return nil;
	}

	env = [[XMLRPCEnv alloc] init];	
	value = xmlrpc_struct_new([env rpcEnv]);
	[env raiseIfFaultOccurred];

	e = [dict keyEnumerator];
	while ((obj = [e nextObject]) != nil) {
		XMLRPCValue *tmp;

		tmp = [[XMLRPCValue alloc] initWithObject:[dict objectForKey:obj]];
		if (tmp != nil) {
			xmlrpc_struct_set_value([env rpcEnv],
				value,
				(char *)[[obj description] cString],
				[tmp borrowReference]);
			[tmp release];
			[env raiseIfFaultOccurred];
		}
	}
	
	[env release];

	return [self initWithRpcValue:value behaviour:XMLRPCConsumeReference];
}

- initWithData:(NSData *)data
{
	XMLRPCEnv *env;
	xmlrpc_value *value;

	if (data == nil) {
		[self release];
		return nil;
	}

	env = [[XMLRPCEnv alloc] init];
	value = xmlrpc_build_value([env rpcEnv], "8", [data bytes], [data length]);
	
	[env raiseIfFaultOccurred];
	[env release];
	
	return [self initWithRpcValue:value behaviour:XMLRPCConsumeReference];
}

- initWithObjCValue:(NSObjCValue *)value
{
	id retVal = nil;

	if (value == NULL) {
		[self release];
		return nil;
	}

	switch (value->type) {
		case NSObjCCharType - 32:
		case NSObjCCharType: {
			retVal = [[XMLRPCValue alloc] initWithNumber:
				[NSNumber numberWithChar:value->value.charValue]];
			break;
		}
		case NSObjCShortType - 32:
		case NSObjCShortType: {
			retVal = [[XMLRPCValue alloc] initWithNumber:
				[NSNumber numberWithShort:value->value.shortValue]];
			break;
		}
		case NSObjCLongType - 32:
		case NSObjCLongType: {
			retVal = [[XMLRPCValue alloc] initWithNumber:
				[NSNumber numberWithLong:value->value.longValue]];
			break;
		}
		case NSObjCLonglongType - 32:
		case NSObjCLonglongType: {
			retVal = [[XMLRPCValue alloc] initWithNumber:
				[NSNumber numberWithLongLong:value->value.longValue]];
			break;
		}
		case NSObjCFloatType - 32:
		case NSObjCFloatType: {
			retVal = [[XMLRPCValue alloc] initWithNumber:
				[NSNumber numberWithFloat:value->value.floatValue]];
			break;
		}
		case NSObjCDoubleType - 32:
		case NSObjCDoubleType: {
			retVal = [[XMLRPCValue alloc] initWithNumber:
				[NSNumber numberWithDouble:value->value.doubleValue]];
			break;
		}
		case NSObjCSelectorType: {
			retVal = [[XMLRPCValue alloc] initWithString:
				NSStringFromSelector(value->value.selectorValue)];
			break;
		}
		case NSObjCObjectType: {
			retVal = [[XMLRPCValue alloc] initWithObject:value->value.objectValue];
			break;
		}
		case NSObjCStringType: {
			retVal = [[XMLRPCValue alloc] initWithString:
				[NSString stringWithCString:value->value.cStringLocation]];
			break;
		}
		case NSObjCNoType:
		case NSObjCVoidType:
			retVal = [[XMLRPCValue alloc] init];
			break;
		case NSObjCUnionType:
		case NSObjCArrayType: 
		case NSObjCBitfield:
		case NSObjCStructType:
		case NSObjCPointerType:
		default:
			[NSException raise:NSInvalidArgumentException
				format:@"Cannot convert object of Objective-C type %s to XML-RPC value",
				value->type];
			break;
	}

	return retVal;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%d:%@", [self type], [self object]];
}

- (id)object
{
	NSDictionary *d;
	NSString *className;

	switch ([self type]) {
		case XMLRPC_TYPE_INT:
		case XMLRPC_TYPE_BOOL:
		case XMLRPC_TYPE_DOUBLE:
			return [self numberValue];
		case XMLRPC_TYPE_DATETIME:
			return [self dateValue];
		case XMLRPC_TYPE_STRING:
			return [self stringValue];
		case XMLRPC_TYPE_BASE64:
			return [self dataValue];
		case XMLRPC_TYPE_ARRAY:
			return [self arrayValue];
		case XMLRPC_TYPE_STRUCT:
			/* Try key value coding */
			d = [self dictionaryValue];
			className = [[d objectForKey:@"NSObjectClass"] description];
			if (className == nil) {
				return d;
			} else {
				Class class = NSClassFromString(className);
				id obj;
				
				if (class == NULL) {
					[NSException raise:NSInvalidArgumentException
					format:@"Class %@ not found", className];
				}
				
				obj = NSAllocateObject(class, 0, NSDefaultMallocZone());
				if (obj == nil) {
					[NSException raise:NSMallocException format:@"-[XMLRPCValue object]"];
				}

				[[obj init] takeValuesFromDictionary:d];
				[obj autorelease];
				
				return obj;
			}
		default: 
			[NSException raise:NSGenericException format:@"Cannot convert XML-RPC values of type %d to Objective-C objects", [self type]];
			break;
	}

	return nil;
}

- (NSNumber *)numberValue
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	NSNumber *number = nil;
	
	switch ([self type]) {
		case XMLRPC_TYPE_INT: {
			xmlrpc_int32 result;
			xmlrpc_parse_value([env rpcEnv], mValue, "i", &result);
			[env raiseIfFaultOccurred];
			number = [NSNumber numberWithInt:result];
			break;
		}
		case XMLRPC_TYPE_BOOL: {
			xmlrpc_bool result;
			xmlrpc_parse_value([env rpcEnv], mValue, "b", &result);
			[env raiseIfFaultOccurred];
			number = [NSNumber numberWithBool:(BOOL)result];
			break;
		}
		case XMLRPC_TYPE_DOUBLE: {
			double result;
			xmlrpc_parse_value([env rpcEnv], mValue, "d", &result);
			[env raiseIfFaultOccurred];
			number = [NSNumber numberWithDouble:result];
			break;
		}
		default: {
			[NSException raise:NSGenericException format:
				@"Cannot convert XML-RPC type %d to NSNumber", [self type]];
			break;
		}
	}
	
	[env release];
	
	return number;
}

- (NSDate *)dateValue
{
	if ([self type] != XMLRPC_TYPE_DATETIME) {
		[NSException raise:NSGenericException format:
			@"Cannot convert XML-RPC type %d to NSDate", [self type]];
	}

	return nil; //XXX
}

- (NSString *)stringValue
{
	XMLRPCEnv *env = [[XMLRPCEnv alloc] init];
	char *result;
	size_t result_len;
	
	if ([self type] != XMLRPC_TYPE_STRING) {
		[NSException raise:NSGenericException format:
			@"Cannot convert XML-RPC type %d to NSString", [self type]];
	}
	
	xmlrpc_parse_value([env rpcEnv], mValue, "s#", &result, &result_len);

	[env raiseIfFaultOccurred];
	[env release];
	
	return [NSString stringWithCString:result length:result_len];
}

- (NSArray *)arrayValue
{
	if ([self type] != XMLRPC_TYPE_ARRAY) {
		[NSException raise:NSGenericException format:
			@"Cannot convert XML-RPC type %d to NSArray", [self type]];
	}

	return [XMLRPCArray arrayWithXMLRPCValue:self];
}

- (NSDictionary *)dictionaryValue
{
	if ([self type] != XMLRPC_TYPE_STRUCT) {
		[NSException raise:NSGenericException format:
			@"Cannot convert XML-RPC type %d to NSDictionary", [self type]];
	}

	return [XMLRPCDictionary dictionaryWithXMLRPCValue:self];
}

- (NSData *)dataValue
{
	if ([self type] != XMLRPC_TYPE_BASE64) {
		[NSException raise:NSGenericException format:
			@"Cannot convert XML-RPC type %d to NSData", [self type]];
	}

	return [XMLRPCData dataWithXMLRPCValue:self];
}

@end
