//
//  PlayerAid
//

@import KZAsserts;
@import AFNetworking;
@import BlocksKit;
@import TWCommonLib;
#import "NetworkRequestsPrefetchingController.h"

static const NSInteger kMaxConcurentOperations = 1;

// TODO: not ideal - exploiting internal AFNetworking implementation, might break on AFNetworking library updates..
@interface UIImageView (_AFNetworking)
- (AFHTTPRequestOperation *)af_imageRequestOperation;
@end

@interface NetworkRequestsPrefetchingController()
@property (nonatomic, strong, nonnull) NSOperationQueue *secondaryImagesPrefetchingQueue;
@end

@implementation NetworkRequestsPrefetchingController

#pragma mark - Init

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupSecondaryImagesPrefetchingQueue];
  }
  return self;
}

- (void)setupSecondaryImagesPrefetchingQueue {
  self.secondaryImagesPrefetchingQueue = [[NSOperationQueue alloc] init];
  self.secondaryImagesPrefetchingQueue.maxConcurrentOperationCount = kMaxConcurentOperations;
  self.secondaryImagesPrefetchingQueue.qualityOfService = NSQualityOfServiceUtility; /** might bump to Utility if too slow.. */
}

#pragma mark - Public

- (void)prefetchImageWithURLString:(nonnull NSString *)imageURLString forIndexPath:(nonnull NSIndexPath *)indexPath completion:(nullable VoidBlockWithImage)completion {
  AssertTrueOrReturn(imageURLString.length);
  AssertTrueOrReturn(indexPath);
  
  UIImageView *dummyImageView = [[UIImageView alloc] init]; // dummy image just to use it's network requests API
  [self saveImageView:dummyImageView forIndexPath:indexPath];
  
  NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLString]];
  
  defineWeakSelf();
  [dummyImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    
    DISPATCH_SYNC_ON_MAIN_THREAD(^{
      CallBlock(completion, image);
    });
    [weakSelf clearImageViewForIndexPath:indexPath];
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    DISPATCH_SYNC_ON_MAIN_THREAD(^{
      CallBlock(completion, nil);
    });
    [weakSelf clearImageViewForIndexPath:indexPath];
  }];
}

- (void)cancelFetchingImageForNetworkForIndexPath:(nonnull NSIndexPath *)indexPath {
  AssertTrueOrReturn(indexPath);
  
  UIImageView *dummyImageViewForIndexPath = [self dummyImageViewForIndexPath:indexPath];
  AFHTTPRequestOperation *operation = [dummyImageViewForIndexPath af_imageRequestOperation];
  
  NSURLRequest *request = [operation.request copy];
  [dummyImageViewForIndexPath cancelImageRequestOperation];
  
  if (request) {
    [self rescheduleRequestOnALowPriorityQueue:request];
  }
}

#pragma mark - Private

- (void)rescheduleRequestOnALowPriorityQueue:(nonnull NSURLRequest *)request {
  AssertTrueOrReturn(request);
  
  // we don't need to check if the image is already in cache - if it is, AFNetworking will just return without making another network request
  
  AFHTTPRequestOperation *secondaryOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [self.secondaryImagesPrefetchingQueue addOperation:secondaryOperation];
}

#pragma mark - Associated objects

- (void)saveImageView:(nonnull UIImageView *)imageView forIndexPath:(nonnull NSIndexPath *)indexPath {
  AssertTrueOrReturn(imageView);
  AssertTrueOrReturn(indexPath);
  [self bk_associateValue:imageView withKey:(__bridge const void *)(indexPath)];
}

- (nullable UIImageView *)dummyImageViewForIndexPath:(nonnull NSIndexPath *)indexPath {
  AssertTrueOrReturnNil(indexPath);
  return [self bk_associatedValueForKey:(__bridge const void *)(indexPath)];
}

- (void)clearImageViewForIndexPath:(nonnull NSIndexPath *)indexPath {
  AssertTrueOrReturn(indexPath);
  [self bk_associateValue:nil withKey:(__bridge const void *)(indexPath)];
}

@end
