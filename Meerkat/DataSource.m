/*
 * (c) Copyright 2002 PADL Software Pty Ltd
 * To anyone who acknowledges that this file is provided "AS IS"
 * without any express or implied warranty:
 *                 permission to use, copy, modify, and distribute this
 * file for any purpose is hereby granted without fee, provided that
 * the above copyright notices and this notice appears in all source
 * code copies, and that the name PADL Software Pty Ltd not be used in
 * advertising or publicity pertaining to distribution of the software
 * without specific, written prior permission.  PADL Software Pty Ltd
 * makes no representation about the suitability of this software for
 * any purpose.
 *
 */

#import "DataSource.h"
#import "CategoryBag.h"
#import "Item.h"

@implementation DataSource

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
    return [item numberOfChildren];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (item == nil) {
        item = bag;
    }
    return [item isExpandable];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
    if (item == nil) {
        item = bag;
    }
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

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

- (IBAction)flushArticleCache:(id)sender
{
    [bag forgetItems];
}

@end
