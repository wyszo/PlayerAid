//
//  PlayerAid
//

@protocol CreateTutorialStepButtonsDelegate;


IB_DESIGNABLE
@interface CreateTutorialStepButtonsView : UIView

@property (nonatomic, weak) id<CreateTutorialStepButtonsDelegate> delegate;

@end


@protocol CreateTutorialStepButtonsDelegate <NSObject>
@required
- (void)addPhotoStepSelected;
- (void)addVideoStepSelected;
- (void)addTextStepSelected;
@end
