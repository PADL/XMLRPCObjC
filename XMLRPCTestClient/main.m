#import <Foundation/Foundation.h>
#import <XMLRPCObjC/XMLRPCObjC.h>
#import "StateNaming.h"
#import "Meerkat.h"
#import "sample.h"

static NSString *localURL = @"http://lennie.off.padl.com:8000/RPC2";

/*
 * Call the state mapping service by constructing an
 * argument frame.
 */
void testStateMapperArg(void) {
	XMLRPCClient *client;
	XMLRPCValue *value, *argFrame;
	NSNumber *number = [NSNumber numberWithInt:41];
	NSArray *args = [NSArray arrayWithObject:number];
	
	client = [XMLRPCClient client:[NSURL URLWithString:@"http://betty.userland.com/RPC2"]];
	argFrame = [XMLRPCValue valueWithObject:args];
	NSLog([argFrame description]);
	value = [client call:@"examples.getStateName" withArguments:argFrame];
	NSLog(@"%@", [[value object] description]);
}

/*
 * Call the local addition service by constructing an
 * argument frame.
 */
void testLocalArg(void) {
	XMLRPCClient *client;
	XMLRPCValue *value, *argFrame;
	NSNumber *x = [NSNumber numberWithInt:23], *y = [NSNumber numberWithInt:42];
	NSArray *args = [NSArray arrayWithObjects:x, y, nil];

	client = [XMLRPCClient client:[NSURL URLWithString:localURL]];
	argFrame = [XMLRPCValue valueWithObject:args];
	NSLog([argFrame description]);
	value = [client call:@"sample.add" withArguments:argFrame];
	NSLog(@"%@", [[value object] description]);
}

/*
 * Test the state mapping service using a protocoll.
 */
void testStateMapper(void) {
	XMLRPCClient *client;
	char *stateName;
	XMLRPCProxy <StateNaming> *stateNamer;
	id rootProxy;
	
	client = [XMLRPCClient client:[NSURL URLWithString:@"http://betty.userland.com/RPC2"]];
	rootProxy = [client rootProxy];

	stateNamer = (id <StateNaming>)[rootProxy proxyForTarget:@"examples"];
	[stateNamer setProtocolForProxy:@protocol(StateNaming)];

	stateName = [stateNamer getStateName:41];
	NSLog(@"%s", stateName);
}

/*
 * Test the local service using introspection.
 */
void testLocal(void) {
	XMLRPCClient *client;
	id adder;
	id rootProxy;
	long result;
	
	client = [XMLRPCClient client:[NSURL URLWithString:localURL]];
	rootProxy = [client rootProxy];

	adder = [rootProxy proxyForTarget:@"sample"];
	/* note how we don't set a protocol */
	result = [adder add:23 :42];

	NSLog(@"%ld", result);
}

/*
 * Test the oreilly meerkat service
 */
void testMeerkat(void) {
	XMLRPCClient *client;
	id rootProxy;
	XMLRPCProxy <Meerkat> *meerkat;
	NSArray *apps;
	MeerkatRecipe *recipe;

	client = [XMLRPCClient client:[NSURL URLWithString:
		@"http://www.oreillynet.com/meerkat/xml-rpc/server.php"]];
	rootProxy = [client rootProxy];
	
	recipe = [[[MeerkatRecipe alloc] init] autorelease];
	[recipe setCategory:[NSNumber numberWithInt:6]]; // SOFTWARE_LINUX
	[recipe setTime_period:@"24HOUR"];
	[recipe setDescriptions:[NSNumber numberWithInt:76]]; // no idea

	meerkat = (id <Meerkat>)[rootProxy proxyForTarget:@"meerkat"];
	[meerkat setProtocolForProxy:@protocol(Meerkat)];

	apps = [meerkat getItems:recipe];

	NSLog(@"%@", apps);
}

int main (int argc, const char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//	NSLog(@"Testing wrappers...\n");
//	testStateMapperArg();

	NSLog(@"Testing state mapping service using proxy...\n");
	testStateMapper();

//	NSLog(@"Testing local addition service with wrappers...\n");
//	testLocalArg();

	NSLog(@"Testing local addition service using proxy and type introspection...\n");
	testLocal();

	NSLog(@"Testing O'Reilly Meerkat service using proxy...\n");
	testMeerkat();

	[pool release];
	exit(0);
}
