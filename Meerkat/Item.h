/* Item.h created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>

@interface Item : NSObject
{
    NSString *description;
    NSString *link;
    NSString *title;
}

- (NSString *)description;
- (void)setDescription:(NSString *)s;
- (NSString *)link;
- (void)setLink:(NSString *)s;
- (NSString *)title;
- (void)setTitle:(NSString *)s;
- (int)numberOfChildren;
- childAtIndex:(int)n;
- (BOOL)isExpandable;

@end
