//
//  XMLRPCServer.m
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2000 PADL Software Pty Ltd. All rights reserved.
//

/* I have tried to omit any xmlrpc-c specific stuff from this */

#import "XMLRPCPrivate.h"

XMLRPC_EXPORT id XMLRPCInvokeObjCMethod(id obj, NSString *methodName, NSArray *arguments)
{
	char *translated_method_name, *mp;
	const char *sp;
	SEL sel;
	NSInvocation *invocation;
	NSString *selectorName;
	NSMethodSignature *sig;
	NSZone *zone = NSDefaultMallocZone();
	NSArray *path;
	unsigned int i, count;
	NSObjCValue retData;

	count = [arguments count];

	mp = translated_method_name = (char *)NSZoneMalloc(zone, [methodName cStringLength] + 1 + count);
	if (translated_method_name == NULL) {
		[NSException raise:NSMallocException format:@"XMLRPCInvokeObjCMethod"];
	}

	/* copy until the first period */
	for (sp = [methodName cString]; *sp != '.' && *sp != '\0'; sp++) 
		*mp++ = *sp; /* just copy */

	/* change underscores to colons, eg. a method of
	 * doSomething_withObject would become doSomething:withObject
	 */
	for (; *sp != '\0'; sp++) {
		if (*sp == '_') {
			*mp++ = ':';
			--count; /* don't add this later */
		} else {
			*mp++ = *sp;
		}
	}

	/* add colons for any arguments we take 
	 * so doSomething_withObject would become doSomething:withObject:
	 */
	for (i = 0; i < count; i++) {
		*mp++ = ':';
	}

	*mp = '\0';

	/* now trace the method path using keyValueCoding */
	path = [[NSString stringWithCString:translated_method_name] componentsSeparatedByString:@"."];

	NSZoneFree(zone, translated_method_name);

	count = [path count];

	if (count < 2) {
		[NSException raise:NSInvalidArgumentException format:@"Assertion failed: methods must contain at least one period."];
	}
		
	/* trace the path, creating intermediate objects */
	for (i = 1; i < count - 1; i++) {
		obj = [obj valueForKey:[path objectAtIndex:i]];
	}

	selectorName = [path objectAtIndex:count - 1];
	sel = NSSelectorFromString(selectorName);
	sig = [obj methodSignatureForSelector:sel];

	invocation = [NSInvocation invocationWithMethodSignature:sig];
	[invocation setSelector:sel];
	[invocation setTarget:obj];

	count = [sig numberOfArguments] - 2;
	if (count != [arguments count]) {
		[NSException raise:NSInvalidArgumentException format:@"Argument count mismatch"];
	}

	for (i = 0; i < count; i++) {
		id argument = [arguments objectAtIndex:i];

		[invocation setArgument:&argument atIndex:i + 2];
	}

	[invocation invoke];

	retData.type = *[sig methodReturnType];
	[invocation getReturnValue:&retData.value.pointerValue];
	
	return retData.value.objectValue;
}

@implementation NSObject (XMLRPCMethodHandling)
- (id)invoke:(NSString *)methodName withArguments:(NSArray *)arguments
{
	return XMLRPCInvokeObjCMethod(self, methodName, arguments);
}
@end

@implementation NSProxy (XMLRPCMethodHandling)
- (id)invoke:(NSString *)methodName withArguments:(NSArray *)arguments
{
	return XMLRPCInvokeObjCMethod(self, methodName, arguments);
}
@end

static Class _defaultClass = NULL;

@implementation XMLRPCServer

+ (void)initialize
{
	_defaultClass = [XMLRPCAbyssServer class];
}

+ (XMLRPCServer *)server
{
	return [[[_defaultClass alloc] init] autorelease];
}

+ (XMLRPCServer *)serverWithConfiguration:(NSDictionary *)config
{
	return [[[_defaultClass alloc] initWithConfiguration:config] autorelease];
}

- init
{
	return [self initWithConfiguration:[NSDictionary dictionary]];
}

- initWithConfiguration:(NSDictionary *)config
{
	[super init];

	mObjectCache = [[NSMutableDictionary alloc] init];
	mAutoCreate = NO;
	mConfig = [config retain];
	
	return self;
}

- (void)run
{
	[NSException raise:NSGenericException format:@"XMLRPCServer not concrete class"];
}

- (void)dealloc
{
	[mObjectCache release];
	[mConfig release];
	[super dealloc];
}

- (void)setObject:(id)object forKey:(NSString *)target
{
	[mObjectCache setObject:object forKey:target];
}

- (void)removeObjectForKey:(id)aKey
{
	[mObjectCache removeObjectForKey:aKey];
}

- (id)objectForKey:(NSString *)target
{
	id obj = [mObjectCache objectForKey:target];
	if (obj == nil) {
		if (obj == nil) {
			obj = [mObjectCache objectForKey:@"$default"];
		}
		if (obj == nil && mAutoCreate == YES) {
			Class class = NSClassFromString(target);
			obj = NSAllocateObject(class, 0, NSDefaultMallocZone());
			if (obj == nil) {
				[NSException raise:NSMallocException format:@"-[XMLRPCServer objectForKey:]"];
			}
			obj = [obj init];
			if (obj == nil) {
				return nil;
			}
			[mObjectCache setObject:obj forKey:target];
			[obj release];
		}
	}
	return obj;
}

- (void)setObjectAutoCreation:(BOOL)yorn
{
	mAutoCreate = yorn;
}

- (BOOL)willAutoCreateObjects
{
	return mAutoCreate;
}

@end

#undef XMLRPC_EXPORT
#define XMLRPC_EXPORT

XMLRPC_EXPORT NSString *const XMLRPCAbyssServerConfigurationKey = @"XMLRPCAbyssServerConfigurationKey";
