/* Controller.m created by lukeh on Tue 09-Apr-2002 */

#import "Controller.h"

@implementation Controller

- (id <Meerkat>)meerkat
{
    if ([self connect] == NO) {
        return nil;
    }
    return meerkat;
}

- init
{
    [super init];
    return self;
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

- (void)dealloc
{
    [client release];
    [meerkat release];
    [super dealloc];
}

@end
