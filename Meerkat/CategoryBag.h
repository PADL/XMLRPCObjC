/* CategoryBag.h created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>

@class Controller;

@interface CategoryBag : NSObject
{
    Controller *controller;
    NSMutableArray *categories;
}
- (NSArray *)categories;
- initWithController:(Controller *)c;
- (int)numberOfChildren;
- childAtIndex:(int)n;
- (BOOL)isExpandable;

@end
