/* Controller.h created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>
#import "Meerkat.h"
#import "Category.h"
#import "CategoryBag.h"
#import "Item.h"
#import "DataSource.h"

@interface Controller : NSObject
{
    XMLRPCClient *client;
    XMLRPCProxy <Meerkat> *meerkat;
}
- (BOOL)connect;
- (id <Meerkat>)meerkat;

@end
