//
//  PlayerAid
//

@import Foundation;
#import "Tutorial.h"

/**
 This class needs to exist between when you order it to make a backup and request to retrieve from backup. Otherwise backed up tutorial reference will be empty. 
 */
@interface TutorialBackupManager : NSObject

- (void)backupTutorial:(nonnull Tutorial *)tutorial;
- (void)restoreTutorialFromBackup;

@end
