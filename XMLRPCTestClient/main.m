#import <Foundation/Foundation.h>
#import <XMLRPCObjC/XMLRPCObjC.h>
#import "StateNaming.h"
#import "sample.h"
#import "Meerkat.h"

void testWrappers(void) {
	XMLRPCClient *client;
	XMLRPCValue *value, *argFrame;
	NSNumber *number = [NSNumber numberWithInt:41];
	NSArray *args = [NSArray arrayWithObject:number];
	
	client = [XMLRPCClient client:@"http://betty.userland.com/RPC2"];
	argFrame = [XMLRPCValue valueWithObject:args];
	NSLog([argFrame description]);
	value = [client call:@"examples.getStateName" withArguments:argFrame];
	NSLog(@"%@", [[value object] description]);
}

void testWrappers2(void) {
	XMLRPCClient *client;
	XMLRPCValue *value, *argFrame;
	NSNumber *x = [NSNumber numberWithInt:23], *y = [NSNumber numberWithInt:42];
	NSArray *args = [NSArray arrayWithObjects:x, y, nil];

	client = [XMLRPCClient client:@"http://lennie.off.padl.com:8000/RPC2"];
	argFrame = [XMLRPCValue valueWithObject:args];
	NSLog([argFrame description]);
	value = [client call:@"sample.add" withArguments:argFrame];
	NSLog(@"%@", [[value object] description]);
}

void testProxy(void) {
	XMLRPCClient *client;
	NSNumber *number = [NSNumber numberWithInt:41];
	NSString *stateName;
	XMLRPCProxy <StateNaming> *stateNamer;
	id rootProxy;
	
	client = [XMLRPCClient client:@"http://betty.userland.com/RPC2"];
	rootProxy = [client rootProxy];

	stateNamer = (id <StateNaming>)[rootProxy proxyForTarget:@"examples"];
	[stateNamer setProtocolForProxy:@protocol(StateNaming)];

	stateName = [stateNamer getStateName:number];
	NSLog(@"%@", stateName);
}

void testLocal(void) {
	XMLRPCClient *client;
	NSNumber *x = [NSNumber numberWithInt:23], *y = [NSNumber numberWithInt:42];
	NSNumber *result;
	XMLRPCProxy <sample_protocol> *adder;
	id rootProxy;

	client = [XMLRPCClient client:@"http://lennie.off.padl.com:8000/RPC2"];
	rootProxy = [client rootProxy];

	adder = (id <sample_protocol>)[rootProxy proxyForTarget:@"sample"];
	[adder setProtocolForProxy:@protocol(sample_protocol)];
	result = [adder add:x :y];

	NSLog(@"%@", result);
}

void testMeerkat(void) {
	XMLRPCClient *client;
	id rootProxy;
	XMLRPCProxy <Meerkat> *meerkat;
	NSMutableDictionary *recipe = [NSMutableDictionary dictionary];
	NSArray *apps;

	client = [XMLRPCClient client:@"http://www.oreillynet.com/meerkat/xml-rpc/server.php"];
	rootProxy = [client rootProxy];
	[recipe setObject:[NSNumber numberWithInt:6] forKey:@"category"]; // SOFTWARE_LINUX
	[recipe setObject:@"24HOUR" forKey:@"time_period"];
	[recipe setObject:[NSNumber numberWithInt:76] forKey:@"descriptions"];

	meerkat = (id <Meerkat>)[rootProxy proxyForTarget:@"meerkat"];
	[meerkat setProtocolForProxy:@protocol(Meerkat)];

	apps = [meerkat getItems:recipe];

	NSLog(@"%@", apps);
}

int main (int argc, const char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	printf("Testing wrappers...\n");
	testWrappers();

	printf("Testing proxy with state mapping service...\n");
	testProxy();

	printf("Testing local addition service with wrappers...\n");
	testWrappers2();

	printf("Testing local addition service with proxy...\n");
	testLocal();

	printf("Testing O'Reilly Meerkat service...\n");
	testMeerkat();

	[pool release];
	exit(0);
}
