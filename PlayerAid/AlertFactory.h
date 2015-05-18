//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertFactory : NSObject

+ (UIAlertView *)showGenericErrorAlertView;

// Facebook alerts
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error;

@end