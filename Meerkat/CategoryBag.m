/* CategoryBag.m created by lukeh on Tue 09-Apr-2002 */

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
        while ((obj = [e nextObject]) != nil)
        {
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
/*
- (NSString *)description
{
    return [[self categories] description];
}
 */
@end
