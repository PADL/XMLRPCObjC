#import <XMLRPCObjC/XMLRPCObjC.h>

@class NSNumber, NSArray, NSString;

@interface MeerkatRecipe : NSObject <XMLRPCKeyValueCoding>
{
    NSNumber *channel;
    NSNumber *category;
    NSNumber *item;
    NSString *search;
    NSString *search_what;
    NSString *time_period;
    NSNumber *profile;
    NSNumber *mob;
    NSString *url;
    NSNumber *ids;
    NSNumber *descriptions;
    NSNumber *categories;
    NSNumber *channels;
    NSNumber *dates;
    NSNumber *dc;
    NSNumber *num_items;
}

- (NSArray *)keysForXMLRPCCoding;

- (void)setChannel:(NSNumber *)n;
- (NSNumber *)channel;

- (void)setCategory:(NSNumber *)n;
- (NSNumber *)category;

- (void)setItem:(NSNumber *)n;
- (NSNumber *)item;

- (void)setSearch:(NSString *)s;
- (NSString *)search;

- (void)setSearch_what:(NSString *)s;
- (NSString *)search_what;

- (void)setTime_period:(NSString *)s;
- (NSString *)time_period;

- (void)setProfile:(NSNumber *)n;
- (NSNumber *)profile;

- (void)setMob:(NSNumber *)n;
- (NSNumber *)mob;

- (void)setUrl:(NSString *)s;
- (NSString *)url;

- (void)setIds:(NSNumber *)n;
- (NSNumber *)ids;

- (void)setDescriptions:(NSNumber *)n;
- (NSNumber *)descriptions;

- (void)setCategories:(NSNumber *)n;
- (NSNumber *)categories;

- (void)setChannels:(NSNumber *)n;
- (NSNumber *)channels;

- (void)setDc:(NSNumber *)n;
- (NSNumber *)dc;

- (void)setDates:(NSNumber *)n;
- (NSNumber *)dates;

- (void)setNum_items:(NSNumber *)n;
- (NSNumber *)num_items;
@end

@protocol Meerkat
- (NSArray *)getCategories;
- (NSArray *)getChannels;
- (NSArray *)getChannelsByCategory:(NSNumber *)n;

- (NSArray *)getItems:(MeerkatRecipe *)recipe;
@end

