/*
 * (c) Copyright 2001-2002 PADL Software Pty Ltd
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

#import "Meerkat.h"

@implementation MeerkatRecipe
- (void)dealloc
{
    [channel release];
    [category release];
    [item release];
    [search release];
    [search_what release];
    [time_period release];
    [profile release];
    [mob release];
    [url release];
    [num_items release];
    [ids release];
    [descriptions release];
    [categories release];
    [channels release];
    [dates release];
    [dc release];

    [super dealloc];
}

- (NSArray *)keysForXMLRPCCoding
{
	return [NSArray arrayWithObjects:
            @"channel", @"category", @"item", @"search", @"search_what",
            @"time_period", @"profile", @"mob", @"url",
            @"ids", @"descriptions", @"categories", @"dates",
            @"dc", @"num_items", nil];
}
- (void)setChannel:(NSNumber *)n
{
    [channel autorelease];
    channel = [n retain];
}

- (NSNumber *)channel
{
    return channel;
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

- (void)setItem:(NSNumber *)n
{
    [item autorelease];
    item = [n retain];
}

- (NSNumber *)item
{
    return item;
}

- (void)setSearch:(NSString *)s
{
    [search autorelease];
    search = [s retain];
}

- (NSString *)search
{
    return search;
}

- (void)setSearch_what:(NSString *)s
{
    [search_what autorelease];
    search_what = [s retain];
}

- (NSString *)search_what
{
    return search_what;
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


- (void)setProfile:(NSNumber *)n
{
    [profile autorelease];
    profile = [n retain];
}

- (NSNumber *)profile
{
    return profile;
}

- (void)setMob:(NSNumber *)n
{
    [mob autorelease];
    mob = [n retain];
}

- (NSNumber *)mob
{
    return mob;
}

- (void)setUrl:(NSString *)s
{
    [url autorelease];
    url = [s retain];
}

- (NSString *)url
{
    return url;
}

- (void)setIds:(NSNumber *)n
{
    [ids autorelease];
    ids = [n retain];
}

- (NSNumber *)ids
{
    return ids;
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

- (void)setCategories:(NSNumber *)n
{
    [categories autorelease];
    categories = [n retain];
}

- (NSNumber *)categories
{
    return categories;
}

- (void)setChannels:(NSNumber *)n
{
    [channels autorelease];
    channels = [n retain];
}
- (NSNumber *)channels
{
    return channels;
}

- (void)setDc:(NSNumber *)n
{
    [dc autorelease];
    dc = [n retain];
}
- (NSNumber *)dc
{
    return dc;
}

- (void)setDates:(NSNumber *)n
{
    [dates autorelease];
    dates = [n retain];
}

- (NSNumber *)dates
{
    return dates;
}

- (void)setNum_items:(NSNumber *)n
{
    [num_items autorelease];
    num_items = [n retain];
}

- (NSNumber *)num_items
{
    return num_items;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Recipe Category %@ Time Period %@",
        [self category], [self time_period]];
}
@end
