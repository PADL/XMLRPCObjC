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
	XMLRPCServer *server = [XMLRPCAbyssServer server];

	[server setObjectAutoCreation:YES];
	[server run];

	[pool release];
	exit(0);
}

