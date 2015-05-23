//
//  PlayerAid
//

@class Tutorial;


@interface PublishingTutorialViewController : UIViewController

@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, copy) void (^completionBlock)(NSError *error);

@end
