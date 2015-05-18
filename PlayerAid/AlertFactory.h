//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertFactory : NSObject
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error;
@end