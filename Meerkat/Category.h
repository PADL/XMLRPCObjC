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

#import <AppKit/AppKit.h>

@class DataSource;

@interface Category : NSObject
{
    DataSource *datasource;
    NSNumber *_id;
    NSString *title;
    NSMutableArray *items;
}

- initWithDataSource:(DataSource *)ds;

- (NSNumber *)id;
- (void)setId:(NSNumber *)id;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSArray *)items;

- (int)numberOfChildren;
- childAtIndex:(int)n;
- (BOOL)isExpandable;
- (void)forgetItems;
@end
