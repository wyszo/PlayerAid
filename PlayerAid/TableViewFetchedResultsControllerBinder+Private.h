//
//  PlayerAid
//

#import "TableViewFetchedResultsControllerBinder.h"


@interface TableViewFetchedResultsControllerBinder (Private)

/**
 Binder won't process any updates while this flag is set to true. Useful for processing user-driven changes
 */
@property (nonatomic, assign) BOOL disabled;

@end
