/* Item.m created by lukeh on Tue 09-Apr-2002 */

#import "Item.h"
#import "Controller.h"

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
