//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

@interface EditProfileFilterCollectionViewController : UICollectionViewController

@property (nonatomic, assign) NSInteger tutorialsCount;
@property (nonatomic, assign) NSInteger likedTutorialsCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;

@property (nonatomic, copy) VoidBlock tutorialsTabSelectedBlock;
@property (nonatomic, copy) VoidBlock likedTabSelectedBlock;
@property (nonatomic, copy) VoidBlock followingTabSelectedBlock;
@property (nonatomic, copy) VoidBlock followersTabSelectedBlock;

@end
