/*
 * (c) Copyright 2002 PADL Software Pty Ltd
 * To anyone who acknowledges that this file is provided "AS IS"
 * without any express or implied warranty:
 *                 permission to use, copy, modify, and distribute this
 * file for any purpose is hereby granted without fee, provided that
 * the above copyright notices and this notice appears in all source
 * code copies, and that the name PADL Software Pty Ltd not be used in
 * advertising or publicity pertaining to distribution of the software
 * without specific, written prior permission.  PADL Software Pty Ltd
 * makes no representation about the suitability of this software for
 * any purpose.
 *
 */

#import "Item.h"
#import "DataSource.h"

@implementation Item
- (void)dealloc
{
    [description release];
    [link release];
    [title release];
    [super dealloc];
}

- (NSString *)description
{
    return description;
}

- (void)setDescription:(NSString *)s
{
    [description autorelease];
    description = [s retain];
}

- (NSString *)link
{
    return link;
}

- (void)setLink:(NSString *)s
{
    [link autorelease];
    link = [s retain];
}

- (NSString *)title
{
    return title;
}

- (void)setTitle:(NSString *)s
{
    [title autorelease];
    title = [s retain];
}

- (int)numberOfChildren
{
    return -1;
}

- childAtIndex:(int)n
{
    return (id)-1;
}

- (BOOL)isExpandable
{
    return NO;
}

@end
