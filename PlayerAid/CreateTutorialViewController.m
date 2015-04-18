//
//  PlayerAid
//

#import "CreateTutorialViewController.h"
#import <FDTakeController.h>
#import <YCameraViewController.h>
#import "Tutorial.h"
#import "TutorialStep.h"
#import "Section.h"
#import "User.h"
#import "TutorialStepsDataSource.h"
#import "NavigationBarCustomizationHelper.h"
#import "CreateTutorialHeaderViewController.h"
#import "CreateTutorialStepButtonsContainerView.h"
#import "TabBarHelper.h"
#import "CreateTutorialTextStepViewController.h"
#import "UsersController.h"
#import "MediaPickerHelper.h"
#import "AlertFactory.h"
#import "UIView+FadeAnimations.h"
#import "PublishingTutorialViewController.h"
#import "EditTutorialStepsViewController.h"
#import "ColorsHelper.h"
#import "UserDefaultsHelper.h"
#import "OrientationChangeDetector.h"
#import "UIImagePickerExtendedEventsObserver.h"
#import "InterfaceOrientationViewControllerDecorator.h"
#import "ViewControllerPresentationHelper.h"


static NSString *const kTakePhotoGridEnabledKey = @"TakePhotoGridEnabled";


@interface CreateTutorialViewController () <CreateTutorialStepButtonsDelegate, FDTakeDelegate, YCameraViewControllerDelegate, OrientationChangeDelegate, ExtendedUIImagePickerControllerDelegate>

@property (strong, nonatomic) CreateTutorialHeaderViewController *headerViewController;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;
@property (strong, nonatomic) FDTakeController *mediaController;

@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (weak, nonatomic) IBOutlet CreateTutorialStepButtonsContainerView *createTutoriaStepButtonsView;
@property (weak, nonatomic) IBOutlet UIView *popoverView;

@property (weak, nonatomic) UIBarButtonItem *publishButton;
@property (weak, nonatomic) UIButton *editButton;

@property (strong, nonatomic) NSManagedObjectContext *createTutorialContext;
@property (strong, nonatomic) Tutorial *tutorial;
@property (strong, nonatomic) EditTutorialStepsViewController *editTutorialStepsViewController;
@property (strong, nonatomic) UIGestureRecognizer *tapGestureRecognizer;


@property (nonatomic, strong) OrientationChangeDetector *orientationChangeDetector;
@property (nonatomic, strong) UIAlertView *portraitOrientationAlertView;
@property (nonatomic, strong) UIImagePickerExtendedEventsObserver *imagePickerEventsObserver;

@end


@implementation CreateTutorialViewController

#pragma mark - Initialization

+ (void)initialize
{
  [[InterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupNavigationBarButtons];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  [self setupTableView];
  self.createTutoriaStepButtonsView.delegate = self;

  [self initializeContextAndNewTutorialObject]; // Where should we do that? This doesn't seem to be a correct place...
  
  [self setupTutorialStepsDataSource];
  [self performDebugActions];
  [self addGestureRecognizer];
  
  // TODO: Technical debt! We shouldn't delay it like that!!
  defineWeakSelf();
  DISPATCH_AFTER(0.01, ^{
    [weakSelf disableEditButton];
  });
}

- (void)addGestureRecognizer
{
  self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  self.tapGestureRecognizer.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
  [self.view endEditing:YES];
}

- (void)setupTableView
{
  self.tutorialTableView.backgroundColor = [UIColor whiteColor];
  
  self.tutorialTableView.rowHeight = UITableViewAutomaticDimension;
  self.tutorialTableView.estimatedRowHeight = 100.f;
  
  [self setupAndAttachHeaderViewController];
  self.tutorialTableView.tableFooterView = [self smallTransparentFooterView];
}

- (UIView *)smallTransparentFooterView
{
  UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
  footer.backgroundColor = [UIColor clearColor];
  return footer;
}

#pragma mark - View layout and setup

- (void)setupAndAttachHeaderViewController
{
  self.headerViewController = [[CreateTutorialHeaderViewController alloc] init];
  self.headerViewController.imagePickerPresentingViewController = self;
  
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
  
  defineWeakSelf();
  self.tutorialStepsDataSource.cellDeletionCompletionBlock = ^() {
    [weakSelf updateEditButtonEnabled];
  };
}

#pragma mark - DEBUG

- (void)performDebugActions
{
  if (DEBUG_MODE_ADD_TUTORIAL_STEPS) {
    //    [self DEBUG_addTextTutorialStep];
    [self DEBUG_addImageStep];
  }
  
  if (DEBUG_MODE_FLOW_EDIT_TUTORIAL) {
    [self DEBUG_addTwoTextOneImageAndVideoStep];
    
    defineWeakSelf();
    DISPATCH_AFTER(0.2, ^{
      [weakSelf editButtonPressed];
    });
  }
  
  if (DEBUG_MODE_FLOW_PUBLISH_TUTORIAL) {
    [self DEBUG_pressPublishButton];
  }
  
  if (DEBUG_MODE_ADD_PHOTO) {
    defineWeakSelf();
    DISPATCH_AFTER(0.5, ^{
      [weakSelf addPhotoStepSelected];
    });
  }
}

- (void)DEBUG_pressPublishButton
{
  defineWeakSelf();
  DISPATCH_AFTER(0.1, ^{
    [weakSelf publishButtonPressed];
  });
}

- (void)DEBUG_addTextTutorialStep
{
  TutorialStep *step1 = [TutorialStep tutorialStepWithText:@"\"This is a comment, Great for talking through key parts of the tutorial!\"" inContext:self.createTutorialContext];
  step1.orderValue = 1;
  [self.tutorial.consistsOfSet addObject:step1];
}

- (void)DEBUG_addTwoTextTutorialSteps
{
  [self DEBUG_addTextTutorialStep];
  
  TutorialStep *step2 = [TutorialStep tutorialStepWithText:@"debug text 2!" inContext:self.createTutorialContext];
  step2.orderValue = 2;
  [self.tutorial.consistsOfSet addObject:step2];
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
  
  if (!DEBUG_MODE_FLOW_PUBLISH_TUTORIAL) {
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
  
  UIView *buttonContainer = [[UIView alloc] initWithFrame:buttonRect];
  UIButton *editButton = [NavigationBarCustomizationHelper buttonWithFrame:buttonRect title:@"Edit" target:self action:@selector(editButtonPressed)];
  [buttonContainer addSubview:editButton];
  self.editButton = editButton;
  
  self.navigationItem.titleView = buttonContainer;
}

- (void)removeNavigationBarButtons
{
  self.navigationItem.leftBarButtonItem = nil;
  self.navigationItem.rightBarButtonItem = nil;
  self.navigationItem.titleView = nil;
}


#pragma mark - Edit button manipulation
// TODO: extract this away from this class!

- (void)updateEditButtonEnabled
{
  ([self tutorialHasAnySteps] ? [self enabledEditButton] : [self disableEditButton]);
}

- (void)enabledEditButton
{
  self.editButton.titleLabel.textColor = [ColorsHelper navigationBarButtonsColor];
  self.editButton.userInteractionEnabled = YES;
}

- (void)disableEditButton
{
  self.editButton.titleLabel.textColor = [ColorsHelper navigationBarDisabledButtonsColor];
  self.editButton.userInteractionEnabled = NO;
}

- (BOOL)tutorialHasAnySteps
{
  return (self.tutorial.consistsOf.count);
}

#pragma mark - Actions

- (void)editButtonPressed
{
  NSOrderedSet *tutorialSteps = self.tutorial.consistsOf;
  if (![self tutorialHasAnySteps]) {
    return;
  }
  
  self.editTutorialStepsViewController = [self createEditTutorialStepsViewControllerWithTutorialSteps:(NSOrderedSet *)tutorialSteps];
  [[ViewControllerPresentationHelper new] presentViewControllerInKeyWindow:self.editTutorialStepsViewController];
  
  [self removeNavigationBarButtons];
}

- (EditTutorialStepsViewController *)createEditTutorialStepsViewControllerWithTutorialSteps:(NSOrderedSet *)tutorialSteps
{
  AssertTrueOrReturnNil(tutorialSteps.count);
  
  EditTutorialStepsViewController *editTutorialStepsViewController = [[EditTutorialStepsViewController alloc] initWithTutorialSteps:tutorialSteps.array];
  
  defineWeakSelf();
  editTutorialStepsViewController.dismissBlock = ^(BOOL saveChanges, NSArray *steps){
    [weakSelf.editTutorialStepsViewController.view removeFromSuperview];
    [weakSelf setupNavigationBarButtons];
    
    if (saveChanges && steps) {
      [weakSelf.tutorial removeConsistsOf:weakSelf.tutorial.consistsOf];
      [weakSelf.tutorial addConsistsOf:[[NSOrderedSet alloc] initWithArray:steps]];
      
      [weakSelf saveTutorial];
      [weakSelf.tutorialTableView reloadData];
    }
  };
  return editTutorialStepsViewController;
}

- (void)publishButtonPressed
{
  [self updateTutorialModelFromUI];
  
  if (DEBUG_MODE_FLOW_PUBLISH_TUTORIAL) {
    [self DEBUG_publishTutorial];
  }
  
  BOOL tutorialDataComplete = YES;
  if (!DEBUG_MODE_FLOW_PUBLISH_TUTORIAL) {
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
  
  [self DEBUG_addTwoTextTutorialSteps];
  [self DEBUG_addImageStep];
  [self DEBUG_addVideoStep];
}

- (void)DEBUG_addTwoTextOneImageAndVideoStep
{
  [self DEBUG_addTwoTextTutorialSteps];
  [self DEBUG_addImageStep];
  [self DEBUG_addVideoStep];
}

- (void)DEBUG_addImageStep
{
  TutorialStep *imageStep1 = [TutorialStep tutorialStepWithImage:[UIImage imageNamed:@"bubble"] inContext:self.createTutorialContext];
  imageStep1.orderValue = 3;
  [self.tutorial.consistsOfSet addObject:imageStep1];
}

- (void)DEBUG_addVideoStep
{
  NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"TestVideo" withExtension:@"mp4"];
  AssertTrueOrReturn(videoURL);
  TutorialStep *videoStep1 = [TutorialStep tutorialStepWithVideoURL:videoURL inContext:self.createTutorialContext];
  videoStep1.orderValue = 4;
  [self.tutorial.consistsOfSet addObject:videoStep1];
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
  [self takeOrSelectPhotoUsingYCameraView];
}

- (void)takeOrSelectPhotoUsingFDTake
{
  AssertTrueOrReturn(self.mediaController);
  [self.mediaController takePhotoOrChooseFromLibrary];
}

- (void)takeOrSelectPhotoUsingYCameraView
{
  YCameraViewController *controller = [YCameraViewController new];
  controller.prefersStatusBarHidden = YES;
  controller.gridInitiallyHidden = ![self getUserDefaultsGridEnabled];
  controller.delegate = self;
  [self presentViewController:controller animated:YES completion:nil];
  
  controller.cameraToggleButton.hidden = YES;
  controller.cancelButton.hidden = YES;
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
    return;
  }
  [self pushCreateTutorialTextStepViewController];
}

// TODO: change this to an overlay view!!!
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

#pragma mark - Video orientation alerts

- (void)checkOrientationPresentAlertForPortrait
{
  AssertTrueOrReturn(self.orientationChangeHelper);
  if (UIInterfaceOrientationIsPortrait(self.orientationChangeHelper.lastInterfaceOrientation)) {
    [self presentPortraitOrientationAlert];
  }
}

- (void)presentPortraitOrientationAlert
{
  self.portraitOrientationAlertView = [AlertFactory showOnlyLandscapeVideoSupportedAlertView];
}

- (void)hidePortraitOrientationAlert
{
  [self.portraitOrientationAlertView dismissWithClickedButtonIndex:0 animated:YES];
  self.portraitOrientationAlertView = nil;
}

#pragma mark - ExtendedUIImagePickerControllerDelegate

- (void)imagePickerControllerUserDidCaptureItem
{
  [self.orientationChangeHelper stopDetectingOrientationChanges];
}

- (void)imagePickerControllerUserDidPressRetake
{
  [self.orientationChangeHelper startDetectingOrientationChanges];
  [self checkOrientationPresentAlertForPortrait];
}

#pragma mark - OrientationChangeHelper

- (void)orientationDidChangeToPortrait
{
  [self presentPortraitOrientationAlert];
}

- (void)orientationDidChangeToLandscape
{
  [self hidePortraitOrientationAlert];
}

#pragma mark - YCameraViewControllerDelegate

- (void)yCameraController:(YCameraViewController *)cameraController didFinishPickingImage:(UIImage *)image
{
  AssertTrueOrReturn(image);
  [self saveTutorialStepWithImage:image];
  
  AssertTrueOrReturn(cameraController);
  [self saveInUserDefaultsGridEnabled:[cameraController gridEnabled]];
}

- (void)yCameraControllerDidCancel:(YCameraViewController *)cameraController
{
  AssertTrueOrReturn(cameraController);
  [self saveInUserDefaultsGridEnabled:[cameraController gridEnabled]];
}

- (void)yCameraControllerDidSkip:(YCameraViewController *)cameraController
{
  AssertTrueOrReturn(cameraController);
  [self saveInUserDefaultsGridEnabled:[cameraController gridEnabled]];
}

#pragma mark - UserDefaults

- (void)saveInUserDefaultsGridEnabled:(BOOL)gridEnabled
{
  [[UserDefaultsHelper new] setObject:@(gridEnabled) forKeyAndSave:kTakePhotoGridEnabledKey];
}

- (BOOL)getUserDefaultsGridEnabled
{
  return [[[UserDefaultsHelper new] getObjectForKey:kTakePhotoGridEnabledKey] boolValue];
}

#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
  AssertTrueOrReturn(photo);
  [self saveTutorialStepWithImage:photo];
}

- (void)takeController:(FDTakeController *)controller gotVideo:(NSURL *)video withInfo:(NSDictionary *)info
{
  self.imagePickerEventsObserver = nil;
  
  AssertTrueOrReturn(video);
  [self saveTutorialStepWithVideoURL:video];
}

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
  [self.orientationChangeHelper stopDetectingOrientationChanges];
  self.imagePickerEventsObserver = nil;
}

- (void)takeControllerDidStartTakingVideo:(FDTakeController *)controller
{
  [self.orientationChangeHelper startDetectingOrientationChanges];
  self.imagePickerEventsObserver = [[UIImagePickerExtendedEventsObserver alloc] initWithDelegate:self];
  
  [self checkOrientationPresentAlertForPortrait];
}

#pragma mark - Push views

- (void)pushCreateTutorialTextStepViewController
{
  __weak typeof(self) weakSelf = self;
  CreateTutorialTextStepViewController *viewController = [[CreateTutorialTextStepViewController alloc] initWithCompletion:^(NSString *text, NSError *error) {
    if (!error && text.length) {
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
  [self updateEditButtonEnabled];
}

#pragma mark - Saving tutorial

- (void)saveTutorial
{
  [self fillRequiredFieldsForTutorial:self.tutorial];
  [self.createTutorialContext MR_saveOnlySelfAndWait];
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
    _mediaController = [MediaPickerHelper fdTakeControllerWithDelegate:self viewControllerForPresentingImagePickerController:self.navigationController];
    _mediaController.allowsEditingVideo = NO; // otherwise - alert..
  }
  return _mediaController;
}

- (OrientationChangeDetector *)orientationChangeHelper
{
  if (!_orientationChangeDetector) {
    _orientationChangeDetector = [OrientationChangeDetector new];
    _orientationChangeDetector.delegate = self;
  }
  return _orientationChangeDetector;
}

@end
