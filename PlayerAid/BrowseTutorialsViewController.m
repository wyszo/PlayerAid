//
//  PlayerAid
//

#import "BrowseTutorialsViewController.h"
#import <NSManagedObject+MagicalFinders.h>
#import "Section.h"

@interface BrowseTutorialsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *allSectionsLabel;

@end

@implementation BrowseTutorialsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // TODO: put everything in a tableView instead of just displaying a label
  [self updateSectionsLabel];
}

- (void)updateSectionsLabel
{
  NSArray *allSections = [Section MR_findAll];
  
  NSMutableString *mutableString = [NSMutableString new];
  for (Section *section in allSections) {
    [mutableString appendString:section.name];
    [mutableString appendString:@"\n("];
    [mutableString appendString:section.sectionDescription];
    [mutableString appendString:@")\n\n"];
  }
  self.allSectionsLabel.text = mutableString;
}

@end
