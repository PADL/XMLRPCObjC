//
//  XMLRPCMethodSignature.m
//  XMLRPCObjC -- Objective-C bindings to XML-RPC
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#include "XMLRPCPrivate.h"

static char *_XMLRPCMakeObjCSignature(NSArray *types);

@interface NSMethodSignature (Private)
+ signatureWithObjCTypes:(const char *)fp12;
@end

@implementation NSMethodSignature (XMLRPCMethodSignature)
- (NSString *)XMLRPCSignature
{
	int i;
	const char *retType;
	NSMutableString *xmlSig = [NSMutableString string];

	retType = [self methodReturnType];
	if (retType != NULL && *retType != 'v') {
		const char *xmlType = _XMLRPCTypeFromObjCType(retType);

		if (xmlType == NULL) {
			[NSException raise:NSInvalidArgumentException format:@"Cannot map Objective-C type %s to XML-RPC type", retType];
		}

		[xmlSig appendFormat:@"%s:", xmlType];
	}

	/* Skip the first two arguments, self and _cmd */
	for (i = 2; i < [self numberOfArguments]; i++) {
		const char *type = [self getArgumentTypeAtIndex:i];
		const char *xmlType = _XMLRPCTypeFromObjCType(type);
		
		if (xmlType == NULL) {
			[NSException raise:NSInvalidArgumentException format:@"Cannot convert Objective-C type %s to XML-RPC type", retType];
		}

		[xmlSig appendString:[NSString stringWithCString:xmlType]];
	}

	return xmlSig;
}

+ (NSMethodSignature *)signatureWithXMLRPCTypes:(NSArray *)types
{
	char *ctypes = _XMLRPCMakeObjCSignature(types);
	NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:ctypes];
	NSZoneFree(NSDefaultMallocZone(), ctypes);

	return sig;
}

@end

static char *_XMLRPCMakeObjCSignature(NSArray *types)
{
	NSString *type;
	int i, count;
	char *_types;
	
	count = [types count];
	_types = (char *)NSZoneMalloc(NSDefaultMallocZone(), count + 3);
	if (_types == NULL) {
		[NSException raise:NSMallocException format:@"XMLRPCMethodSignature"];
	}

	_types[1] = NSObjCObjectType; /* self */
	_types[2] = NSObjCSelectorType; /* _cmd */

	for (i = 0; i < count; i++) {
		enum _NSObjCValueType objCType;
		type = [types objectAtIndex:i];
		
		if ([type isEqualToString:@"int"]) {
			objCType = NSObjCLongType;
		} else if ([type isEqualToString:@"boolean"]) {
			objCType = NSObjCCharType;
		} else if ([type isEqualToString:@"double"]) {
			objCType = NSObjCDoubleType;
		} else if ([type isEqualToString:@"string"]) {
			objCType = NSObjCStringType;
		} else {
			// assume that we can map it to an object
			objCType = NSObjCObjectType;
		}

		if (i == 0) {
			/* return value */
			_types[0] = (char)objCType;
		} else {
			_types[i + 2] = (char)objCType;
		}
	}
	_types[count + 2] = '\0';

	return _types;
}


const char *_XMLRPCTypeFromObjCType(const char *objCType)
{
	switch (*objCType) {
		case NSObjCCharType:
		case NSObjCShortType:
		case NSObjCLongType:
		case NSObjCLonglongType:
			return "i";
		case NSObjCFloatType:
		case NSObjCDoubleType:
			return "d";
		case NSObjCPointerType:
		case NSObjCObjectType:
			return "p";
		case NSObjCStringType:
			return "s";
		default:
			break;
		
	}
	
	return NULL;
}

const char *_XMLRPCObjCTypeFromRpcType(const char *xmlType)
{
	if (xmlType == NULL || xmlType[0] == '\0') {
		return NULL;
	}
	
	if (xmlType[1] != '\0' && strcmp(xmlType, "s#") != 0) {
		return NULL;
	}
	
	switch (*xmlType) {
		case 'i':
			return "l";
		case 'b':
			return "c";
		case 'd':
			return "d";
		case 'p':
			return "^";
		case 's':
			return "*";
		default:
			break;
	}
	
	return "@";
}



NSString *_XMLRPCMakeMethodName(NSString *className, SEL selector)
{
	NSString *ret, *sel;
	NSZone *zone;
	const char *csel, *sp;
	char *method, *mp;
	BOOL needCaps = NO;
	
	sel = NSStringFromSelector(selector);
	csel = [sel cString];
	
	zone = NSDefaultMallocZone();
	mp = method = (char *)NSZoneMalloc(zone, [sel cStringLength] + 1);
	if (method == NULL) {
		[NSException raise:NSMallocException format:@"_XMLRPCMakeMethodName"];
	}
	
	for (sp = csel; *sp != '\0'; sp++) {
		if (*sp == ':') {
			needCaps = YES;
			continue;
		}
		if (needCaps == YES) {
			*mp++ = toupper(*sp);
			needCaps = NO;
		} else {
			*mp++ = *sp;
		}
	}

	*mp = '\0';

	if (className == nil) {
		ret = [NSString stringWithCString:method];
	} else {	
		ret = [NSString stringWithFormat:@"%@.%@", className,
			[NSString stringWithCString:method]];
	}
	
	NSZoneFree(zone, method);

	return ret;
}
