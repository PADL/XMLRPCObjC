#import <Foundation/Foundation.h>
#import <XMLRPCObjC/XMLRPCObjC.h>

int main (int argc, const char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	XMLRPCServer *server;
	XMLRPCClient *client;
	NSString *url;
	
	if (argc != 2 || argc != 3) {
		fprintf(stderr, "Usage: %s: [URL] [abyssConfigFile]\n", argv[0]);
		exit(1);
	}
	
	url = [NSString stringWithCString:argv[1]];
	
	if (argc == 3) {
		NSMutableDictionary *config;
		config = [NSMutableDictionary dictionary];
		[config setObject:[NSString stringWithCString:argv[2]] forKey:XMLRPCAbyssServerConfigurationKey];
		server = [XMLRPCAbyssServer serverWithConfiguration:config];
	} else {
		server = [XMLRPCAbyssServer server];
	}
	
	client = [XMLRPCClient client:[NSURL URLWithString:url]];
	
	[server setObject:client forKey:@"$default"];
	[server run];
	
    [pool release];
    exit(0);
}
