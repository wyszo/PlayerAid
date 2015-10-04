//
//  PlayerAid
//

@import CoreData;
@import Foundation;

@interface TutorialStepHelper : NSObject

- (NSOrderedSet *)tutorialStepsFromDictionariesArray:(NSArray *)stepsDictionaries inContext:(NSManagedObjectContext *)context;

@end
