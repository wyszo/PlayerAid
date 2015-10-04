//
//  PlayerAid
//

@import Foundation;

@protocol TutorialsTableViewDelegate <NSObject>

@optional
- (void)didSelectRowWithTutorial:(Tutorial *)tutorial;
- (void)numberOfRowsDidChange:(NSInteger)numberOfRows;

@end
