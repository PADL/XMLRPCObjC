/* Category.m created by lukeh on Tue 09-Apr-2002 */

#import "Category.h"
#import "Controller.h"

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

- initWithController:(Controller *)c
{
    [super init];
    controller = [c retain];
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
        [recipe setDescriptions:[NSNumber numberWithInt:0]];

        _items = [[controller meerkat] getItems:recipe];
        
        items = [[NSMutableArray alloc] initWithCapacity:[_items count]];
        e = [_items objectEnumerator];
        while ((obj = [e nextObject]) != nil)
        {
            Item *item;

            item = [[Item alloc] init];
            if (item != nil) {
                [item takeValuesFromDictionary:(NSDictionary *)obj];
                [item autorelease];
                [items addObject:item];
            }
        }
        [recipe release];
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
    [controller release];
    [items release];
    [super dealloc];
}
@end
