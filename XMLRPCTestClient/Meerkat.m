//
//  Meerkat.m
//  XMLRPCTestClient
//
//  Created by lukeh on Sun Feb 11 2001.
//  Copyright (c) 2001 PADL Software Pty Ltd. All rights reserved.
//  Use is subject to license.
//

#import "Meerkat.h"


@implementation MeerkatRecipe
{
	NSNumber *category;
	NSString *time_period;
	NSNumber *descriptions;
}

- (void)dealloc
{
	[category release];
	[time_period release];
	[descriptions release];
	[super dealloc];
}

- (NSArray *)keysForXMLRPCCoding
{
	return [NSArray arrayWithObjects:@"category", @"time_period", @"descriptions", nil];
}

- (void)setCategory:(NSNumber *)n
{
	[category autorelease];
	category = [n retain];
}

- (NSNumber *)category
{
	return category;
}

- (void)setTime_period:(NSString *)s
{
	[time_period autorelease];
	time_period = [s retain];
}

- (NSString *)time_period
{
	return time_period;
}

- (void)setDescriptions:(NSNumber *)n
{
	[descriptions autorelease];
	descriptions = [n retain];
}

- (NSNumber *)descriptions
{
	return descriptions;
}

@end
