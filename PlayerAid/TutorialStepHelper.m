//
//  PlayerAid
//

#import "TutorialStepHelper.h"
#import "TutorialStep.h"


@implementation TutorialStepHelper

- (NSOrderedSet *)tutorialStepsFromDictionariesArray:(NSArray *)stepsDictionaries inContext:(NSManagedObjectContext *)context
{
  if (!stepsDictionaries.count) {
    return nil;
  }
  
  NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet new];
  
  [stepsDictionaries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    AssertTrueOrReturn([obj isKindOfClass:[NSDictionary class]]);
    NSDictionary *dictionary = (NSDictionary *)obj;
    NSString *stepID = [TutorialStep serverIDFromTutorialStepDictionary:dictionary];
    
    TutorialStep *tutorialStep = [TutorialStep MR_findFirstByAttribute:@"serverID" withValue:stepID inContext:context];
    if (!tutorialStep) {
      tutorialStep = [TutorialStep MR_createInContext:context];
    }
    [tutorialStep configureFromDictionary:dictionary];
    
    [mutableSet addObject:tutorialStep];
  }];
  
  return [mutableSet copy];
}

@end
