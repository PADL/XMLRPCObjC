#import <Foundation/Foundation.h>
#import <XMLRPCObjC/XMLRPCObjC.h>

@interface sample : NSObject
- (NSNumber *)add:(NSNumber *)x :(NSNumber *)y;
@end

@implementation sample
- (NSNumber *)add:(NSNumber *)x :(NSNumber *)y
{
	int result;
	
	result = [x intValue] + [y intValue];
	
	return [NSNumber numberWithInt:result];
}
@end

int main (int argc, const char *argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	XMLRPCServer *server = [XMLRPCServer server];

	/*
	 * have the server automatically instantiate
	 * sample objects for us
	 */
	[server setObjectAutoCreation:YES];

	/*
	 * run the server (never exits)
	 */
	[server run];

	[pool release];

	exit(0);
}

