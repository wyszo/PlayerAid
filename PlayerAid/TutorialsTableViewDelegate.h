//
//  PlayerAid
//

@import Foundation;

@protocol TutorialsTableViewDelegate <NSObject>

@optional
- (void)didSelectRowWithTutorial:(Tutorial *)tutorial;
- (void)numberOfRowsDidChange:(NSInteger)numberOfRows;
- (void)willDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingCellForRowAtIndexPath:(NSIndexPath *)indexPath withTutorial:(Tutorial *)tutorial;

@end
