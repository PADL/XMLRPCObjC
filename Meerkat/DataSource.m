/* DataSource.m created by lukeh on Tue 09-Apr-2002 */

#import "DataSource.h"
#import "CategoryBag.h"
#import "Item.h"

@implementation DataSource

// Data Source methods

- (id <Meerkat>)meerkat
{
    if ([self connect] == NO) {
        return nil;
    }
    return meerkat;
}

- (IBAction)showInfoPanel:(id)sender
{
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

- (BOOL)connect
{
    if (client == nil) {
        client = [[XMLRPCClient client:[NSURL URLWithString:
            @"http://www.oreillynet.com/meerkat/xml-rpc/server.php"]] retain];

        [meerkat release];
        meerkat = (id <Meerkat>)[client proxyForTarget:@"meerkat"];
        [meerkat setProtocolForProxy:@protocol(Meerkat)];
        [meerkat retain];
    }

    return (meerkat != nil);
}

- init
{
    [super init];
    bag = [[CategoryBag alloc] initWithDataSource:self];
    return self;
}

- (void)dealloc
{
    [bag release];
    [client release];
    [meerkat release];
    [super dealloc];
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        item = bag;
    }
//    NSLog(@"outlineView: %@ numberOfChildrenOfItem: %@", outlineView, item);
    return [item numberOfChildren];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (item == nil) {
        item = bag;
    }
//    NSLog(@"outlineView: %@ isItemExpandable: %@", outlineView, item);
    
    return [item isExpandable];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
    if (item == nil) {
        item = bag;
    }
//    NSLog(@"outlineView: %@ child: %d ofItem: %@", outlineView, index, item);
    
    return [item childAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [item title];
}

- (IBAction)open:(id)sender
{
    id item = [outlineView itemAtRow:[outlineView selectedRow]];

    if ([item isKindOfClass:[Item class]]) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[item link]]];        
    }
}

// Delegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

@end
