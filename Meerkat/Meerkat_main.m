#import <AppKit/AppKit.h>
#import "Meerkat.h"

void testMeerkat(void) {
    XMLRPCClient *client;
    XMLRPCProxy <Meerkat> *meerkat;
    NSArray *apps;
    MeerkatRecipe *recipe;
    NSAutoreleasePool *puddle = [[NSAutoreleasePool alloc] init];

    client = [XMLRPCClient client:[NSURL URLWithString:
        @"http://www.oreillynet.com/meerkat/xml-rpc/server.php"]];

    meerkat = (id <Meerkat>)[client proxyForTarget:@"meerkat"];
    [meerkat setProtocolForProxy:@protocol(Meerkat)];

    NSLog(@"%@", [meerkat getCategories]);

    recipe = [[[MeerkatRecipe alloc] init] autorelease];
    [recipe setCategory:[NSNumber numberWithInt:43]]; // SOFTWARE_LINUX
    [recipe setTime_period:@"24HOUR"];
    [recipe setDescriptions:[NSNumber numberWithInt:1]]; // no idea
    NSLog(@"%@", [recipe description]);

    apps = [meerkat getItems:recipe];

    NSLog(@"%@", apps);
    [puddle release];
}


int main(int argc, const char *argv[]) {
#if 0
    testMeerkat();
#else
    return NSApplicationMain(argc, argv);
#endif
}
