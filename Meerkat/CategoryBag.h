/* CategoryBag.h created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>

@class DataSource;

@interface CategoryBag : NSObject
{
    DataSource *datasource;
    NSMutableArray *categories;
}
- (NSArray *)categories;
- initWithDataSource:(DataSource *)c;
- (int)numberOfChildren;
- childAtIndex:(int)n;
- (BOOL)isExpandable;

@end
