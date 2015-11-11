//
//  PlayerAid
//

@import KZAsserts;
@import BlocksKit;
@import TWCommonLib;
@import MagicalRecord;
#import "TutorialCommentsController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialsHelper.h"
#import "AlertFactory.h"

@interface TutorialCommentsController()
@property (strong, nonatomic) Tutorial *tutorial;
@property (copy, nonatomic) VoidBlock commentsCountChangedBlock;
@end

@implementation TutorialCommentsController

#pragma mark - Init

- (nonnull instancetype)initWithTutorial:(nonnull Tutorial *)tutorial commentsCountChangedBlock:(nullable VoidBlock)commentsCountChangedBlock
{
  AssertTrueOrReturnNil(tutorial);
  
  self = [super init];
  if (self) {
    _tutorial = tutorial;
    _commentsCountChangedBlock = commentsCountChangedBlock;
    [self setupCommentsChangedCallback];
  }
  return self;
}

- (void)setupCommentsChangedCallback
{
  if (!self.commentsCountChangedBlock) {
    return;
  }
  
  defineWeakSelf();
  [self bk_addObserverForKeyPath:@"tutorial.hasComments" task:^(id target) {
    CallBlock(weakSelf.commentsCountChangedBlock, nil);
  }];
}

#pragma mark -

- (void)sendACommentWithText:(nonnull NSString *)text
{
  AssertTrueOrReturn(text.length);
  
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] addAComment:text toTutorial:self.tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [AlertFactory showGenericErrorAlertView];
    } else {
      AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
      [weakSelf updateTutorialObjectFromDictionary:(NSDictionary *)responseObject];
    }
  }];
}

- (void)updateTutorialObjectFromDictionary:(nonnull NSDictionary *)dictionary
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [TutorialsHelper tutorialFromDictionary:dictionary parseAuthors:NO inContext:localContext];
  }];
}

@end
