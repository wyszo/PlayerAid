//
//  PlayerAid
//

#import "TutorialsHelper.h"
#import "Tutorial.h"


@implementation TutorialsHelper

+ (Tutorial *)tutorialWithServerID:(NSString *)serverID inContext:(NSManagedObjectContext *)localContext
{
  NSString *const kServerIDPropertyNameString = @"serverID";
  AssertTrueOrReturnNil([self tutorialInstancesRespondToSelector:NSSelectorFromString(kServerIDPropertyNameString)]);
  
  NSInteger integerServerID = [serverID integerValue];
  AssertTrueOrReturnNil(integerServerID > 0);
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", kServerIDPropertyNameString, integerServerID];
  return [Tutorial MR_findFirstWithPredicate:predicate inContext:localContext];
}

+ (NSString *)serverIDFromTutorialDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary.count);
  return dictionary[kTutorialDictionaryServerIDPropertyName];
}

+ (BOOL)tutorialInstancesRespondToSelector:(SEL)selector
{
  AssertTrueOrReturnNo(selector);
  BOOL respondsToSelector = NO;
  
  Tutorial *dummyTutorial = [Tutorial MR_createEntity];
  respondsToSelector = [dummyTutorial respondsToSelector:selector];
  [dummyTutorial MR_deleteEntity];
  
  return respondsToSelector;
}

@end
