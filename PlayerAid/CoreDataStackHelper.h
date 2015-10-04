//
//  PlayerAid
//

@import Foundation;

@interface CoreDataStackHelper : NSObject

+ (void)setupCoreDataStack;
+ (void)deleteCoreDataStore;
+ (void)deleteAndRecreateCoreDataStore;

+ (NSString *)persistentStoreName;

@end
