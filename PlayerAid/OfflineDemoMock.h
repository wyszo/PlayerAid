//
//  OfflineDemoMock.h
//  PlayerAid
//
//  Created by PlayerAid on 14/01/2018.
//

#import <Foundation/Foundation.h>
#import <TWCommonLib/TWCommonLib.h>

@class Tutorial;

@interface OfflineDemoMock : NSObject

NEW_AND_INIT_UNAVAILABLE
SHARED_INSTANCE_GENERATE_INTERFACE

- (NSDictionary *)mockUser;
- (NSArray *)mockGuideDictionaries;
- (void)updateCurrentUserAvatarPath:(NSString *)avatarPath;
- (void)updateCurrentUserName:(NSString *)userName description:(NSString *)description;
- (void)publishTutorial:(Tutorial *)tutorial;

/** returns path */
- (NSString *)saveImageToDocumentsFolder:(UIImage *)image;

@end
