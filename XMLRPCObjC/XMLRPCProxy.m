//
//  XMLRPCProxy.m
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCPrivate.h"

@interface NSMethodSignature (Private)
+ (NSMethodSignature *)signatureWithObjCTypes:(const char *)types;
@end


static Class _defaultClass = NULL;

@implementation XMLRPCProxy

+ (void)initialize
{
	_defaultClass = [XMLRPCGlueProxy class];
}

+ (XMLRPCProxy *)proxyWithTarget:(NSString *)target client:(XMLRPCClient *)client
{
	return [[[_defaultClass alloc] initWithTarget:target client:client] autorelease];
}

- initWithTarget:(NSString *)target client:(XMLRPCClient *)client;
{
	mClient = [client retain];
	mTarget = [target retain];
	mProtocol = nil;

	return self;
}

- (XMLRPCProxy *)proxyForTarget:(NSString *)name
{
	XMLRPCProxy *obj;
	NSString *target;

	if (mTarget == nil) {
		target = [name retain];
	} else {
		target = [NSString stringWithFormat:@"%@.%@", mTarget, name];
	}

	obj = [XMLRPCProxy proxyWithTarget:target client:mClient];
	[obj setProtocolForProxy:mProtocol];

	[target release];

	return obj;
}

- (void)dealloc
{
	[mClient release];
	[mTarget release];
	[super dealloc];
}

- (XMLRPCClient *)clientForProxy
{
	return mClient;
}

- (void)setProtocolForProxy:(Protocol *)proto
{
	mProtocol = proto;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
	NSMethodSignature *sig = [invocation methodSignature];
	int i, nargs = [sig numberOfArguments];
	NSMutableArray *args;
	enum _NSObjCValueType objCType;
	NSObjCValue objCValue;
	id retObject;

	args = [[NSMutableArray alloc] initWithCapacity:nargs - 2];

	/*
	 * Loop through arguments, skipping the first two, to build
	 * arg frame.
	 */	
	for (i = 2; i < nargs; ++i) {
		const char *argType;
		id argValue = nil;
		
		argType = [sig getArgumentTypeAtIndex:i];
		[invocation getArgument:&objCValue.value.pointerValue atIndex:i];
		
		objCValue.type = *argType;
		
		switch (objCValue.type) {
			/*
			 * We're nice, and convert primitive types. Really
			 * we only want to support objects.
			 */
			case NSObjCCharType:
				argValue = [NSNumber numberWithChar:objCValue.value.charValue];
				break;
			case NSObjCShortType:
				argValue = [NSNumber numberWithShort:objCValue.value.shortValue];
				break;
			case NSObjCLongType:
				argValue = [NSNumber numberWithLong:objCValue.value.longValue];
				break;
			case NSObjCLonglongType:
				argValue = [NSNumber numberWithLongLong:objCValue.value.longlongValue];
				break;
			case NSObjCFloatType:
				argValue = [NSNumber numberWithFloat:objCValue.value.floatValue];
				break;
			case NSObjCDoubleType:
				argValue = [NSNumber numberWithDouble:objCValue.value.doubleValue];
				break;
			case NSObjCSelectorType:
				argValue = NSStringFromSelector(objCValue.value.selectorValue);
				break;
			case NSObjCObjectType:
				argValue = objCValue.value.objectValue;
				break;
			case NSObjCStringType:
				argValue = [NSString stringWithCString:objCValue.value.cStringLocation];
				break;
			case NSObjCArrayType:
			case NSObjCNoType:
			case NSObjCVoidType:
			case NSObjCUnionType:
			case NSObjCBitfield:
			case NSObjCStructType:
			case NSObjCPointerType:
			default:
				[NSException raise:NSInvalidArgumentException format:@"Cannot convert Objective-C type %s to Objective-C object", argType];
		}
		
		[args insertObject:argValue atIndex:(i - 2)];
	}

	retObject = [mClient invoke:_XMLRPCMakeMethodName(mTarget, [invocation selector])
		withArguments:args];

	[args release];

	objCType = *[sig methodReturnType];

	switch (objCType) {
		case NSObjCCharType: 
		case NSObjCShortType: 
		case NSObjCLongType: 
		case NSObjCLonglongType: 
		case NSObjCFloatType: 
		case NSObjCDoubleType:
		case NSObjCStringType:
			_XMLRPCObjCValueFromObject(&objCValue, retObject);
			if (objCValue.type != objCType) {
				[NSException raise:NSInvalidArgumentException format:@"Cannot convert Objective-C type %c to primitive type %c", objCValue.type, objCType];
			}
			[invocation setReturnValue:&objCValue.value.pointerValue];
			break;
		case NSObjCSelectorType: {
			SEL sel = NSSelectorFromString(retObject);
			[invocation setReturnValue:&sel];
			break;
		}
		case NSObjCObjectType: {
			[invocation setReturnValue:&retObject];
			break;
		}
		case NSObjCNoType:
		case NSObjCVoidType:
			break;
		case NSObjCUnionType:
		case NSObjCArrayType: 
		case NSObjCBitfield:
		case NSObjCStructType:
		case NSObjCPointerType:
		default:
			[NSException raise:NSInvalidArgumentException format:@"Cannot convert XML-RPC value to Objective-C type %c", objCType];
	}
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
	if (mProtocol != nil && [mProtocol conformsTo:aProtocol]) {
		return YES;
	}

	return [super conformsToProtocol:aProtocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
	NSMethodSignature *ret;

	ret = nil;

	/* first check whether it's known to the runtime */
	if (mProtocol != nil) {
		struct objc_method_description *desc;

		desc = [mProtocol descriptionForInstanceMethod:sel];
		if (desc != NULL) {
			ret = [NSMethodSignature signatureWithObjCTypes:desc->types];
		}
	}

	if (ret == nil) {
		id possibleSigs;
		NSArray *args;
		
		args = [[NSArray alloc] initWithObjects:_XMLRPCMakeMethodName(mTarget, sel), nil];

		possibleSigs = [mClient invoke:@"system.methodSignature" withArguments:args];
		if ([possibleSigs isKindOfClass:[NSArray class]] == NO) {
			/* No type information available for this. Client
			 * must supply protocol! */
			return nil;
		}
		
		ret = [NSMethodSignature signatureWithXMLRPCTypes:[possibleSigs objectAtIndex:0]];
		
		[args release];
	}
	
	return ret;
}
@end

XMLRPC_EXPORT void _XMLRPCObjCValueFromObject(NSObjCValue *valp, id obj)
{
	if ([obj isKindOfClass:[NSNumber class]]) {
		valp->type = *[(NSNumber *)obj objCType];
		switch (valp->type) {
			case NSObjCLongType:
				valp->value.longValue = [(NSNumber *)obj intValue];
				break;
			case NSObjCCharType:
				valp->value.charValue = [(NSNumber *)obj charValue];
				break;
			case NSObjCDoubleType:
				valp->value.doubleValue = [(NSNumber *)obj doubleValue];
				break;
			default:
				[(NSNumber *)obj getValue:&valp->value.pointerValue];
				break;
		}
	} else if ([obj isKindOfClass:[NSString class]]) {
		valp->type = NSObjCStringType;
		valp->value.cStringLocation = (char *)[(NSString *)obj cString];
	} else if ([obj isKindOfClass:[NSData class]]) {
		valp->type = NSObjCPointerType;
		valp->value.pointerValue = (void *)[(NSData *)obj bytes];
	} else {
		valp->type = NSObjCObjectType;
		valp->value.objectValue = obj;
	}
}
