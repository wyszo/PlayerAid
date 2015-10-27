//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import AFNetworking;
@import BlocksKit;
#import <KZAsserts/KZAsserts.h>
#import "ImagesPrefetchingController.h"
#import "TutorialTableViewCell+Prefetching.h"
#import "NetworkRequestsPrefetchingController.h"

/** 
 Because everything is sequential, it'll slow down the app if we prefetch more than a couple of images!
 Also the value can't be too low (less than 2 in our case), because if all the cells fit on screen, the algorithm won't kick in 
*/
static const NSInteger kNumberOfCellsToPrefetch = 2;

@interface ImagesPrefetchingController()
@property (nonatomic, retain, nonnull) dispatch_queue_t dispatchQueue;
@property (nonatomic, weak, nullable) TutorialsTableDataSource *dataSource;
@property (nonatomic, weak, nullable) UITableView *tableView;
@property (nonatomic, strong, nonnull) NSIndexPath *furthestPrefetchedIndexPath;
@property (nonatomic, strong, nonnull) NetworkRequestsPrefetchingController *requestsPrefetchingController;
@end

@implementation ImagesPrefetchingController

#pragma mark - Init

- (instancetype)initWithDataSource:(nonnull TutorialsTableDataSource *)dataSource tableView:(nonnull UITableView *)tableView
{
  AssertTrueOrReturnNil(dataSource);
  AssertTrueOrReturnNil(tableView);
  
  self = [super init];
  if (self) {
    _dataSource = dataSource;
    _tableView = tableView;
    _furthestPrefetchedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _requestsPrefetchingController = [NetworkRequestsPrefetchingController new];
    [self setupPrioritySerialBackgroundDispatchQueue];
  }
  return self;
}

- (void)setupPrioritySerialBackgroundDispatchQueue
{
  // QOS_CLASS_USER_INTERACTIVE means it's a high priority queue
  dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0);
  
  self.dispatchQueue = dispatch_queue_create("timelinePrefetchingQueue", attributes);
}

#pragma mark - Public

- (void)willDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  dispatch_sync(self.dispatchQueue, ^{
    for (int i=0; i < kNumberOfCellsToPrefetch; i++) {
      NSInteger rowIndex = indexPath.row + i;
      
      if (self.dataSource.objectCount <= rowIndex) {
        return; // no more rows in tableView
      }
      
      NSIndexPath *prefetchRowIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:indexPath.section];
      if ([prefetchRowIndexPath compare:self.furthestPrefetchedIndexPath] == NSOrderedAscending) {
        return; // this row must have already been prefetched
      }
      
      BOOL cellVisible = [self.tableView.indexPathsForVisibleRows containsObject:prefetchRowIndexPath];
      if (cellVisible) {
        continue; // if cell visible in UI, it's already too late to prefetch, ignore this cell
      } else {
        [self prefetchImageForIndexPath:prefetchRowIndexPath];
      }
    }
  });
}

- (void)didEndDisplayingCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath withTutorial:(nonnull Tutorial *)tutorial{
  AssertTrueOrReturn(indexPath);
  
  AssertTrueOrReturn(self.requestsPrefetchingController);
  [self.requestsPrefetchingController cancelFetchingImageForNetworkForIndexPath:indexPath];
}

#pragma mark - Private

- (void)prefetchImageForIndexPath:(nonnull NSIndexPath *)indexPath
{
  self.furthestPrefetchedIndexPath = indexPath;
  
  AssertTrueOrReturn(indexPath);
  
  Tutorial *tutorial = [self.dataSource tutorialAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  
  NSString *imageURLString = tutorial.imageURL;
  AssertTrueOrReturn(imageURLString);
  
  BOOL imageInAFNetworkingInMemoryCache = [self imageWithURLStringIsInAFNetworkingInMemoryCache:imageURLString];
  
  if (imageInAFNetworkingInMemoryCache) {
    return; // all good, no need to do any work
    // possibly the image has been prefetched in previous algorithm iteration
  } else {
    // image not in AFNetworking in-memory cache, try fetching from a local cache and pass it to AFNetworking cache
    NSCachedURLResponse *response = [[NSURLCache sharedURLCache] tw_cachedHTTPResponseForURLRequestWithURLString:imageURLString];
    
    if (response) {
      UIImage *image = [UIImage imageWithData:response.data];
      AssertTrueOrReturn(image);
      [self saveImageToAFNetworkingInMemoryCacheIfNotCached:image forURLString:imageURLString];
    } else if (!response) {
      [self prefetchFromNetworkImageWithURLString:imageURLString forIndexPath:indexPath];
    }
  }
}

- (void)prefetchFromNetworkImageWithURLString:(nonnull NSString *)imageURLString forIndexPath:(nonnull NSIndexPath *)indexPath
{
  AssertTrueOrReturn(imageURLString.length);
  AssertTrueOrReturn(indexPath);
  AssertTrueOrReturn(self.requestsPrefetchingController);
  
  defineWeakSelf();
  [self.requestsPrefetchingController prefetchImageWithURLString:imageURLString forIndexPath:indexPath completion:^(UIImage *image) {
    if (image) {
      BOOL cellVisible = [weakSelf.tableView.indexPathsForVisibleRows containsObject:indexPath];
      if (cellVisible) {
        TutorialTableViewCell *cell = (TutorialTableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundImageIfNil:image animated:YES];
      }
    }
  }];
}

- (BOOL)imageWithURLStringIsInAFNetworkingInMemoryCache:(nonnull NSString *)imageURLString
{
  AssertTrueOrReturnNo(imageURLString.length);
  
  NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLString]];
  UIImage *image = [[UIImageView sharedImageCache] cachedImageForRequest:imageRequest];
  return (image != nil);
}

- (void)saveImageToAFNetworkingInMemoryCacheIfNotCached:(nonnull UIImage *)image forURLString:(nonnull NSString *)urlString
{
  AssertTrueOrReturn(image);
  AssertTrueOrReturn(urlString.length);
  
  NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
  
  UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:imageRequest];
  if (cachedImage != nil) {
    // for some reason the image is already in cache - but it wasn't when we started prefetching
    // asserting, since it might mean some threading issues with accessing images
    AssertTrueOrReturn(@"Unexpected cache item found while prefetching images");
  } else {
    [[UIImageView sharedImageCache] cacheImage:image forRequest:imageRequest]; // we can do that from a background thread, since underlying NSCache is thread safe!
  }
}

@end
