//
//  PlayerAid
//

#import <Foundation/Foundation.h>

@interface TabBarControllerHandler : NSObject <UITabBarControllerDelegate>

- (instancetype)initWithCreateTutorialItemAction:(void (^)())createTutorialAction;

- (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end
