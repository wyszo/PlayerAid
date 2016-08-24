@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

@class ProfileTabSwitcherViewModel;


@interface ProfileTabSwitcherViewController : UICollectionViewController

@property (nonatomic, strong) ProfileTabSwitcherViewModel *viewModel;

@property (nonatomic, assign) NSInteger tutorialsCount;
@property (nonatomic, assign) NSInteger likedTutorialsCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;

@property (nonatomic, copy) VoidBlock tutorialsTabSelectedBlock;
@property (nonatomic, copy) VoidBlock likedTabSelectedBlock;
@property (nonatomic, copy) VoidBlock followingTabSelectedBlock;
@property (nonatomic, copy) VoidBlock followersTabSelectedBlock;

- (void)updateGuidesCountLabels;

@end
