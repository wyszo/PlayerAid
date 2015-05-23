//
//  PlayerAid
//

#import "CreateTutorialViewController.h"
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


@interface CreateTutorialViewController () <SaveTutorialDelegate, CreateTutorialStepButtonsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) CreateTutorialHeaderViewController *headerViewController;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;


@property (weak, nonatomic) IBOutlet CreateTutorialStepButtonsView *createTutoriaStepButtonsView;

@property (strong, nonatomic) NSManagedObjectContext *createTutorialContext;
@property (strong, nonatomic) Tutorial *tutorial;

@end


@implementation CreateTutorialViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupNavigationBarButtons];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.headerViewController = [[CreateTutorialHeaderViewController alloc] init];
  self.headerViewController.imagePickerControllerDelegate = self;
  self.headerViewController.saveDelegate = self;
  self.tutorialTableView.tableHeaderView = self.headerViewController.view;
  
  self.createTutoriaStepButtonsView.delegate = self;
  
  // Where should we do that? This doesn't seem to be a correct place...
  [self initializeContextAndNewTutorialObject];
  
  AssertTrueOrReturn(self.tutorial);
  AssertTrueOrReturn(self.tutorialTableView);
  self.tutorialStepsDataSource = [[TutorialStepsDataSource alloc] initWithTableView:self.tutorialTableView tutorial:self.tutorial context:self.createTutorialContext allowsEditing:YES];
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
  
  self.navigationItem.rightBarButtonItem.enabled = NO;
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
  
  [self.tutorialTableView setEditing:(!self.tutorialTableView.editing) animated:YES];
}

- (void)publishButtonPressed
{
  // TODO: publish tutorial
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CreateTutorialStepButtonsDelegate

- (void)addPhotoStepSelected
{
  
}

- (void)addVideoStepSelected
{
  
}

- (void)addTextStepSelected
{
  if (self.tutorialTableView.isEditing) {
    [self.tutorialTableView setEditing:NO animated:YES];
    return;
  }
  [self pushCreateTutorialTextStepViewController];
}

- (void)fillRequiredFieldsForTutorial:(Tutorial *)tutorial
{
  if (!tutorial.title) {
    tutorial.title = @"";
  }
  if (!tutorial.createdAt) {
    tutorial.createdAt = [NSDate new];
  }
}

#pragma mark - Push views

- (void)pushCreateTutorialTextStepViewController
{
  CreateTutorialTextStepViewController *viewController = [[CreateTutorialTextStepViewController alloc] initWithNibName:@"CreateTutorialTextStepView" bundle:nil];
  
  static NSInteger tutorialStepsCounter;
  tutorialStepsCounter++;
  NSString *temporaryText = [NSString stringWithFormat:@"Sample tutorial step %li", (long)tutorialStepsCounter];
  
  __weak typeof(self) weakSelf = self;
  viewController.completionBlock = ^(BOOL shouldSaveStep, NSString *text) {
    if (shouldSaveStep) {
      [weakSelf saveTutorialStepWithText:temporaryText]; // should pass 'text' here
    }
  };
  
  UINavigationController *modalNavigationController = self.navigationController;
  AssertTrueOrReturn(modalNavigationController);
  [modalNavigationController pushViewController:viewController animated:YES];
}

- (void)saveTutorialStepWithText:(NSString *)text
{
  TutorialStep *step = [TutorialStep MR_createInContext:self.createTutorialContext];
  step.text = text;
  
  [self.tutorial addConsistsOfObject:step];
  
  [self fillRequiredFieldsForTutorial:self.tutorial];
  [self.createTutorialContext MR_saveOnlySelfAndWait];
}

#pragma mark - SaveTutorialDelegate

- (void)saveTutorialTitled:(NSString *)title section:(Section *)section
{
  AssertTrueOrReturn(title.length);
  AssertTrueOrReturn(section);
  
  self.tutorial.title = title;
  self.tutorial.createdAt = [NSDate new];
  self.tutorial.primitiveDraftValue = YES;
  [self.tutorial setSection:[section MR_inContext:self.createTutorialContext]];
  
  [self.createTutorialContext MR_saveToPersistentStoreAndWait];
  
  [self dismissViewController];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  self.headerViewController.backgroundImageView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [[[viewController navigationController] navigationBar] setBarStyle:UIBarStyleBlack]; // enforces white image picker statusbar
}

@end
