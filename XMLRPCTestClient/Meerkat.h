#import <XMLRPCObjC/XMLRPCObjC.h>

@class NSNumber, NSArray, NSString;

@interface MeerkatRecipe : NSObject <XMLRPCKeyValueCoding>
{
	NSNumber *category;
	NSString *time_period;
	NSNumber *descriptions;
}

- (NSArray *)keysForXMLRPCCoding;

- (void)setCategory:(NSNumber *)n;
- (NSNumber *)category;

- (void)setTime_period:(NSString *)s;
- (NSString *)time_period;

- (void)setDescriptions:(NSNumber *)n;
- (NSNumber *)descriptions;

@end

@protocol Meerkat 
- (NSArray *)getItems:(MeerkatRecipe *)recipe;
@end

