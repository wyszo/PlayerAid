//
//  PlayerAid
//

#import <UIKit/UIKit.h>


@interface UIView (XibLoading)

+ (UIView *)viewFromNibNamed:(NSString *)nibName withOwner:(UIView *)owner;

- (void)loadView:(UIView *)view fromNibNamed:(NSString *)nibName;

@end
