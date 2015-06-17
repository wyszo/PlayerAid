//
//  PlayerAid
//

#import <UIKit/UIKit.h>


@interface EditProfileFilterCollectionViewController : UICollectionViewController

@property (nonatomic, assign) NSInteger tutorialsCount;

@property (nonatomic, copy) VoidBlock tutorialsTabSelectedBlock;
@property (nonatomic, copy) VoidBlock likedTabSelectedBlock;
@property (nonatomic, copy) VoidBlock followingTabSelectedBlock;
@property (nonatomic, copy) VoidBlock followersTabSelectedBlock;

@end
