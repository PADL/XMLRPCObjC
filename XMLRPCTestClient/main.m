#import <Foundation/Foundation.h>
#import <XMLRPCObjC/XMLRPCObjC.h>
#import "StateNaming.h"

void testWrappers(void) {
	XMLRPCClient *client;
	XMLRPCValue *value, *argFrame;
	NSNumber *number = [NSNumber numberWithInt:41];
	NSArray *args = [NSArray arrayWithObject:number];
	
	client = [XMLRPCClient client:@"http://betty.userland.com/RPC2"];
	argFrame = [XMLRPCValue valueWithObject:args];
	NSLog([argFrame description]);
	value = [client call:@"examples.getStateName" withArguments:argFrame];
	NSLog([value object]);
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

int main (int argc, const char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	testWrappers();
	testProxy();
	[pool release];
	exit(0);
}
