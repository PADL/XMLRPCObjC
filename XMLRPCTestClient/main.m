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
	id object;
	NSNumber *number = [NSNumber numberWithInt:41];
	NSArray *args = [NSArray arrayWithObject:number];
	
	client = [XMLRPCClient client:[NSURL URLWithString:@"http://betty.userland.com/RPC2"]];
	object = [client invoke:@"examples.getStateName" withArguments:args];
	NSLog(@"%@", [object description]);
}

/*
 * Call the local addition service by constructing an
 * argument frame.
 */
void testLocalArg(void) {
	XMLRPCClient *client;
	id value;
	NSNumber *x = [NSNumber numberWithInt:23], *y = [NSNumber numberWithInt:42];
	NSArray *args = [NSArray arrayWithObjects:x, y, nil];

	client = [XMLRPCClient client:[NSURL URLWithString:localURL]];
	value = [client invoke:@"sample.add" withArguments:args];
	NSLog(@"%@", [value description]);
}

/*
 * Test the state mapping service using a protocoll.
 */
void testStateMapper(void) {
	XMLRPCClient *client;
	char *stateName;
	XMLRPCProxy <StateNaming> *stateNamer;
	
	client = [XMLRPCClient client:[NSURL URLWithString:@"http://betty.userland.com/RPC2"]];
	stateNamer = (id <StateNaming>)[client proxyForTarget:@"examples"];
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
	long result;
	
	client = [XMLRPCClient client:[NSURL URLWithString:localURL]];
	adder = [client proxyForTarget:@"sample"];
	/* note how we don't set a protocol */
	result = [adder add:23 :42];

	NSLog(@"%ld", result);
}

void testListMethods(void) {
	XMLRPCClient *client;
	NSArray *methods;
	id system;

	client = [XMLRPCClient client:[NSURL URLWithString:localURL]];
	system = [client proxyForTarget:@"system"];
	methods = [system performSelector:@selector(listMethods)];

	NSLog(@"%@", methods);
}

/*
 * Test the oreilly meerkat service
 */
void testMeerkat(void) {
	XMLRPCClient *client;
	XMLRPCProxy <Meerkat> *meerkat;
	NSArray *apps;
	MeerkatRecipe *recipe;

	client = [XMLRPCClient client:[NSURL URLWithString:
		@"http://www.oreillynet.com/meerkat/xml-rpc/server.php"]];
	
	recipe = [[[MeerkatRecipe alloc] init] autorelease];
	[recipe setCategory:[NSNumber numberWithInt:6]]; // SOFTWARE_LINUX
	[recipe setTime_period:@"24HOUR"];
	[recipe setDescriptions:[NSNumber numberWithInt:76]]; // no idea

	meerkat = (id <Meerkat>)[client proxyForTarget:@"meerkat"];
	[meerkat setProtocolForProxy:@protocol(Meerkat)];

	apps = [meerkat getItems:recipe];

	NSLog(@"%@", apps);
}

void usage(char *argv0) {
		fprintf(stderr, "Usage: %s\n", argv0);
		fprintf(stderr, "	--test-state-mapper-wrapper |\n");
		fprintf(stderr, "	--test-state-mapper-proxy |\n");
		fprintf(stderr, "	--test-adder-wrapper |\n");
		fprintf(stderr, "	--test-adder-proxy |\n");
		fprintf(stderr, "	--test-registry |\n");
		fprintf(stderr, "	--test-meerkat\n");
		exit(1);
}

int main (int argc, const char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	if (argc < 2) {
		usage((char*)argv[0]);
	}
	
	if (!strcmp(argv[1], "--test-state-mapper-wrapper")) {
		testStateMapperArg();
	} else if (!strcmp(argv[1], "--test-state-mapper-proxy")) {
		testStateMapper();
	} else if (!strcmp(argv[1], "--test-adder-wrapper")) {
		testLocalArg();
	} else if (!strcmp(argv[1], "--test-adder-proxy")) {
		testLocal();
	} else if (!strcmp(argv[1], "--test-registry")) {
		testListMethods();
	} else if (!strcmp(argv[1], "--test-meerkat")) {
		testMeerkat();
	} else {
		usage((char*)argv[0]);
	}
	
	[pool release];
	exit(0);
}
