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

#import "Category.h"
#import "DataSource.h"
#import "Meerkat.h"
#import "Item.h"

@implementation Category

- (int)numberOfChildren
{
    return [[self items] count];
}

- childAtIndex:(int)n
{
    return [[self items] objectAtIndex:n];
}

- (BOOL)isExpandable
{
    return YES;
}

- (NSNumber *)id
{
    return _id;
}

- (void)setId:(NSNumber *)n
{
    [_id autorelease];
    _id = [n retain];
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

- initWithDataSource:(DataSource *)c
{
    [super init];
    datasource = [c retain];
    return self;
}

- (NSArray *)items
{
    if (items == nil) {
        MeerkatRecipe *recipe;
        NSArray *_items;
        NSEnumerator *e;
        id obj;

        recipe = [[MeerkatRecipe alloc] init];
        [recipe setCategory:[self id]];
        [recipe setTime_period:@"24HOUR"];

        _items = [[datasource meerkat] getItems:recipe];
        
        items = [[NSMutableArray alloc] initWithCapacity:[_items count]];
        e = [_items objectEnumerator];
        while ((obj = [e nextObject]) != nil) {
            Item *item;

            item = [[Item alloc] initWithTTL:(24 * 60 * 60.0)];
            if (item != nil) {
                [item takeValuesFromDictionary:(NSDictionary *)obj];
                [item autorelease];
                [items addObject:item];
            }
        }
        [recipe release];
    } else {
        /* expire old stuff */
        NSEnumerator *e;
        Item *item;

        e = [items objectEnumerator];
        while ((item = [e nextObject]) != nil) {
            if ([item isValid] == NO) {
                [items removeObject:item];
            }
        }
    }
    
    return items;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Category <%@> %@", [self id], [self title]];
}

- (void)dealloc
{
    [_id release];
    [title release];
    [datasource release];
    [items release];
    [super dealloc];
}

- (void)forgetItems
{
    if (items != nil) {
        [items release];
        items = nil;
    }
}
@end

