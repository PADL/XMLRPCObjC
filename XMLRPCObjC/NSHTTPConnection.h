#import <Foundation/Foundation.h>

@protocol NSHTTPConnectionClient <NSObject>
- (void)requestWasCancelled:fp16;
- (void)connectionFailedDuringRequest:fp16;
- (void)receivedDataBlock:fp12 forRequest:fp16 finished:(char)fp27;
- (void)receivedHeaders:fp12 forRequest:fp20;
@end

@class NSHTTPSocket;

@interface NSHTTPConnection:NSObject <NSHTTPConnectionClient>
{
    NSPort *_port;
    NSHost *_host;
    unsigned int _remotePort;
    NSLock *_lock;
    NSMutableArray *_newJobs;
    void *_completedJobs;
    int _currentSynchCondition;
    NSMutableArray *_synchCompletedJobs;
    NSConditionLock *_synchLock;
    NSHTTPSocket *_socket;
}

+ (void)initialize;
+ cachedConnectionForHost:fp12 port:(unsigned int)fp16;
+ connectionForHost:fp12 port:(unsigned int)fp16;
- (int)_nextSynchCondition;
- initWithHost:(NSHost *)fp12 port:(unsigned int)fp16;
- (void)dealloc;
- host;
- (unsigned int)remotePortNumber;
- sendRequestSynchronously:fp12 headers:(id *)fp16;
- (void)enqueueRequest:fp12 forClient:fp16;
- (void)cancelRequest:fp12;
- (void)cancelFetchOfURL:fp12;
- (void)receivedHeaders:fp12 forRequest:fp16;
- (void)receivedDataBlock:fp12 forRequest:fp16 finished:(char)fp20;
- (void)connectionFailedDuringRequest:fp12;
- (void)requestWasCancelled:fp12;
- (void)handlePortMessage:fp12;
- (void)portBecameInvalid:fp12;

@end

@interface NSHTTPConnection(NSHTTPConnectionBackgroundThread)
- (void)processRequests:fp12;
- (STR)_findEOL:(STR)fp12 length:(unsigned int)fp16 delimiter:(int *)fp20;
- fetchHeadersForRequest:fp12 connectionDied:(char *)fp16;
- enrichedHeadersFromHeaders:fp12 andStatus:fp16;
- (unsigned int)numberDataBytesForRequest:fp12 withHeaders:fp16;
- (void)fetchResponseForRequest:fp12;
- (void)signalMessage:(void *)fp12;
- (void)signalTaskCompletion;
- (void)signalConnectionFailureForRequest:fp12;
- (void)signalDataBlock:fp12 forRequest:fp16 finished:(char)fp20;
- (void)signalHeaders:fp12 complete:(char)fp16 forRequest:fp20;
@end

@interface NSHTTPSocket:NSObject
{
    unsigned int _socket;
    NSData *_surplusBytes;
}

+ descriptorWithStreamSocket;
- initWithSocket:(unsigned int)fp12;
- (void)dealloc;
- (void)connectToHost:fp12 withPort:(unsigned int)fp16;
- readAvailableData:(unsigned int)fp12;
- (void)writeData:fp12;
- (void)returnSurplusBytes:fp12;

@end

@interface NSHTTPRequest:NSObject
{
    NSString *_req;
    NSURL *_url;
    NSMutableDictionary *_headers;
    NSMutableArray *_headerOrder;
    NSData *_data;
    id _client;
    int _condition;
}

- initWithMethod:fp12 URL:fp16;
- (void)dealloc;
- (void)addHeader:fp12 value:fp16;
- (void)setData:fp12;
- serializedRequest;
- requestMethod;
- URL;
- _client;
- (void)_setClient:fp12;
- (char)fetchesURL:fp12;
- (int)_condition;
- (void)_setCondition:(int)fp12;

@end
