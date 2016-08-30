//
//  PlayerAid
//

@import Foundation;

@protocol GuidesTableViewDelegate <NSObject>

@optional
- (void)didSelectRowWithGuide:(Tutorial *)tutorial;
- (void)numberOfRowsDidChange:(NSInteger)numberOfRows;
- (void)willDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingCellForRowAtIndexPath:(NSIndexPath *)indexPath withTutorial:(Tutorial *)tutorial;

@end
