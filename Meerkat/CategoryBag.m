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

#import "CategoryBag.h"
#import "DataSource.h"
#import "Category.h"

@implementation CategoryBag
- initWithDataSource:(DataSource *)c
{
    [super init];
    datasource = [c retain];
    return self;
}

- (int)numberOfChildren
{
    return [[self categories] count];
}

- childAtIndex:(int)n
{
    return [[self categories] objectAtIndex:n];
}

- (BOOL)isExpandable
{
    return YES;
}

- (NSArray *)categories
{
    if (categories == nil) {
        NSArray *_categories;
        NSEnumerator *e;
        id obj;

        _categories = [[datasource meerkat] getCategories];
        categories = [[NSMutableArray alloc] initWithCapacity:[_categories count]];
        e = [_categories objectEnumerator];
        while ((obj = [e nextObject]) != nil) {
            Category *cat;

            cat = [[Category alloc] initWithDataSource:datasource];
            if (cat != nil) {
                [cat takeValuesFromDictionary:(NSDictionary *)obj];
                [cat autorelease];
                [categories addObject:cat];
            }
        }
    }

    return categories;
}

- (NSString *)description
{
    return [[self categories] description];
}

- (void)forgetItems
{
    NSEnumerator *e;
    Category *cat;

    if (categories != nil) {
        e = [categories objectEnumerator];
        while ((cat = [e nextObject]) != nil) {
            [cat forgetItems];
        }
    }
}
@end
