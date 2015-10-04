//
//  PlayerAid
//

@import Foundation;

@interface PersistedUsersProperties : NSObject

@property (nonatomic, assign) BOOL gridEnabled;

+ (instancetype)sharedInstance;

@end
