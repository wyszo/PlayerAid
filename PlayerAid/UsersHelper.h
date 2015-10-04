//
//  PlayerAid
//

@import CoreData;
@import Foundation;

@interface UsersHelper : NSObject

- (NSSet *)setOfOtherUsersFromDictionariesArray:(id)dictionariesArray inContext:(NSManagedObjectContext *)context;

@end
