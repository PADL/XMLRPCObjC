/* Category.h created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>

@class DataSource;

@interface Category : NSObject
{
    DataSource *datasource;
    NSNumber *_id;
    NSString *title;
    NSMutableArray *items;
}

- initWithDataSource:(DataSource *)controller;

- (NSNumber *)id;
- (void)setId:(NSNumber *)id;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSArray *)items;

- (int)numberOfChildren;
- childAtIndex:(int)n;
- (BOOL)isExpandable;
@end