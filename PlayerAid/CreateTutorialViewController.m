//
//  PlayerAid
//

#import "CreateTutorialViewController.h"
#import <NSManagedObject+MagicalRecord.h>
#import <NSManagedObjectContext+MagicalRecord.h>
#import <NSManagedObject+MagicalFinders.h>
#import <MagicalRecord+Actions.h>
#import <KZAsserts.h>
#import "Tutorial.h"
#import "TutorialStep.h"
#import "Section.h"
#import "User.h"
#import "TutorialStepsDataSource.h"
#import "NavigationBarCustomizationHelper.h"
#import "CreateTutorialHeaderViewController.h"
#import "CreateTutorialStepButtonsView.h"


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
  self.tutorialStepsDataSource = [[TutorialStepsDataSource alloc] initWithTableView:self.tutorialTableView tutorial:self.tutorial];
}

#pragma mark - Context and Tutorial object initialization

- (void)initializeContextAndNewTutorialObject
{
  self.createTutorialContext = [NSManagedObjectContext MR_context];
  AssertTrueOrReturn(self.createTutorialContext);
  
  self.tutorial = [Tutorial MR_createInContext:self.createTutorialContext];
  AssertTrueOrReturn(self.tutorial);
  
  [self.tutorial setDraftValue:YES];
  [self assignTutorialToCurrentUser];
}

- (void)assignTutorialToCurrentUser
{
  // TODO: assign to current user, not the first found in db!
  
  User *user = [User MR_findFirstInContext:self.createTutorialContext];
  AssertTrueOrReturn(user);
  [user addCreatedTutorialObject:self.tutorial];
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
  // Adding a temporary tutorial step
  
  TutorialStep *step = [TutorialStep MR_createInContext:self.createTutorialContext];
  step.text = @"Sample tutorial step";
  
  [self.tutorial addConsistsOfObject:step];
}

#pragma mark - SaveTutorialDelegate

- (void)saveTutorialTitled:(NSString *)title section:(Section *)section
{
  AssertTrueOrReturn(title.length);
  AssertTrueOrReturn(section);
  
  self.tutorial.title = title;
  self.tutorial.createdAt = [NSDate new];
  [self.tutorial setSection:[section MR_inContext:self.createTutorialContext]];
  
  [self.createTutorialContext MR_saveToPersistentStoreAndWait];
  
  [self dismissViewController];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  // TODO: update header view cover photo
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
