//
//  PlayerAid
//

@interface NSURL (URLString)

+ (NSString *)URLStringWithPath:(NSString *)path baseURL:(NSURL *)baseURL;
+ (NSURL *)URLWithPath:(NSString *)path baseURL:(NSURL *)baseURL;

@end
