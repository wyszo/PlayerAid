//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tutorial.h"


@interface TutorialStepsDataSource : NSObject 

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

/**
 @param tableView
 @param tutorial  TutorialSteps of which tutorial do we show
 @param context   Optional, can be nil (nil means default context)
 @param allowsEditing  Determines whether we can delete and reorder rows
 */
- (instancetype)initWithTableView:(UITableView *)tableView tutorial:(Tutorial *)tutorial context:(NSManagedObjectContext *)context allowsEditing:(BOOL)allowsEditing;

@end