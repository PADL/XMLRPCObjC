/* DataSource.h created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>

@class CategoryBag, Controller;

@interface DataSource : NSObject
{
    CategoryBag *bag;
}
- initWithController:(Controller *)c;
@end
