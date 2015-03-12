//
//  PlayerAid
//

#import "CreateTutorialViewController.h"
#import <FDTakeController.h>
#import "Tutorial.h"
#import "TutorialStep.h"
#import "Section.h"
#import "User.h"
#import "TutorialStepsDataSource.h"
#import "NavigationBarCustomizationHelper.h"
#import "CreateTutorialHeaderViewController.h"
#import "CreateTutorialStepButtonsView.h"
#import "TabBarHelper.h"
#import "CreateTutorialTextStepViewController.h"
#import "UsersController.h"
#import "MediaPickerHelper.h"
#import "AlertFactory.h"
#import "UIView+FadeAnimations.h"
#import "PublishingTutorialViewController.h"


@interface CreateTutorialViewController () <SaveTutorialDelegate, CreateTutorialStepButtonsDelegate, FDTakeDelegate>

@property (strong, nonatomic) CreateTutorialHeaderViewController *headerViewController;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;
@property (strong, nonatomic) FDTakeController *mediaController;

@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (weak, nonatomic) IBOutlet CreateTutorialStepButtonsView *createTutoriaStepButtonsView;
@property (weak, nonatomic) IBOutlet UIView *popoverView;
@property (weak, nonatomic) UIBarButtonItem *publishButton;

@property (strong, nonatomic) NSManagedObjectContext *createTutorialContext;
@property (strong, nonatomic) Tutorial *tutorial;

@end


@implementation CreateTutorialViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupNavigationBarButtons];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  [self setupAndAttachHeaderViewController];
  self.createTutoriaStepButtonsView.delegate = self;
  
  // Where should we do that? This doesn't seem to be a correct place...
  [self initializeContextAndNewTutorialObject];
  
  [self setupTutorialStepsDataSource];
  
  if (DEBUG_MODE_FLOW) {
    [self DEBUG_pressPublishButton];
  }
}

- (void)DEBUG_pressPublishButton
{
  defineWeakSelf();
  DISPATCH_AFTER(0.1, ^{
    [weakSelf publishButtonPressed];
  });
}

- (void)setupAndAttachHeaderViewController
{
  self.headerViewController = [[CreateTutorialHeaderViewController alloc] init];
  self.headerViewController.imagePickerPresentingViewController = self;
  self.headerViewController.saveDelegate = self;
  
  AssertTrueOrReturn(self.tutorialTableView);
  self.tutorialTableView.tableHeaderView = self.headerViewController.view;
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  [self updateTableHeaderViewSize];
}

- (void)updateTableHeaderViewSize
{
  CGFloat viewWidth = self.view.frame.size.width;
  CGFloat proportionalHeight = [self.headerViewController headerViewHeightForWidth:viewWidth];
  
  self.headerViewController.view.frame = CGRectMake(0, 0, viewWidth, proportionalHeight);
  self.tutorialTableView.tableHeaderView = self.headerViewController.view;
}

- (void)setupTutorialStepsDataSource
{
  AssertTrueOrReturn(self.tutorial);
  AssertTrueOrReturn(self.tutorialTableView);
  self.tutorialStepsDataSource = [[TutorialStepsDataSource alloc] initWithTableView:self.tutorialTableView tutorial:self.tutorial context:self.createTutorialContext allowsEditing:YES];
  self.tutorialStepsDataSource.moviePlayerParentViewController = self;
}

#pragma mark - Context and Tutorial object initialization

- (void)initializeContextAndNewTutorialObject
{
  self.createTutorialContext = [NSManagedObjectContext MR_context];
  AssertTrueOrReturn(self.createTutorialContext);
  
  [self deleteUserUnsavedTutorials];
  
  self.tutorial = [Tutorial MR_createInContext:self.createTutorialContext];
  AssertTrueOrReturn(self.tutorial);
  
  self.tutorial.primitiveUnsavedValue = YES;
  [self assignTutorialToCurrentUser];
}

// This is a temporary method, need to be either fixed or extracted from here
- (void)deleteUserUnsavedTutorials
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdBy = %@ && unsaved = YES", [self currentUser]];
  NSArray *unsavedTutorials = [Tutorial MR_findAllSortedBy:nil ascending:YES withPredicate:predicate inContext:self.createTutorialContext];
  for (Tutorial *tutorial in unsavedTutorials) {
    [tutorial MR_deleteInContext:self.createTutorialContext];
  }
  [self.createTutorialContext MR_saveToPersistentStoreAndWait];
}

- (void)assignTutorialToCurrentUser
{
  [[self currentUser] addCreatedTutorialObject:self.tutorial];
}

- (User *)currentUser
{
  return [[UsersController sharedInstance] currentUserInContext:self.createTutorialContext];
}

#pragma mark - NavigationBar buttons

- (void)setupNavigationBarButtons
{
  [self addNavigationBarCancelButton];
  [self addNavigationBarEditButton];
  [self addNavigationBarPublishButton];
  
  if (!DEBUG_MODE_FLOW) {
    self.publishButton.enabled = NO;
  }
}

- (void)addNavigationBarCancelButton
{
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];
  self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)addNavigationBarPublishButton
{
  UIBarButtonItem *publishButton = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonPressed)];
  self.navigationItem.rightBarButtonItem = publishButton;
  self.publishButton = publishButton;
}

- (void)addNavigationBarEditButton
{
  CGRect buttonRect = CGRectMake(0, 0, 60, 30);
  UIView *buttonContainer = [NavigationBarCustomizationHelper titleViewhWithButtonWithFrame:buttonRect title:@"Edit" target:self action:@selector(editButtonPressed)];
  self.navigationItem.titleView = buttonContainer;
}

#pragma mark - Actions

- (void)editButtonPressed
{
  // TODO: edit tutorial steps
  // TODO - it should provide an overlay view which allows reordering steps (or canceling reordering)
  
  [self.tutorialTableView setEditing:(!self.tutorialTableView.editing) animated:YES];
}

- (void)publishButtonPressed
{
  [self updateTutorialModelFromUI];
  
  if (DEBUG_MODE_FLOW) {
    [self DEBUG_publishTutorial];
  }
  
  BOOL tutorialDataComplete = YES;
  if (!DEBUG_MODE_FLOW) {
    tutorialDataComplete = [self.headerViewController validateTutorialDataCompleteShowErrorAlerts];
  }
  if (tutorialDataComplete) {
    [self presentPublishingTutorialViewController];
  }
}

// TODO: extract this method from here!! (introduce a separate class) 
- (void)DEBUG_publishTutorial
{
  // fill in empty fields with debug data
  self.tutorial.title = @"test_title";
  self.tutorial.section = [Section MR_findFirstInContext:self.createTutorialContext];
  self.tutorial.pngImageData = UIImagePNGRepresentation([UIImage imageNamed:@"bubble"]);
  
  // add dummy tutorial step
  TutorialStep *step1 = [TutorialStep tutorialStepWithText:@"debug text!" inContext:self.createTutorialContext];
  [self.tutorial.consistsOfSet addObject:step1];
  
  TutorialStep *step2 = [TutorialStep tutorialStepWithText:@"debug text 2!" inContext:self.createTutorialContext];
  [self.tutorial.consistsOfSet addObject:step2];
  
  TutorialStep *imageStep1 = [TutorialStep tutorialStepWithImage:[UIImage imageNamed:@"bubble"] inContext:self.createTutorialContext];
  [self.tutorial.consistsOfSet addObject:imageStep1];
}

- (void)presentPublishingTutorialViewController
{
  PublishingTutorialViewController *publishingViewController = [PublishingTutorialViewController new];
  publishingViewController.tutorial = self.tutorial;
  
  __weak typeof (self) weakSelf = self;
  publishingViewController.completionBlock = ^(NSError *error) {
    if (!error) {
      [weakSelf dismissViewController];
    }
  };
  [self presentViewController:publishingViewController animated:YES completion:nil];
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CreateTutorialStepButtonsDelegate

- (void)addPhotoStepSelected
{
  [self hideAddStepPopoverView];
  
  AssertTrueOrReturn(self.mediaController);
  [self.mediaController takePhotoOrChooseFromLibrary];
}

- (void)addVideoStepSelected
{
  [self hideAddStepPopoverView];
  
  AssertTrueOrReturn(self.mediaController);
  [self.mediaController takeVideoOrChooseFromLibrary];
}

- (void)addTextStepSelected
{
  [self hideAddStepPopoverView];
  
  if (self.tutorialTableView.isEditing) {
    [self.tutorialTableView setEditing:NO animated:YES];
    return;
  }
  [self pushCreateTutorialTextStepViewController];
}

- (void)hideAddStepPopoverView
{
  [self.popoverView fadeOutAnimationWithDuration:0.5f];
}

- (void)fillRequiredFieldsForTutorial:(Tutorial *)tutorial
{
  if (!tutorial.title) {
    tutorial.title = @"";
  }
  if (!tutorial.createdAt) {
    tutorial.createdAt = [NSDate new];
  }
  if (!tutorial.createdBy) {
    tutorial.createdBy = [self currentUser];
  }
}

#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
  AssertTrueOrReturn(photo);
  [self saveTutorialStepWithImage:photo];
}

- (void)takeController:(FDTakeController *)controller gotVideo:(NSURL *)video withInfo:(NSDictionary *)info
{
  AssertTrueOrReturn(video);
  [self saveTutorialStepWithVideoURL:video];
}

#pragma mark - Push views

- (void)pushCreateTutorialTextStepViewController
{
  __weak typeof(self) weakSelf = self;
  CreateTutorialTextStepViewController *viewController = [[CreateTutorialTextStepViewController alloc] initWithCompletion:^(NSString *text, NSError *error) {
    if (!error) {
      [weakSelf saveTutorialStepWithText:text];
    }
  }];
  
  UINavigationController *modalNavigationController = self.navigationController;
  AssertTrueOrReturn(modalNavigationController);
  [modalNavigationController pushViewController:viewController animated:YES];
}

#pragma mark - Save Tutorial Step

- (void)saveTutorialStepWithText:(NSString *)text
{
  TutorialStep *step = [TutorialStep tutorialStepWithText:text inContext:self.createTutorialContext];
  [self addTutorialStepAndSave:step];
}

- (void)saveTutorialStepWithImage:(UIImage *)image
{
  TutorialStep *step = [TutorialStep tutorialStepWithImage:image inContext:self.createTutorialContext];
  [self addTutorialStepAndSave:step];
}

- (void)saveTutorialStepWithVideoURL:(NSURL *)url
{
  TutorialStep *step = [TutorialStep tutorialStepWithVideoURL:url inContext:self.createTutorialContext];
  [self addTutorialStepAndSave:step];
}

- (void)addTutorialStepAndSave:(TutorialStep *)tutorialStep
{
  NSInteger maxOrderValue = [[self.tutorial.consistsOf valueForKeyPath:@"@max.orderValue"] integerValue];
  tutorialStep.primitiveOrderValue = maxOrderValue + 1;
  [self.tutorial addConsistsOfObject:tutorialStep];
  
  [self saveTutorial];
  self.publishButton.enabled = YES;
}

- (void)saveTutorial
{
  [self fillRequiredFieldsForTutorial:self.tutorial];
  [self.createTutorialContext MR_saveOnlySelfAndWait];
}

#pragma mark - SaveTutorialDelegate

- (void)saveTutorialTitled:(NSString *)title section:(Section *)section
{
  AssertTrueOrReturn(title.length);
  AssertTrueOrReturn(section);
  
  // TODO: get rid of this
  [AlertFactory showOKAlertViewWithMessage:@"<DEBUG> DRAFT user's tutorial saved (in fact this whole 'Save' button is just a temporary debug functionality, saving should probably happen automatically)"];
  [self updateTutorialModelFromUI];
  
  [self.createTutorialContext MR_saveToPersistentStoreAndWait];
  [self dismissViewController];
}

- (void)updateTutorialModelFromUI
{
  [self updateTutorialModelWithTitle:self.headerViewController.title section:self.headerViewController.selectedSection image:self.headerViewController.backgroundImageView.image];
}

- (void)updateTutorialModelWithTitle:(NSString *)title section:(Section *)section image:(UIImage *)image
{
  self.tutorial.title = title;
  self.tutorial.createdAt = [NSDate new];
  self.tutorial.primitiveDraftValue = YES;
  [self.tutorial setSection:[section MR_inContext:self.createTutorialContext]];
  self.tutorial.pngImageData = UIImagePNGRepresentation(image);
}

#pragma mark - Lazy initalization

- (FDTakeController *)mediaController
{
  if (!_mediaController) {
    _mediaController = [MediaPickerHelper fdTakeControllerWithDelegate:self viewControllerForPresentingImagePickerController:self];
  }
  return _mediaController;
}

@end
