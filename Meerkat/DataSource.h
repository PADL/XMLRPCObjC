/* DataSource.m created by lukeh on Tue 09-Apr-2002 */

#import <AppKit/AppKit.h>
#import <XMLRPCObjC/XMLRPCObjC.h>

#import "Meerkat.h"

@class CategoryBag;

@interface DataSource : NSObject
{
    XMLRPCClient *client;
    XMLRPCProxy <Meerkat> *meerkat;
    CategoryBag *bag;
    IBOutlet NSOutlineView *outlineView;
}
// Data Source methods

- (id <Meerkat>)meerkat;
- (BOOL)connect;
- (IBAction)open:(id)sender;
- (IBAction)showInfoPanel:(id)sender;

@end
