//
//  XMLRPCValue.h
//  XMLRPCGlue -- private glue between XMLRPCObjC and xmlrpc-c
//
//  Created by lukeh on Fri Feb 09 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//

#import "XMLRPCGlue.h"


/*
 * Determines whether we steal the reference
 * to the underlying C library handle when we
 * create an XMLRPCValue object.
 */
enum XMLRPCReferenceBehaviour {
	XMLRPCMakeReference,
	XMLRPCConsumeReference
};

@interface XMLRPCValue : NSObject {
@private
	xmlrpc_value *mValue;
}

/*
 * Factory methods.
 */
+ (XMLRPCValue *)value; /* returns boolean FALSE value */
+ (XMLRPCValue *)valueWithRpcValue:(xmlrpc_value *)value;
+ (XMLRPCValue *)valueWithRpcValue:(xmlrpc_value *)value behaviour:(enum XMLRPCReferenceBehaviour)behaviour;

+ (XMLRPCValue *)valueWithObject:(id)object;
+ (XMLRPCValue *)valueWithNumber:(NSNumber *)number;
+ (XMLRPCValue *)valueWithDate:(NSDate *)date;
+ (XMLRPCValue *)valueWithString:(NSString *)string;
+ (XMLRPCValue *)valueWithArray:(NSArray *)array;
+ (XMLRPCValue *)valueWithData:(NSData *)data;
+ (XMLRPCValue *)valueWithDictionary:(NSDictionary *)dict;
+ (XMLRPCValue *)valueWithObjCValue:(NSObjCValue *)val;

/*
 * Designated initializers.
 */
- init;
- initWithRpcValue:(xmlrpc_value *)value;
- initWithRpcValue:(xmlrpc_value *)value behaviour:(enum XMLRPCReferenceBehaviour)behaviour;

/*
 * initWithObject: will attempt to convert the
 * object to a dictionary (if it is not a known
 * type) using XMLRPCKeyValueCoding.
 */
- initWithObject:(id)object;
- initWithNumber:(NSNumber *)number;
- initWithDate:(NSDate *)date;
- initWithString:(NSString *)string;
- initWithArray:(NSArray *)array;
- initWithDictionary:(NSDictionary *)dict;
- initWithData:(NSData *)data;
- initWithObjCValue:(NSObjCValue *)val;

- (xmlrpc_type)type;
- (xmlrpc_value *)makeReference;
- (xmlrpc_value *)borrowReference;

/*
 * object will, if the value is an XMLRPC dictionary
 * with a value for NSObjectClass, attempt to convert
 * it into an object of specified class.
 */
- (id)object;
- (NSNumber *)numberValue;
- (NSDate *)dateValue;
- (NSString *)stringValue;
- (NSArray *)arrayValue;
- (NSData *)dataValue;
- (NSDictionary *)dictionaryValue;

@end
