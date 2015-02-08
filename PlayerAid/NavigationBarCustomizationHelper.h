//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationBarCustomizationHelper : NSObject

/**
 Returns a UIButton contained in a UIView, so it can be used as a navigationBar titleView
 */
+ (UIView *)titleViewhWithButtonWithFrame:(CGRect)frame title:(NSString *)buttonTitle target:(id)target action:(SEL)action;

@end
