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
      [weakSelf refreshTutorialAndComments];
    }
  }];
}

- (void)refreshTutorialAndComments
{
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] refreshTutorialAndComments:weakSelf.tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      // TODO: it probably makes sense to only parse comments in here - or better - to ask server only for comments
      [TutorialsHelper tutorialFromDictionary:responseObject parseAuthors:NO inContext:localContext];
    }];
  }];
}

@end
