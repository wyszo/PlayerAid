//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertFactory : NSObject

+ (UIAlertView *)showGenericErrorAlertView;

// Create Tutorial alerts
+ (UIAlertView *)showCreateTutorialNoTitleAlertView;
+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView;

// Facebook alerts
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error;

@end