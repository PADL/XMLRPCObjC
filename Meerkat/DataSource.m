/* DataSource.m created by lukeh on Tue 09-Apr-2002 */

#import "DataSource.h"
#import "Controller.h"

@implementation DataSource

// Data Source methods

- init
{
    Controller *c = [[Controller alloc] init];
    [self initWithController:c];
    [c release];
    return self;
}

- initWithController:(Controller *)c
{
    [super init];
    bag = [[CategoryBag alloc] initWithController:c];
    return self;
}

- (void)dealloc
{
    [bag release];
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
    NSString *_html;
    NSData *html;
    id as;

    if ([item isKindOfClass:[Item class]]) {
        _html = [[NSString alloc] initWithFormat:@"<A HREF=\"%@\">%@</A>",
            [item link], [item title]];
        html = [[NSData alloc] initWithBytes:[_html cString] length:[_html cStringLength]];

        as = [[[NSAttributedString alloc] initWithHTML:html documentAttributes:NULL] autorelease];

        [html release];
        [_html release];

    } else {
        as = [item title];
    }
    
    return as;
}

// Delegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

@end
