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

@interface Item : NSObject
{
    NSString *description;
    NSString *link;
    NSString *title;
    NSDate *fetchTime;
    NSTimeInterval ttl;
}

- (NSString *)description;
- (void)setDescription:(NSString *)s;
- (NSString *)link;
- (void)setLink:(NSString *)s;
- (NSString *)title;
- (void)setTitle:(NSString *)s;
- initWithTTL:(NSTimeInterval)ttl;
- (int)numberOfChildren;
- childAtIndex:(int)n;
- (BOOL)isExpandable;
- (BOOL)isValid;
@end
