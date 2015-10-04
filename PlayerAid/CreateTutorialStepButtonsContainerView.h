//
//  PlayerAid
//

@import UIKit;
@import Foundation;

@protocol CreateTutorialStepButtonsDelegate;


IB_DESIGNABLE
@interface CreateTutorialStepButtonsContainerView : UIView

@property (nonatomic, weak) id<CreateTutorialStepButtonsDelegate> delegate;

@end


@protocol CreateTutorialStepButtonsDelegate <NSObject>
@required
- (void)addPhotoStepSelected;
- (void)addVideoStepSelected;
- (void)addTextStepSelected;
@end
