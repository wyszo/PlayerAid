//
//  PlayerAid
//

@import KZAsserts;
@import MagicalRecord;
#import "TutorialsHelper.h"
#import "Tutorial.h"

@implementation TutorialsHelper

#pragma mark - Tutorial model helpers

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

#pragma mark - Parsing tutorials

+ (NSSet *)setOfTutorialsFromDictionariesArray:(id)dictionariesArray parseAuthors:(BOOL)parseAuthors inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(context);
  AssertTrueOrReturnNil([dictionariesArray isKindOfClass:[NSArray class]]);
  NSMutableArray *tutorialsArray = [NSMutableArray new];
  
  [dictionariesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    AssertTrueOrReturn([obj isKindOfClass:[NSDictionary class]]);
    NSDictionary *dictionary = (NSDictionary *)obj;
    
    NSString *serverID = [TutorialsHelper serverIDFromTutorialDictionary:dictionary];
    Tutorial *tutorial = [TutorialsHelper tutorialWithServerID:serverID inContext:context];
    if (!tutorial) {
      tutorial = [Tutorial MR_createEntityInContext:context];
    }
    [tutorial configureFromDictionary:dictionary includeAuthor:parseAuthors];
    
    AssertTrueOrReturn(tutorial);
    [tutorialsArray addObject:tutorial];
  }];
  
  return [NSSet setWithArray:tutorialsArray];
}

#pragma mark - Change tutorial state

+ (void)markTutorialAsInappropriateByCurrentUser:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    Tutorial *tutorialInContext = [tutorial MR_inContext:localContext];
    tutorialInContext.flaggedAsInappropriateValue = YES;
    // TODO: when I changed tutorialInContext.state (to inappropriate), it didn't save, figure out why
  }];
}

@end
