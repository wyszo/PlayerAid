//
//  PlayerAid
//

@protocol TutorialsTableViewDelegate <NSObject>

@required
- (void)didSelectRowWithTutorial:(Tutorial *)tutorial;

@optional
- (void)numberOfRowsDidChange:(NSInteger)numberOfRows;

@end
